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
from ndo import Ndo
from util import render_templates, revert_snapshot

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
    "tacacs_provider": {
        "api_path": "auth/providers/tacacs",
    },
    "login_domain": {
        "api_path": "auth/domains",
    },
    "remote_location": {
        "api_path": "platform/remote-locations",
    },
    "user": {
        "api_path": "users",
    },
    "ca_certificate": {
        "api_path": "auth/security/certificates",
    },
    "site": {
        "api_path": "sites",
    },
    "fabric_connectivity": {
        "api_path": "sites/fabric-connectivity",
        "method": "put",
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
                r = ndo_inst.post_or_put(
                    params["api_path"], data, method=params.get("method", "")
                )
                if r:
                    return "Deployment of {} failed: {}.".format(file_path, r)
        elif os.path.exists(folder_path):
            for filename in os.listdir(folder_path):
                if ".j2" not in filename:
                    continue
                with open(os.path.join(folder_path, filename), "r") as file:
                    data = file.read()
                    r = ndo_inst.post_or_put(
                        params["api_path"], data, method=params.get("method", "")
                    )
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
    "data_paths, vm_name, snapshot_name, ndo_url, ndo_backup_id",
    [
        (
            ["tests/integration/fixtures/ndo/standard/", "defaults/"],
            "BUILD1-ACISIM2",
            "Day2",
            "https://10.51.77.52",
            "5f0491f42900009600dd040d",
        )
    ],
)
def test_ndo(data_paths, vm_name, snapshot_name, ndo_url, ndo_backup_id, tmpdir):
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

    # Revert ACI simulator snapshot
    revert_snapshot(vm_name, snapshot_name)

    # NDO login
    error, ndo_inst = ndo_login(ndo_url)
    if error:
        pytest.fail(error)

    # Revert NDO config
    error = ndo_inst.post_or_put("backups/{}/restore".format(ndo_backup_id), "", "PUT")
    if error:
        pytest.fail(error)

    # Enable retries
    ndo_inst.enable_retries()

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
