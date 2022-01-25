# -*- coding: utf-8 -*-

# Copyright: (c) 2021, Daniel Schmidt <danischm@cisco.com>

import shutil
import subprocess

DIRS = [
    {
        "src": "./ansible-aac/roles/apic_validate/files",
        "dest": "../schemas",
    },
    {
        "src": "./ansible-aac/roles/mso_validate/files",
        "dest": "../schemas",
    },
    {
        "src": "./ansible-aac/roles/apic_deploy/templates",
        "dest": "../templates/apic/deploy",
    },
    {
        "src": "./ansible-aac/roles/mso_deploy/templates",
        "dest": "../templates/mso/deploy",
    },
    {
        "src": "./ansible-aac/roles/test_apic_deploy/templates",
        "dest": "../templates/apic/test",
    },
    {
        "src": "./ansible-aac/roles/test_mso_deploy/templates",
        "dest": "../templates/mso/test",
    },
]

FILES = [
    {
        "src": "./ansible-aac/roles/apic_common/vars/apic_defaults.yaml",
        "dest": "../defaults/apic_defaults.yaml",
    },
    {
        "src": "./ansible-aac/roles/mso_common/vars/mso_defaults.yaml",
        "dest": "../defaults/mso_defaults.yaml",
    },
    {
        "src": "./ansible-aac/roles/apic_common/vars/apic_objects.yaml",
        "dest": "../objects/apic_objects.yaml",
    },
    {
        "src": "./ansible-aac/roles/mso_common/vars/mso_objects.yaml",
        "dest": "../objects/mso_objects.yaml",
    },
]


def update_aac():
    shutil.rmtree("./ansible-aac", ignore_errors=True)
    subprocess.run(
        ["git", "clone", "https://wwwin-github.cisco.com/netascode/ansible-aac.git"]
    )
    # copy files and dirs
    for dir in DIRS:
        shutil.copytree(dir.get("src"), dir.get("dest"), dirs_exist_ok=True)
    for file in FILES:
        shutil.copyfile(file.get("src"), file.get("dest"))
    shutil.rmtree("./ansible-aac", ignore_errors=True)


if __name__ == "__main__":
    update_aac()
