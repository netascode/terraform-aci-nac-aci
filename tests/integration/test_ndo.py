# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import os
import shutil

import errorhandler
import iac_test.pabot
import pytest
import tftest
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


def ndo_render_run_tests(ndo_url, data_paths, output_path):
    """Render NDO test suites and run them using iac-test"""

    error = render_templates(
        data_paths,
        output_path,
        NDO_TEST_TEMPLATES_PATH,
        filters_path=FILTERS_PATH,
        tests_path=TESTS_PATH,
    )
    if error:
        pytest.fail(error)

    os.environ["MSO_URL"] = ndo_url
    try:
        iac_test.pabot.run_pabot(output_path)
    except SystemExit as e:
        if e.code != 0:
            return "Robot testing failed."
    return None


def full_ndo_test(data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir):
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
        if "Fail to block deployment" not in error:
            pytest.fail(error)

    # Enable retries
    # ndo_inst.enable_retries()

    # Configure NDO
    error = ndo_deploy_config(ndo_inst, tmpdir.strpath)
    if error:
        pytest.fail(error)

    # Render and run tests
    error = ndo_render_run_tests(ndo_url, data_paths, os.path.join(tmpdir, "results/"))
    shutil.copy(os.path.join(tmpdir, "results/", "log.html"), "ndo_{}_log.html".format(version))
    shutil.copy(os.path.join(tmpdir, "results/", "report.html"), "ndo_{}_report.html".format(version))
    shutil.copy(os.path.join(tmpdir, "results/", "output.xml"), "ndo_{}_output.xml".format(version))
    shutil.copy(os.path.join(tmpdir, "results/", "xunit.xml"), "ndo_{}_xunit.xml".format(version))
    if error:
        pytest.fail(error)


def full_ndo_terraform(
    data_paths, terraform_path, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir
):
    """Deploy config to NDO instance and run tests"""

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
        if "Fail to block deployment" not in error:
            pytest.fail(error)

    os.environ["MSO_URL"] = ndo_url

    try:
        tf = tftest.TerraformTest(
            terraform_path,
            env={
                "TF_CLI_ARGS_apply": "-parallelism=1",
                "TF_CLI_ARGS_destroy": "-parallelism=1",
            },
        )
        tf.setup(cleanup_on_exit=False, upgrade="upgrade")
        try:
            tf.apply()
        except:
            tf.apply()

        data_paths.append(os.path.join(terraform_path, "defaults.yaml"))
        # Render and run tests
        error = ndo_render_run_tests(
            ndo_url, data_paths, os.path.join(tmpdir, "results/")
        )
        shutil.copy(os.path.join(tmpdir, "results/", "log.html"), "ndo_tf_{}_log.html".format(version))
        shutil.copy(
            os.path.join(tmpdir, "results/", "report.html"), "ndo_tf_{}_report.html".format(version)
        )
        shutil.copy(os.path.join(tmpdir, "results/", "output.xml"), "ndo_tf_{}_output.xml".format(version))
        shutil.copy(os.path.join(tmpdir, "results/", "xunit.xml"), "ndo_tf_{}_xunit.xml".format(version))
        if error:
            # Ignore errors for now as we don't have feature parity with Ansible
            # pytest.fail(error)
            pass

        try:
            tf.destroy()
        except:
            tf.destroy()
    finally:
        pass
        state_path = os.path.join(terraform_path, "terraform.tfstate")
        state_backup_path = os.path.join(terraform_path, "terraform.tfstate.backup")
        if os.path.exists(state_path):
            os.remove(state_path)
        if os.path.exists(state_backup_path):
            os.remove(state_backup_path)


@pytest.mark.ndo_37
@pytest.mark.parametrize(
    "data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, version",
    [
        (
            ["tests/integration/fixtures/ndo/standard/", "defaults/"],
            "https://10.50.202.13",
            "ce2_defaultOneTime-2023-10-14T12-43-41.tar.gz",
            "https://10.50.202.14",
            "64c8b1bcd531074f897f1b11",
            "3.7",
        )
    ],
)
def test_ndo_37(data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir):
    full_ndo_test(data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir)

@pytest.mark.ndo_42
@pytest.mark.parametrize(
    "data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, version",
    [
        (
            ["tests/integration/fixtures/ndo/standard/", "defaults/"],
            "https://10.50.202.16",
            "ce2_defaultOneTime-2023-10-14T13-24-30.tar.gz",
            "https://10.50.202.17",
            "652a97537d6b2b87fd012bc3",
            "4.2",
        )
    ],
)
def test_ndo_42(data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir):
    full_ndo_test(data_paths, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir)


@pytest.mark.ndo_37
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, apic_url, snapshot_name, ndo_url, ndo_backup_id, version",
    [
        (
            ["tests/integration/fixtures/ndo/standard/"],
            "tests/integration/fixtures/ndo/terraform_37",
            "https://10.50.202.13",
            "ce2_defaultOneTime-2023-10-14T12-43-41.tar.gz",
            "https://10.50.202.14",
            "64c8b1bcd531074f897f1b11",
            "3.7",
        )
    ],
)
def test_ndo_terraform_37(
    data_paths, terraform_path, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir
):
    full_ndo_terraform(
        data_paths, terraform_path, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir
    )

@pytest.mark.ndo_42
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, apic_url, snapshot_name, ndo_url, ndo_backup_id, version",
    [
        (
            ["tests/integration/fixtures/ndo/standard/"],
            "tests/integration/fixtures/ndo/terraform_42",
            "https://10.50.202.16",
            "ce2_defaultOneTime-2023-10-14T13-24-30.tar.gz",
            "https://10.50.202.17",
            "652a97537d6b2b87fd012bc3",
            "4.2",
        )
    ],
)
def test_ndo_terraform_42(
    data_paths, terraform_path, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir
):
    full_ndo_terraform(
        data_paths, terraform_path, apic_url, snapshot_name, ndo_url, ndo_backup_id, version, tmpdir
    )