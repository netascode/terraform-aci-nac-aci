# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import os
import shutil

import errorhandler
import iac_test.pabot
import pytest
import tftest
from aci import Apic
from util import render_templates, revert_snapshot

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.apic

error_handler = errorhandler.ErrorHandler()

FILTERS_PATH = "jinja_filters/"
APIC_DEPLOY_TEMPLATES_PATH = "templates/apic/deploy/"
APIC_TEST_TEMPLATES_PATH = "templates/apic/test/"


def apic_deploy_config(apic_url, config_path):
    """Deploy config via a set of json files"""
    username = os.getenv("ACI_USERNAME")
    password = os.getenv("ACI_PASSWORD")
    if not username:
        return "APIC username must be specified with ACI_USERNAME environment variable."
    if not password:
        return "APIC password must be specified with ACI_PASSWORD environment variable."
    apic = Apic(apic_url, username, password)
    r = apic.login()
    if r:
        return "APIC login failed: {}.".format(r)
    for dir, subdir, files in sorted(os.walk(config_path)):
        for filename in sorted(files):
            if ".j2" in filename:
                with open(dir + os.path.sep + filename, "r") as file:
                    data = file.read()
                    r = apic.post(data)
                    if r:
                        return "Deployment of {} failed: {}.".format(filename, r)
    return None


def apic_render_run_tests(apic_url, data_paths, output_path):
    """Render APIC test suites and run them using iac-test"""
    error = render_templates(
        data_paths, output_path, APIC_TEST_TEMPLATES_PATH, filters_path=FILTERS_PATH
    )
    if error:
        pytest.fail(error)
    os.environ["ACI_URL"] = apic_url
    try:
        iac_test.pabot.run_pabot(output_path)
    except SystemExit as e:
        if e.code != 0:
            return "Robot testing failed."
    return None


def full_apic_test(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir):
    """Deploy config to ACI simulator and run tests"""

    # Render templates
    error = render_templates(
        data_paths,
        tmpdir.strpath,
        APIC_DEPLOY_TEMPLATES_PATH,
        filters_path=FILTERS_PATH,
    )
    if error:
        pytest.fail(error)

    # Revert ACI simulator snapshot
    revert_snapshot(vm_name, snapshot_name)

    # Configure ACI simulator
    error = apic_deploy_config(apic_url, tmpdir.strpath)
    if error:
        pytest.fail(error)

    # Run tests
    error = apic_render_run_tests(
        apic_url, data_paths, os.path.join(tmpdir, "results/")
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "log.html"), "apic_{}_log.html".format(version)
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "report.html"),
        "apic_{}_report.html".format(version),
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "output.xml"),
        "apic_{}_output.xml".format(version),
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "xunit.xml"),
        "apic_{}_xunit.xml".format(version),
    )
    if error:
        pytest.fail(error)


def full_apic_terraform_test(
    data_paths, terraform_path, vm_name, snapshot_name, apic_url, version, tmpdir
):
    """Deploy config to ACI simulator using Terraform"""

    # Revert ACI simulator snapshot
    revert_snapshot(vm_name, snapshot_name)

    os.environ["ACI_URL"] = apic_url
    os.environ["ACI_RETRIES"] = "4"

    try:
        tf = tftest.TerraformTest(terraform_path)
        tf.setup(cleanup_on_exit=False, upgrade="upgrade")
        try:
            tf.apply()
        except:
            tf.apply()
    finally:
        state_path = os.path.join(terraform_path, "terraform.tfstate")
        state_backup_path = os.path.join(terraform_path, "terraform.tfstate.backup")
        if os.path.exists(state_path):
            os.remove(state_path)
        if os.path.exists(state_backup_path):
            os.remove(state_backup_path)

    # Run tests
    error = apic_render_run_tests(
        apic_url, data_paths, os.path.join(tmpdir, "results/")
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "log.html"),
        "apic_tf_{}_log.html".format(version),
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "report.html"),
        "apic_tf_{}_report.html".format(version),
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "output.xml"),
        "apic_tf_{}_output.xml".format(version),
    )
    shutil.copy(
        os.path.join(tmpdir, "results/", "xunit.xml"),
        "apic_tf_{}_xunit.xml".format(version),
    )
    if error:
        # Ignore errors for now as we don't have feature parity with CLI/Ansible
        # pytest.fail(error)
        pass


@pytest.mark.apic_42
@pytest.mark.parametrize(
    "data_paths, vm_name, snapshot_name, apic_url, version",
    [
        (
            [
                "tests/integration/fixtures/apic/standard/",
                "tests/integration/fixtures/apic/standard_42/",
                "defaults/",
            ],
            "BUILD1-ACISIM1",
            "Bootstrap",
            "https://10.51.77.39",
            "4.2",
        ),
    ],
)
def test_apic_42(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir):
    full_apic_test(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir)


@pytest.mark.apic_52
@pytest.mark.parametrize(
    "data_paths, vm_name, snapshot_name, apic_url, version",
    [
        (
            [
                "tests/integration/fixtures/apic/standard/",
                "tests/integration/fixtures/apic/standard_52/",
                "defaults/",
            ],
            "BUILD1-ACISIM3",
            "Clean",
            "https://10.51.77.46",
            "5.2",
        ),
    ],
)
def test_apic_52(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir):
    full_apic_test(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir)


@pytest.mark.apic_52
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, vm_name, snapshot_name, apic_url, version",
    [
        (
            [
                "tests/integration/fixtures/apic/standard/",
                "tests/integration/fixtures/apic/standard_52/",
                "defaults/",
            ],
            "tests/integration/fixtures/apic/terraform_52",
            "BUILD1-ACISIM3",
            "Clean",
            "https://10.51.77.46",
            "5.2",
        ),
    ],
)
def test_apic_terraform_52(
    data_paths, terraform_path, vm_name, snapshot_name, apic_url, version, tmpdir
):
    full_apic_terraform_test(
        data_paths, terraform_path, vm_name, snapshot_name, apic_url, version, tmpdir
    )
