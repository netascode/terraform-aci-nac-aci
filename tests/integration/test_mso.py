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
from mso import Mso
from util import render_templates, revert_snapshot

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.mso

error_handler = errorhandler.ErrorHandler()

FILTERS_PATH = "jinja_filters/"
TESTS_PATH = "jinja_tests/"
MSO_DEPLOY_TEMPLATES_PATH = "templates/mso/deploy/"
MSO_TEST_TEMPLATES_PATH = "templates/mso/test/"

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


def mso_login(mso_url):
    """Login to MSO and return instance"""
    username = os.getenv("MSO_USERNAME")
    password = os.getenv("MSO_PASSWORD")
    mso_inst = Mso(mso_url, str(username), str(password))
    r = mso_inst.login()
    if r:
        return r, None
    return "", mso_inst


def mso_deploy_config(mso_inst, config_path):
    """Deploy config via a set of json files"""
    for template, params in TEMPLATE_MAPPINGS.items():
        file_path = os.path.join(config_path, template + ".j2")
        folder_path = os.path.join(config_path, template)
        if os.path.exists(file_path):
            with open(file_path, "r") as file:
                data = file.read()
                r = mso_inst.post_or_put(
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
                    r = mso_inst.post_or_put(
                        params["api_path"], data, method=params.get("method", "")
                    )
                    if r:
                        return "Deployment of {} failed: {}.".format(file_path, r)
    return None


def mso_render_run_tests(mso_inst, mso_url, data_paths, output_path):
    """Render MSO test suites and run them using iac-test"""

    def update_references(data):
        match_regex = "%%.*?%.*?%%"
        m = re.search(match_regex, data)
        while m is not None:
            d = m.group().find("%", 2)
            path = m.group()[2:d]
            key = m.group()[d + 1 : -2]
            id = mso_inst._lookup(path, key).get("id")
            if id is None:
                sys.exit("Lookup failed for key '{}'".format(key))
            data = re.sub(m.group(), id, data)
            m = re.search(match_regex, data)
        return data

    error = render_templates(
        data_paths,
        output_path,
        MSO_TEST_TEMPLATES_PATH,
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

    os.environ["MSO_URL"] = mso_url
    try:
        iac_test.pabot.run_pabot(output_path)
    except SystemExit as e:
        if e.code != 0:
            return "Robot testing failed."
    return None


@pytest.mark.parametrize(
    "data_paths, vm_name, snapshot_name, mso_url, mso_backup_id",
    [
        (
            ["tests/integration/fixtures/mso/standard/", "defaults/"],
            "BUILD1-ACISIM2",
            "Day2",
            "https://10.51.77.52",
            "5f0491f42900009600dd040d",
        )
    ],
)
def test_mso(data_paths, vm_name, snapshot_name, mso_url, mso_backup_id, tmpdir):
    """Deploy config to MSO instance and run tests"""

    # Render templates
    error = render_templates(
        data_paths,
        tmpdir.strpath,
        MSO_DEPLOY_TEMPLATES_PATH,
        filters_path=FILTERS_PATH,
        tests_path=TESTS_PATH,
    )
    if error:
        pytest.fail(error)

    # Revert ACI simulator snapshot
    revert_snapshot(vm_name, snapshot_name)

    # MSO login
    error, mso_inst = mso_login(mso_url)
    if error:
        pytest.fail(error)

    # Revert MSO config
    error = mso_inst.post_or_put("backups/{}/restore".format(mso_backup_id), "", "PUT")
    if error:
        pytest.fail(error)

    # Enable retries
    mso_inst.enable_retries()

    # Configure MSO
    error = mso_deploy_config(mso_inst, tmpdir.strpath)
    if error:
        pytest.fail(error)

    # Render and run tests
    error = mso_render_run_tests(
        mso_inst, mso_url, data_paths, os.path.join(tmpdir, "results/")
    )
    shutil.copy(os.path.join(tmpdir, "results/", "log.html"), "mso_log.html")
    shutil.copy(os.path.join(tmpdir, "results/", "report.html"), "mso_report.html")
    shutil.copy(os.path.join(tmpdir, "results/", "output.xml"), "mso_output.xml")
    shutil.copy(os.path.join(tmpdir, "results/", "xunit.xml"), "mso_xunit.xml")
    if error:
        pytest.fail(error)
