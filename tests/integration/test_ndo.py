# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import os
import re
import shutil
import sys
import time

import errorhandler
import iac_test.pabot
import pytest
from aci import Apic
from ndo import Ndo
from util import render_templates

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.ndo

error_handler = errorhandler.ErrorHandler()

FILTERS_PATH = "jinja_filters/"
TESTS_PATH = "jinja_tests/"
NDO_DEPLOY_TEMPLATES_PATH = "templates/ndo/deploy/"
NDO_TEST_TEMPLATES_PATH = "templates/ndo/test/"

TEMPLATE_MAPPINGS = {
    "system_config": {
        "api_path": "platform/systemConfig",
    },
    "remote_location": {
        "api_path": "platform/remote-locations",
    },
    "site": {
        "api_path": "sites/manage",
    },
    "fabric_connectivity": {
        "api_path": "sites/fabric-connectivity",
    },
    "tenant": {
        "api_path": "tenants",
    },
    "schema": {
        "api_path": "schemas",
    },
    "dhcp_relay": {
        "api_path": "policies/dhcp/relay",
    },
    "dhcp_option": {
        "api_path": "policies/dhcp/option",
    },
}


def apic_revert(apic_url, snapshot):
    """Revert APIC to snapshot"""
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
    payload = (
        '{"configImportP":{"attributes":{"dn":"uni/fabric/configimp-default","name":"default","snapshot":"true","adminSt":"triggered","fileName":"'
        + snapshot
        + '","importType":"replace","importMode":"atomic","rn":"configimp-default","status":"created,modified"},"children":[]}}'
    )
    r = apic.post(payload, url="/api/node/mo/uni/fabric/configimp-default.json")
    if r:
        return "Reverting to APIC snapshot failed."
    return None


def ndo_login(ndo_url):
    """Login to NDO and return instance"""
    username = os.getenv("MSO_USERNAME")
    password = os.getenv("MSO_PASSWORD")
    ndo_inst = Ndo(ndo_url, str(username), str(password))
    r = ndo_inst.login()
    if r:
        return r, None
    return "", ndo_inst


def ndo_deploy_config(ndo_inst, config_path):
    """Deploy config via a set of json files"""
    for template, params in TEMPLATE_MAPPINGS.items():
        file_path = os.path.join(config_path, template + ".j2")
        folder_path = os.path.join(config_path, template)
        if os.path.exists(file_path):
            with open(file_path, "r") as file:
                data = file.read()
                r = ndo_inst.post_or_put(params["api_path"], data)
                if r:
                    return "Deployment of {} failed: {}.".format(file_path, r)
        elif os.path.exists(folder_path):
            for filename in os.listdir(folder_path):
                if ".j2" not in filename:
                    continue
                with open(os.path.join(folder_path, filename), "r") as file:
                    data = file.read()
                    r = ndo_inst.post_or_put(params["api_path"], data)
                    if r:
                        return "Deployment of {} failed: {}.".format(file_path, r)
    return None


def ndo_render_run_tests(ndo_inst, ndo_url, data_paths, output_path):
    """Render NDO test suites and run them using iac-test"""

    def update_references(data):
        match_regex = "%%.*?%.*?%%"
        m = re.search(match_regex, data)
        while m is not None:
            d = m.group().find("%", 2)
            path = m.group()[2:d]
            key = m.group()[d + 1 : -2]
            id = ndo_inst._lookup(path, key).get("id")
            if id is None:
                sys.exit("Lookup failed for key '{}'".format(key))
            data = re.sub(m.group(), id, data)
            m = re.search(match_regex, data)
        return data

    error = render_templates(
        data_paths,
        output_path,
        NDO_TEST_TEMPLATES_PATH,
        filters_path=FILTERS_PATH,
        tests_path=TESTS_PATH,
    )
    if error:
        pytest.fail(error)
    for dir, subdir, files in sorted(os.walk(output_path)):
        for filename in sorted(files):
            if ".robot" in filename:
                with open(os.path.join(dir, filename), "r") as file:
                    data = file.read()
                    data = update_references(data)
                with open(os.path.join(dir, filename), "w") as file:
                    file.write(data)

    os.environ["MSO_URL"] = ndo_url
    try:
        iac_test.pabot.run_pabot(output_path)
    except SystemExit as e:
        if e.code != 0:
            return "Robot testing failed."
    return None


@pytest.mark.parametrize(
    "data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id",
    [
        (
            ["tests/integration/fixtures/ndo/standard/", "defaults/"],
            "https://10.51.77.63",
            "ce2_defaultOneTime-2023-04-27T09-13-37.tar.gz",
            "https://10.51.77.52",
            "644a3e01532fc3f658849258",
        )
    ],
)
def test_ndo(data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, tmpdir):
    """Deploy config to NDO instance and run tests"""

    # Render templates
    error = render_templates(
        data_paths,
        tmpdir.strpath,
        NDO_DEPLOY_TEMPLATES_PATH,
        filters_path=FILTERS_PATH,
        tests_path=TESTS_PATH,
    )
    if error:
        pytest.fail(error)

    # Revert APIC snapshot
    error = apic_revert(apic_url, snapshot_name)
    if error:
        pytest.fail(error)

    # NDO login
    error, ndo_inst = ndo_login(ndo_url)
    if error:
        pytest.fail(error)

    # Revert NDO config
    error = ndo_inst.post_or_put("backups/{}/restore".format(ndo_backup_id), "", "PUT")
    if error:
        pytest.fail(error)

    # Enable retries
    # ndo_inst.enable_retries()

    # Configure NDO
    error = ndo_deploy_config(ndo_inst, tmpdir.strpath)
    if error:
        pytest.fail(error)

    # Render and run tests
    error = ndo_render_run_tests(
        ndo_inst, ndo_url, data_paths, os.path.join(tmpdir, "results/")
    )
    shutil.copy(os.path.join(tmpdir, "results/", "log.html"), "ndo_log.html")
    shutil.copy(os.path.join(tmpdir, "results/", "report.html"), "ndo_report.html")
    shutil.copy(os.path.join(tmpdir, "results/", "output.xml"), "ndo_output.xml")
    shutil.copy(os.path.join(tmpdir, "results/", "xunit.xml"), "ndo_xunit.xml")
    if error:
        pytest.fail(error)
