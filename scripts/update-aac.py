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
                "src": "../templates/mso/deploy",
                "dst": "./roles/mso_deploy/templates",
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
                "src": "../templates/mso/test/config",
                "dst": "./roles/test_mso_deploy/templates/config",
            },
            {
                "src": "../tests/integration/fixtures/apic/standard",
                "dst": "./roles/apic_deploy/molecule/01_standard/data/host_vars/apic1",
            },
            {
                "src": "../tests/integration/fixtures/mso/standard",
                "dst": "./roles/mso_deploy/molecule/01_standard/data/host_vars/mso1",
            },
        ],
        "files": [
            {
                "src": "../schemas/apic_schema.yaml",
                "dst": "./roles/apic_validate/files/apic_schema.yaml",
            },
            {
                "src": "../schemas/mso_schema.yaml",
                "dst": "./roles/mso_validate/files/mso_schema.yaml",
            },
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./roles/apic_common/vars/apic_defaults.yaml",
            },
            {
                "src": "../defaults/mso_defaults.yaml",
                "dst": "./roles/mso_common/vars/mso_defaults.yaml",
            },
            {
                "src": "../objects/apic_objects.yaml",
                "dst": "./roles/apic_common/vars/apic_objects.yaml",
            },
            {
                "src": "../objects/mso_objects.yaml",
                "dst": "./roles/mso_common/vars/mso_objects.yaml",
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
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
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
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
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
                "src": "../templates/mso/deploy",
                "dst": "./aac_tool/templates/mso/deploy",
            },
            {
                "src": "../templates/apic/test",
                "dst": "./aac_tool/templates/apic/test",
            },
            {
                "src": "../templates/mso/test",
                "dst": "./aac_tool/templates/mso/test",
            },
        ],
        "files": [
            {
                "src": "../objects/apic_objects.yaml",
                "dst": "./aac_tool/schemas/apic_objects.yaml",
            },
            {
                "src": "../objects/mso_objects.yaml",
                "dst": "./aac_tool/schemas/mso_objects.yaml",
            },
        ],
    },
    {
        "url": "https://github.com/netascode/terraform-aci-nac-access-policies.git",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
    {
        "url": "https://github.com/netascode/terraform-aci-nac-fabric-policies.git",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
    {
        "url": "https://github.com/netascode/terraform-aci-nac-interface-policies.git",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
    {
        "url": "https://github.com/netascode/terraform-aci-nac-node-policies.git",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
    {
        "url": "https://github.com/netascode/terraform-aci-nac-tenant.git",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/apic_defaults.yaml",
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
        update_repo(repo)


if __name__ == "__main__":
    update_aac()
