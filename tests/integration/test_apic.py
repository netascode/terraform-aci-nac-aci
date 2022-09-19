# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import pytest
import os
import errorhandler
import shutil

import iac_test.pabot
from aci import Apic
from util import render_templates, revert_snapshot

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.apic

error_handler = errorhandler.ErrorHandler()

FILTERS_PATH = "jinja_filters/"
APIC_DEPLOY_TEMPLATES_PATH = "templates/apic/deploy/"
APIC_TEST_TEMPLATES_PATH = "templates/apic/test/"


def apic_deploy_config(apic_ip, config_path):
    """Deploy config via a set of json files"""
    username = os.getenv("ACI_USERNAME")
    password = os.getenv("ACI_PASSWORD")
    apic = Apic(apic_ip, username, password)
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
        iac_test.pabot.run_pabot(output_path, "", "")
    except SystemExit as e:
        if e.code != 0:
            return "Robot testing failed."
    return None


@pytest.mark.parametrize(
    "data_paths, vm_name, snapshot_name, apic_url",
    [
        (
            ["tests/integration/fixtures/apic/standard/", "defaults/"],
            "BUILD1-ACISIM1",
            "Bootstrap",
            "https://10.51.77.39",
        )
    ],
)
def test_apic(data_paths, vm_name, snapshot_name, apic_url, tmpdir):
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
    shutil.copy(os.path.join(tmpdir, "results/", "log.html"), "apic_log.html")
    if error:
        pytest.fail(error)
