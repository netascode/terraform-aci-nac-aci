# -*- coding: utf-8 -*-

# Copyright: (c) 2021, Daniel Schmidt <danischm@cisco.com>

import shutil
import subprocess

ANSIBLE_DIRS = [
    {
        "src": "../validation/rules",
        "dest": "./ansible-aac/roles/apic_validate/files/rules",
    },
    {
        "src": "../templates/apic/deploy",
        "dest": "./ansible-aac/roles/apic_deploy/templates",
    },
    {
        "src": "../templates/mso/deploy",
        "dest": "./ansible-aac/roles/mso_deploy/templates",
    },
    {
        "src": "../templates/apic/test/config",
        "dest": "./ansible-aac/roles/test_apic_deploy/templates/config",
    },
    {
        "src": "../templates/apic/test/health",
        "dest": "./ansible-aac/roles/test_apic_deploy/templates/health",
    },
    {
        "src": "../templates/apic/test/operational",
        "dest": "./ansible-aac/roles/test_apic_deploy/templates/operational",
    },
    {
        "src": "../templates/mso/test/config",
        "dest": "./ansible-aac/roles/test_mso_deploy/templates/config",
    },
]

ANSIBLE_FILES = [
    {
        "src": "../schemas/apic_schema.yaml",
        "dest": "./ansible-aac/roles/apic_validate/files/apic_schema.yaml",
    },
    {
        "src": "../schemas/mso_schema.yaml",
        "dest": "./ansible-aac/roles/mso_validate/files/mso_schema.yaml",
    },
    {
        "src": "../defaults/apic_defaults.yaml",
        "dest": "./ansible-aac/roles/apic_common/vars/apic_defaults.yaml",
    },
    {
        "src": "../defaults/mso_defaults.yaml",
        "dest": "./ansible-aac/roles/mso_common/vars/mso_defaults.yaml",
    },
    {
        "src": "../objects/apic_objects.yaml",
        "dest": "./ansible-aac/roles/apic_common/vars/apic_objects.yaml",
    },
    {
        "src": "../objects/mso_objects.yaml",
        "dest": "./ansible-aac/roles/mso_common/vars/mso_objects.yaml",
    },
]

TERRAFORM_DIRS = [
    {
        "src": "../validation/rules",
        "dest": "./terraform-aac/validation/rules",
    },
    {
        "src": "../templates/apic/test",
        "dest": "./terraform-aac/tests/templates",
    },
    {
        "src": "../jinja_filters",
        "dest": "./terraform-aac/tests/filters",
    },
]

TERRAFORM_FILES = [
    {
        "src": "../schemas/apic_schema.yaml",
        "dest": "./terraform-aac/validation/apic_schema.yaml",
    },
    {
        "src": "../defaults/apic_defaults.yaml",
        "dest": "./terraform-aac/defaults/defaults.yaml",
    },
]

AAC_TOOL_DIRS = [
    {
        "src": "../defaults",
        "dest": "./aac-tool/aac_tool/schemas",
    },
    {
        "src": "../schemas",
        "dest": "./aac-tool/aac_tool/schemas",
    },
    {
        "src": "../templates/apic/deploy",
        "dest": "./aac-tool/aac_tool/templates/apic/deploy",
    },
    {
        "src": "../templates/mso/deploy",
        "dest": "./aac-tool/aac_tool/templates/mso/deploy",
    },
    {
        "src": "../templates/apic/test",
        "dest": "./aac-tool/aac_tool/templates/apic/test",
    },
    {
        "src": "../templates/mso/test",
        "dest": "./aac-tool/aac_tool/templates/mso/test",
    },
]

AAC_TOOL_FILES = [
    {
        "src": "../objects/apic_objects.yaml",
        "dest": "./aac-tool/aac_tool/schemas/apic_objects.yaml",
    },
    {
        "src": "../objects/mso_objects.yaml",
        "dest": "./aac-tool/aac_tool/schemas/mso_objects.yaml",
    },
]


def update_ansible():
    shutil.rmtree("./ansible-aac", ignore_errors=True)
    subprocess.run(
        ["git", "clone", "https://wwwin-github.cisco.com/netascode/ansible-aac.git"]
    )
    # copy files and dirs
    for dir in ANSIBLE_DIRS:
        shutil.copytree(dir["src"], dir["dest"], dirs_exist_ok=True)
    for file in ANSIBLE_FILES:
        shutil.copyfile(file["src"], file["dest"])
    cwd = "./ansible-aac"
    subprocess.run(["git", "add", "--all"], cwd=cwd)
    p = subprocess.run(["git", "diff", "--cached", "--exit-code"], cwd=cwd)
    if p.returncode > 0:
        subprocess.run(["git", "commit", "-m", "Aac updates"], cwd=cwd)
        subprocess.run(["git", "push"], cwd=cwd)
    shutil.rmtree("./ansible-aac", ignore_errors=True)


def update_terraform():
    shutil.rmtree("./terraform-aac", ignore_errors=True)
    subprocess.run(
        ["git", "clone", "https://wwwin-github.cisco.com/netascode/terraform-aac.git"]
    )
    # copy files and dirs
    for dir in TERRAFORM_DIRS:
        shutil.copytree(dir["src"], dir["dest"], dirs_exist_ok=True)
    for file in TERRAFORM_FILES:
        shutil.copyfile(file["src"], file["dest"])
    cwd = "./terraform-aac"
    subprocess.run(["git", "add", "--all"], cwd=cwd)
    p = subprocess.run(["git", "diff", "--cached", "--exit-code"], cwd=cwd)
    if p.returncode > 0:
        subprocess.run(["git", "commit", "-m", "Aac updates"], cwd=cwd)
        subprocess.run(["git", "push"], cwd=cwd)
    shutil.rmtree("./terraform-aac", ignore_errors=True)


def update_aac_tool():
    shutil.rmtree("./aac-tool", ignore_errors=True)
    subprocess.run(
        ["git", "clone", "https://wwwin-github.cisco.com/netascode/aac-tool.git"]
    )
    # copy files and dirs
    for dir in AAC_TOOL_DIRS:
        shutil.copytree(dir["src"], dir["dest"], dirs_exist_ok=True)
    for file in AAC_TOOL_FILES:
        shutil.copyfile(file["src"], file["dest"])
    cwd = "./aac-tool"
    subprocess.run(["git", "add", "--all"], cwd=cwd)
    p = subprocess.run(["git", "diff", "--cached", "--exit-code"], cwd=cwd)
    if p.returncode > 0:
        subprocess.run(["git", "commit", "-m", "Aac updates"], cwd=cwd)
        subprocess.run(["git", "push"], cwd=cwd)
    shutil.rmtree("./aac-tool", ignore_errors=True)


def update_aac():
    update_ansible()
    update_terraform()
    update_aac_tool()


if __name__ == "__main__":
    update_aac()
