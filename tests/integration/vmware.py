# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import atexit
import time

from pyVim.connect import Disconnect, SmartConnect
from pyVmomi import vim

# from pyVim.task import WaitForTask


class Vsphere:
    def __init__(self, host: str, username: str, password: str, port: int = 443):
        self.host = host
        self.username = username
        self.password = password
        self.port = port

        self.instance = SmartConnect(
            host=self.host,
            user=self.username,
            pwd=self.password,
            port=self.port,
            disableSslCertValidation=True,
        )
        atexit.register(Disconnect, self.instance)

    def _get_snapshots_by_name_recursively(self, snapshots, snapname):
        """Helper function to find snapshot by name"""
        snap_obj = []
        for snapshot in snapshots:
            if snapshot.name == snapname:
                snap_obj.append(snapshot)
            else:
                snap_obj = snap_obj + self._get_snapshots_by_name_recursively(
                    snapshot.childSnapshotList, snapname
                )
        return snap_obj

    def vmware_revert_snapshot(self, vm_name, snapshot_name):
        """Revert VM snapshot"""
        content = self.instance.RetrieveContent()

        # Find VM
        folder = content.rootFolder
        vm = None
        container = content.viewManager.CreateContainerView(
            folder, [vim.VirtualMachine], True
        )

        for managed_object_ref in container.view:
            if managed_object_ref.name == vm_name:
                vm = managed_object_ref
                break
        container.Destroy()

        # Find snapshot
        snap_obj = self._get_snapshots_by_name_recursively(
            vm.snapshot.rootSnapshotList, snapshot_name
        )

        # WaitForTask is broken in pyvmomi 8.0, https://github.com/vmware/pyvmomi/issues/993
        # WaitForTask(snap_obj[0].snapshot.RevertToSnapshot_Task())

        snap_obj[0].snapshot.RevertToSnapshot_Task()
        time.sleep(20)
