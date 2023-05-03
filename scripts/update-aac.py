# -*- coding: utf-8 -*-

# Copyright: (c) 2021, Daniel Schmidt <danischm@cisco.com>

import os
import shutil
import subprocess
import tempfile

REPOS = [
    {
        "url": "https://wwwin-github.cisco.com/netascode/ansible-aac.git",
        "commit_message": "Aac updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./roles/apic_validate/files/rules",
            },
            {
                "src": "../templates/apic/deploy",
                "dst": "./roles/apic_deploy/templates",
            },
            {
                "src": "../templates/ndo/deploy",
                "dst": "./roles/ndo_deploy/templates",
            },
            {
                "src": "../templates/apic/test/config",
                "dst": "./roles/test_apic_deploy/templates/config",
            },
            {
                "src": "../templates/apic/test/health",
                "dst": "./roles/test_apic_deploy/templates/health",
            },
            {
                "src": "../templates/apic/test/operational",
                "dst": "./roles/test_apic_deploy/templates/operational",
            },
            {
                "src": "../templates/ndo/test/config",
                "dst": "./roles/test_ndo_deploy/templates/config",
            },
            {
                "src": "../tests/integration/fixtures/apic/standard",
                "dst": "./roles/apic_deploy/molecule/01_standard/data/host_vars/apic1",
            },
            {
                "src": "../tests/integration/fixtures/ndo/standard",
                "dst": "./roles/ndo_deploy/molecule/01_standard/data/host_vars/ndo1",
            },
        ],
        "files": [
            {
                "src": "../schemas/apic_schema.yaml",
                "dst": "./roles/apic_validate/files/apic_schema.yaml",
            },
            {
                "src": "../schemas/ndo_schema.yaml",
                "dst": "./roles/ndo_validate/files/ndo_schema.yaml",
            },
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./roles/apic_common/vars/apic_defaults.yaml",
            },
            {
                "src": "../defaults/ndo_defaults.yaml",
                "dst": "./roles/ndo_common/vars/ndo_defaults.yaml",
            },
            {
                "src": "../objects/apic_objects.yaml",
                "dst": "./roles/apic_common/vars/apic_objects.yaml",
            },
            {
                "src": "../objects/ndo_objects.yaml",
                "dst": "./roles/ndo_common/vars/ndo_objects.yaml",
            },
            {
                "src": "../tests/integration/fixtures/apic/standard_42/fabric_policies.yaml",
                "dst": "./roles/apic_deploy/molecule/01_standard/data/host_vars/apic1/fabric_policies_42.yaml",
            },
        ],
    },
    {
        "url": "https://wwwin-github.cisco.com/netascode/terraform-aac.git",
        "commit_message": "Aac updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./.rules",
            },
            {
                "src": "../templates/apic/test",
                "dst": "./tests/templates",
            },
            {
                "src": "../jinja_filters",
                "dst": "./tests/filters",
            },
        ],
        "files": [
            {
                "src": "../schemas/apic_schema.yaml",
                "dst": "./.schema.yaml",
            },
        ],
    },
    {
        "url": "https://wwwin-github.cisco.com/netascode/terraform-ndo-aac.git",
        "commit_message": "Aac updates",
        "directories": [
            {
                "src": "../templates/ndo/test",
                "dst": "./tests/templates",
            },
            {
                "src": "../jinja_filters",
                "dst": "./tests/jinja_filters",
            },
            {
                "src": "../jinja_tests",
                "dst": "./tests/jinja_tests",
            },
        ],
        "files": [
            {
                "src": "../schemas/ndo_schema.yaml",
                "dst": "./.schema.yaml",
            },
        ],
    },
    {
        "url": "https://wwwin-github.cisco.com/danischm/aac-tf-demo.git",
        "commit_message": "Aac updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./.rules",
            },
            {
                "src": "../templates/apic/test",
                "dst": "./tests/templates",
            },
            {
                "src": "../jinja_filters",
                "dst": "./tests/filters",
            },
        ],
        "files": [
            {
                "src": "../schemas/apic_schema.yaml",
                "dst": "./.schema.yaml",
            },
        ],
    },
    {
        "url": "https://wwwin-github.cisco.com/netascode/aac-tool.git",
        "commit_message": "Aac updates",
        "directories": [
            {
                "src": "../defaults",
                "dst": "./aac_tool/schemas",
            },
            {
                "src": "../schemas",
                "dst": "./aac_tool/schemas",
            },
            {
                "src": "../templates/apic/deploy",
                "dst": "./aac_tool/templates/apic/deploy",
            },
            {
                "src": "../templates/ndo/deploy",
                "dst": "./aac_tool/templates/ndo/deploy",
            },
            {
                "src": "../templates/apic/test",
                "dst": "./aac_tool/templates/apic/test",
            },
            {
                "src": "../templates/ndo/test",
                "dst": "./aac_tool/templates/ndo/test",
            },
        ],
        "files": [
            {
                "src": "../objects/apic_objects.yaml",
                "dst": "./aac_tool/schemas/apic_objects.yaml",
            },
            {
                "src": "../objects/ndo_objects.yaml",
                "dst": "./aac_tool/schemas/ndo_objects.yaml",
            },
        ],
    },
    {
        "url": "https://github.com/netascode/terraform-aci-nac-aci.git",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
    {
        "url": "https://github.com/netascode/terraform-mso-nac-ndo.git",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/ndo_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
]


def update_repo(repo):
    with tempfile.TemporaryDirectory() as dirname:
        subprocess.run(["git", "clone", repo["url"], dirname])
        # copy files and dirs
        for dir in repo.get("directories", []):
            shutil.copytree(
                dir["src"], os.path.join(dirname, dir["dst"]), dirs_exist_ok=True
            )
        for file in repo.get("files", []):
            shutil.copyfile(file["src"], os.path.join(dirname, file["dst"]))
        cwd = dirname
        subprocess.run(["git", "add", "--all"], cwd=cwd)
        p = subprocess.run(["git", "diff", "--cached", "--exit-code"], cwd=cwd)
        if p.returncode > 0:
            subprocess.run(["git", "commit", "-m", repo["commit_message"]], cwd=cwd)
            subprocess.run(["git", "push"], cwd=cwd)


def update_aac():
    for repo in REPOS:
        print("\n-> Updating repo {}\n".format(repo["url"]))
        update_repo(repo)


if __name__ == "__main__":
    update_aac()
