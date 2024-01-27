# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import os
import shutil
import subprocess
import time

import errorhandler
import iac_test.pabot
import pytest
from aci import Apic
from util import render_templates, revert_snapshot, terraform_post_process

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.apic

error_handler = errorhandler.ErrorHandler()

FILTERS_PATH = "jinja_filters/"
APIC_DEPLOY_TEMPLATES_PATH = "templates/apic/deploy/"
APIC_TEST_TEMPLATES_PATH = "templates/apic/test/"

PRIORITIZED_TEMPLATES = ["radius.j2"]


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
        sorted_files = sorted(files)
        for filename in PRIORITIZED_TEMPLATES:
            if filename in sorted_files:
                sorted_files.remove(filename)
                sorted_files.insert(0, filename)
        for filename in sorted_files:
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

    # Fix issue with ACI 5.2 simulator
    if version.startswith("5.2"):
        time.sleep(60)

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
    data_paths,
    terraform_path,
    vm_name,
    snapshot_name,
    apic_url,
    version,
    tmpdir,
    terraform_binary="terraform",
):
    """Deploy config to ACI simulator using Terraform"""

    # Revert ACI simulator snapshot
    revert_snapshot(vm_name, snapshot_name)

    os.environ["ACI_URL"] = apic_url
    os.environ["ACI_RETRIES"] = "4"

    try:
        r = subprocess.run(
            [terraform_binary, "init", "-upgrade", "-no-color"],
            cwd=terraform_path,
            capture_output=True,
            text=True,
        )
        terraform_post_process("TERRAFORM INIT", r)

        r = subprocess.run(
            [terraform_binary, "apply", "-auto-approve", "-no-color"],
            cwd=terraform_path,
            capture_output=True,
            text=True,
        )
        terraform_post_process("FIRST TERRAFORM APPLY", r, ignore_errors=True)

        # second apply to work around APIC API quirks
        apply_args = [terraform_binary, "apply", "-auto-approve", "-no-color"]
        if version.startswith("6.0"):
            apply_args.append("-paralellism=3")
        r = subprocess.run(
            apply_args, cwd=terraform_path, capture_output=True, text=True
        )
        terraform_post_process("SECOND TERRAFORM APPLY", r)

        # check idempotency
        r = subprocess.run(
            apply_args, cwd=terraform_path, capture_output=True, text=True
        )
        terraform_post_process("THIRD TERRAFORM APPLY", r)
        if "Your infrastructure matches the configuration." not in r.stdout:
            pytest.fail("Idempotency check failed.")

        # Run tests
        data_paths.append(os.path.join(terraform_path, "defaults.yaml"))
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
            pytest.fail(error)

        destroy_args = [terraform_binary, "destroy", "-auto-approve", "-no-color"]
        if version.startswith("6.0"):
            destroy_args.append("-paralellism=3")
        r = subprocess.run(
            destroy_args,
            cwd=terraform_path,
            capture_output=True,
            text=True,
        )
        terraform_post_process("FIRST TERRAFORM DESTROY", r, ignore_errors=True)
        r = subprocess.run(
            destroy_args,
            cwd=terraform_path,
            capture_output=True,
            text=True,
        )
        terraform_post_process("SECOND TERRAFORM DESTROY", r)
    finally:
        state_path = os.path.join(terraform_path, "terraform.tfstate")
        state_backup_path = os.path.join(terraform_path, "terraform.tfstate.backup")
        if os.path.exists(state_path):
            os.remove(state_path)
        if os.path.exists(state_backup_path):
            os.remove(state_backup_path)


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
            "aac-ci-apic1-4.2.4i",
            "Clean",
            "https://10.50.202.10",
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
            "aac-ci-apic1-5.2.1g",
            "Clean",
            "https://10.50.202.11",
            "5.2",
        ),
    ],
)
def test_apic_52(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir):
    full_apic_test(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir)


@pytest.mark.apic_60
@pytest.mark.parametrize(
    "data_paths, vm_name, snapshot_name, apic_url, version",
    [
        (
            [
                "tests/integration/fixtures/apic/standard/",
                "tests/integration/fixtures/apic/standard_52/",
                "tests/integration/fixtures/apic/standard_60/",
                "defaults/",
            ],
            "aac-ci-apic1-6.0.3d",
            "Clean",
            "https://10.50.202.12",
            "6.0",
        ),
    ],
)
def test_apic_60(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir):
    full_apic_test(data_paths, vm_name, snapshot_name, apic_url, version, tmpdir)


@pytest.mark.apic_42
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, vm_name, snapshot_name, apic_url, version",
    [
        (
            [
                "tests/integration/fixtures/apic/standard/",
                "tests/integration/fixtures/apic/standard_42/",
            ],
            "tests/integration/fixtures/apic/terraform_42",
            "aac-ci-apic1-4.2.4i",
            "Clean",
            "https://10.50.202.10",
            "4.2",
        ),
    ],
)
def test_apic_terraform_42(
    data_paths, terraform_path, vm_name, snapshot_name, apic_url, version, tmpdir
):
    full_apic_terraform_test(
        data_paths, terraform_path, vm_name, snapshot_name, apic_url, version, tmpdir
    )


@pytest.mark.apic_52
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, vm_name, snapshot_name, apic_url, version",
    [
        (
            [
                "tests/integration/fixtures/apic/standard/",
                "tests/integration/fixtures/apic/standard_52/",
            ],
            "tests/integration/fixtures/apic/terraform_52",
            "aac-ci-apic1-5.2.1g",
            "Clean",
            "https://10.50.202.11",
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


@pytest.mark.apic_60
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, vm_name, snapshot_name, apic_url, version, terraform_binary",
    [
        (
            [
                "tests/integration/fixtures/apic/standard/",
                "tests/integration/fixtures/apic/standard_52/",
                "tests/integration/fixtures/apic/standard_60/",
            ],
            "tests/integration/fixtures/apic/terraform_60",
            "aac-ci-apic1-6.0.3d",
            "Clean",
            "https://10.50.202.12",
            "6.0",
            "tofu",
        ),
    ],
)
def test_apic_terraform_60(
    data_paths,
    terraform_path,
    vm_name,
    snapshot_name,
    apic_url,
    version,
    tmpdir,
    terraform_binary,
):
    full_apic_terraform_test(
        data_paths,
        terraform_path,
        vm_name,
        snapshot_name,
        apic_url,
        version,
        tmpdir,
        terraform_binary=terraform_binary,
    )
