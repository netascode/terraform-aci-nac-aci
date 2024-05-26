# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

import argparse
import os
import shutil
import subprocess
import tempfile

REPOS = [
    {
        "url": "https://{}@wwwin-github.cisco.com/netascode/nac-aci-ansible-collection.git",
        "type": "internal",
        "commit_message": "Nac updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./roles/apic_validate/files/rules",
            },
            {
                "src": "../validation/rules",
                "dst": "./roles/ndo_validate/files/rules",
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
                "src": "../tests/integration/fixtures/apic/standard_52",
                "dst": "./roles/apic_deploy/molecule/01_standard/data/host_vars/apic1",
            },
            {
                "src": "../tests/integration/fixtures/ndo/standard",
                "dst": "./roles/ndo_deploy/molecule/01_standard/data/host_vars/ndo1",
            },
            {
                "src": "../tests/integration/fixtures/ndo/standard_37",
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
        ],
    },
    {
        "url": "https://{}@wwwin-github.cisco.com/netascode/nac-aci-terraform.git",
        "type": "internal",
        "update_release_only": True,
        "commit_message": "Nac updates",
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
        "url": "https://{}@wwwin-github.cisco.com/netascode/nac-aci-terraform-ndo.git",
        "type": "internal",
        "update_release_only": True,
        "commit_message": "Nac updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./.rules",
            },
            {
                "src": "../templates/ndo/test",
                "dst": "./tests/templates/ndo",
            },
            {
                "src": "../templates/apic/test",
                "dst": "./tests/templates/apic",
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
                "dst": "./.schema-ndo.yaml",
            },
            {
                "src": "../schemas/apic_schema.yaml",
                "dst": "./.schema-apic.yaml",
            },
        ],
    },
    {
        "url": "https://{}@wwwin-github.cisco.com/danischm/aac-tf-demo.git",
        "type": "internal",
        "update_release_only": True,
        "commit_message": "Nac updates",
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
        "url": "https://{}@wwwin-github.cisco.com/netascode/nac-tool.git",
        "type": "internal",
        "commit_message": "Nac updates",
        "directories": [
            {
                "src": "../defaults",
                "dst": "./nac_tool/defaults",
            },
            {
                "src": "../templates/apic/deploy",
                "dst": "./nac_tool/templates/apic/deploy",
            },
            {
                "src": "../templates/ndo/deploy",
                "dst": "./nac_tool/templates/ndo/deploy",
            },
            {
                "src": "../templates/apic/test",
                "dst": "./nac_tool/templates/apic/test",
            },
            {
                "src": "../templates/ndo/test",
                "dst": "./nac_tool/templates/ndo/test",
            },
            {
                "src": "../templates/apic/documentation",
                "dst": "./nac_tool/templates/apic/documentation",
            },
            {
                "src": "../templates/ndo/documentation",
                "dst": "./nac_tool/templates/ndo/documentation",
            },
        ],
        "files": [
            {
                "src": "../objects/apic_objects.yaml",
                "dst": "./nac_tool/objects/apic_objects.yaml",
            },
            {
                "src": "../objects/apic_doc_objects.yaml",
                "dst": "./nac_tool/objects/apic_doc_objects.yaml",
            },
            {
                "src": "../objects/ndo_objects.yaml",
                "dst": "./nac_tool/objects/ndo_objects.yaml",
            },
            {
                "src": "../objects/ndo_doc_objects.yaml",
                "dst": "./nac_tool/objects/ndo_doc_objects.yaml",
            },
            {
                "src": "../schemas/apic_schema.yaml",
                "dst": "./nac_tool/schemas/apic_schema.yaml",
            },
            {
                "src": "../schemas/ndo_schema.yaml",
                "dst": "./nac_tool/schemas/ndo_schema.yaml",
            },
        ],
    },
    {
        "url": "https://{}@github.com/netascode/terraform-aci-nac-aci.git",
        "type": "external",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/apic_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
    {
        "url": "https://{}@github.com/netascode/terraform-mso-nac-ndo.git",
        "type": "external",
        "commit_message": "Defaults updates",
        "files": [
            {
                "src": "../defaults/ndo_defaults.yaml",
                "dst": "./defaults/defaults.yaml",
            },
        ],
    },
    {
        "url": "https://{}@wwwin-github.cisco.com/netascode/onboarding-tool.git",
        "type": "internal",
        "update_release_only": True,
        "commit_message": "Nac updates",
        "directories": [
            {
                "src": "../validation/rules",
                "dst": "./onboarding-data/aci/repository-template/.rules",
            },
            {
                "src": "../templates/apic/test",
                "dst": "./onboarding-data/aci/repository-template/tests/templates",
            },
            {
                "src": "../jinja_filters",
                "dst": "./onboarding-data/aci/repository-template/tests/filters",
            },
        ],
        "files": [
            {
                "src": "../schemas/apic_schema.yaml",
                "dst": "./onboarding-data/aci/repository-template/.schema.yaml",
            },
        ],
    },
]


def print_message(message):
    print(
        "--------------------------------------------------------------------------------"
    )
    print(message)
    print(
        "--------------------------------------------------------------------------------"
    )


def update_repo(repo):
    with tempfile.TemporaryDirectory() as dirname:
        if repo["type"] == "internal":
            url = repo["url"].format(os.getenv("DD_INTERNAL_GITHUB_TOKEN"))
        elif repo["type"] == "external":
            url = repo["url"].format(os.getenv("DD_GITHUB_TOKEN"))
        args = ["git", "clone", url, dirname]
        print_message("git clone")
        subprocess.run(args, check=True)
        # copy files and dirs
        for dir in repo.get("directories", []):
            shutil.copytree(
                dir["src"], os.path.join(dirname, dir["dst"]), dirs_exist_ok=True
            )
        for file in repo.get("files", []):
            shutil.copyfile(file["src"], os.path.join(dirname, file["dst"]))
        cwd = dirname
        args = ["git", "add", "--all"]
        print_message(args)
        subprocess.run(args, cwd=cwd, check=True)
        args = ["git", "diff", "--cached", "--exit-code"]
        print_message(args)
        r = subprocess.run(args, cwd=cwd)
        if r.returncode > 0:
            if repo["type"] == "internal":
                subprocess.run(
                    ["git", "config", "user.email", "digidev.gen@cisco.com"],
                    cwd=cwd,
                    check=True,
                )
                subprocess.run(
                    ["git", "config", "user.name", "digidev.gen"], cwd=cwd, check=True
                )
            elif repo["type"] == "external":
                subprocess.run(
                    ["git", "config", "user.email", "netascode-gen@cisco.com"],
                    cwd=cwd,
                    check=True,
                )
                subprocess.run(
                    ["git", "config", "user.name", "netascode-gen"], cwd=cwd, check=True
                )
            args = ["git", "commit", "-m", repo["commit_message"]]
            print_message(args)
            subprocess.run(args, cwd=cwd, check=True)
            args = ["git", "push"]
            print_message(args)
            subprocess.run(args, cwd=cwd, check=True)


def update_repos():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--release",
        help="Update repos marked as 'update_release_only'",
        action="store_true",
    )
    args = parser.parse_args()
    for repo in REPOS:
        if repo.get("update_release_only", False) and not args.release:
            continue
        print("\n-> Updating repo {}\n".format(repo["url"]))
        update_repo(repo)


if __name__ == "__main__":
    update_repos()
