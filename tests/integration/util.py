# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import os

import errorhandler
from iac_test.robot_writer import RobotWriter
from vmware import Vsphere
from requests.adapters import HTTPAdapter

error_handler = errorhandler.ErrorHandler()


def render_templates(
    data_paths, output_path, templates_path, filters_path="", tests_path=""
):
    """Render templates using iac-test package"""
    writer = RobotWriter(data_paths, filters_path, tests_path)
    writer.write(templates_path, output_path)
    if error_handler.fired:
        return "Template rendering failed."
    return ""


def revert_snapshot(vm_name, snapshot_name):
    """Revert VMware VM snapshot"""
    host = os.getenv("VMWARE_HOST")
    user = os.getenv("VMWARE_USER")
    password = os.getenv("VMWARE_PASSWORD")
    port = os.getenv("VMWARE_PORT")
    if port:
        vpshere = Vsphere(host, user, password, int(port))
    else:
        vpshere = Vsphere(host, user, password)
    vpshere.vmware_revert_snapshot(vm_name, snapshot_name)


class TimeoutHTTPAdapter(HTTPAdapter):
    def __init__(self, *args, **kwargs):
        self.timeout = 60  # default timeout
        if "timeout" in kwargs:
            self.timeout = kwargs["timeout"]
            del kwargs["timeout"]
        super().__init__(*args, **kwargs)

    def send(self, request, **kwargs):
        timeout = kwargs.get("timeout")
        if timeout is None:
            kwargs["timeout"] = self.timeout
        return super().send(request, **kwargs)
