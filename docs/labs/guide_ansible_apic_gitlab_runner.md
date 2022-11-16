# ACI as Code using Ansible, APIC, Gitlab and Gitlab Runner

## Introduction

This lab guide will help you to get `ACI as Code` up and running using Gitlab as the source control system and Gitlab Runner as the CICD server.

## Assumptions

This lab guide assumes the 'aci' flavour was selected during provisioning. Hence, no Nexus Dashboard is available.

## Section 1: Lab infrastructure

As part of the setup, you will have the following components:

1. Control Virtual machine running a Gitlab and Gitlab Runner instance
2. ACI simulator

Take a note of the IP addresses that got allocated to your POD. The generic placeholders below (e.g. CONTROLLER_IP, APIC_IP...) should be replaced with the values that have been allocated to your POD.
You will be able to access the instances on the following addresses:

- Gitlab: <https://CONTROLLER_IP>
- ACI simulator: <https://APIC_IP>

## Section 2: Gitlab Configuration

### 2A) Access Gitlab

Go to the Gitlab instance at <https://CONTROLLER_IP>. Login with username `cisco` and password `cisco123`.

![aac_gitlab_1](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab1.png)

### 2B) Repositories for ACI as Code

Three repositories have been created during the provisioning process:

1. <b>aac-inventory</b>: contains a sample repository representing the desired state of the ACI configuration. This repo is available at <https://CONTROLLER_IP/aci-iac/aac-inventory>

2. <b>ansible-aac</b>: contains the ACI as Code framework consisting of Ansible collection, modules, plugins being used by the aac-inventory repository. This repo is available at <https://CONTROLLER_IP/aci-iac/ansible-aac>

3. <b>terraform-aac</b>: contains the ACI as Code framework consisting of Terraform, modules, plugins being used by the aac-inventory repository. This repo will **not** be used in this lab guide althrough it is available at <https://CONTROLLER_IP/aci-iac/terraform-aac>

### 2C) Creating new repository

We will need to create a fourth repository to contain our configuration (single source of truth)

3. <b>aac-inventory-config</b>: not created as part of the POD setup so we will create it as follows:

Once logged in into your Gitlab instance, click on `New Project` and choose `Create blank project`. Use `aac-inventory-config` as the project name and ensure you set the organization to `aci-iac` in the Project URL. See below screenshot for an example.

![aac_gitlab_2](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab2.png)

This will create an empty repository called `aac-inventory-config` which will be required later.

## Section 3: Verify Gitlab Runner

Gitlab Runner is an easy-to-use CICD system that comes with Gitlab.

The lab infrastructure comes with a pre-installed runner instance, so no configuration are as such required. It is however always a good idea to check if the runner instance successfully have registered itself successfully with Gitlab.

1. Once logged into your Gitlab instance, access the `Main menu`and choose `Admin` to enter the Admin Area.

2. Within the Admin Area, click on `Runners` and verify that the pre-installed runner instance is online and registered correctly

![aac_gitlab_runner_1](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab_runner1.png)

## Section 4: ACI Simulator

Go to the ACI simulator on `https://APIC_IP`. You should be able to see the login screen.

![aac_aci_1](../assets/labs/guide_ansible_apic_gitlab_runner/aci1.png)

Login with username `admin` and password `cisco123`.

Note: in case you don't see the login screen, ssh into the Control Virtual Machine and perform a CURL request to the ACI simulator (APIC_IP).

```
~/Code/AAC_Lab$ ssh cisco@CONTROLLER_IP
cisco@aac-lab-pod-X-control:~$ curl https://APIC_IP
```

Once completed, refresh the browser screen and you should be able to see the APIC login screen.

## Section 5: AAC framework preparation steps

In order to configure the ACI as Code framework, some pre-requisite steps are required:

- [Clone aac-inventory locally](#5a-clone-aac-inventory-locally)
- [Preparing Webex notifications](#5b-preparing-webex-notifications)
- [Create Gitlab Access Token](#5c-create-gitlab-access-token)
- [Configure Gitlab CI/CD Variables](#5d-configure-gitlab-variables)

### 5A) Clone aac-inventory locally

Go to the aac-inventory repo (<https://CONTROLLER_IP/aci-iac/aac-inventory>) and click on the `Clone` dropdown. Take note of the `Clone with HTTPS` value.

![aac_gitlab_3](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab3.png)

Clone the repository locally in a directory of your choice.

```
~/Code/AAC_Lab$ git -c http.sslVerify=false clone https://CONTROLLER_IP/aci-iac/aac-inventory
Cloning into 'aac-inventory'...
warning: redirecting to https://CONTROLLER_IP/aci-iac/aac-inventory.git/
remote: Enumerating objects: 208, done.
remote: Total 208 (delta 0), reused 0 (delta 0), pack-reused 208
Receiving objects: 100% (208/208), 43.66 KiB | 698.00 KiB/s, done.
Resolving deltas: 100% (92/92), done.
```

This will make the `aac-inventory` available locally. Open up the folder in your favorite IDE (e.g. Visual Studio, PyCharm...). All changes described in the next section will be made on the local copy of this repository

**Please note** that as the Gitlab instance is using a self-signed certificate is it required to disable certificate validation when executing
the git command. This can be done using either a command line argument as in the example above or by disabling this in the global git
configuration with the following command. It is however not advised disabling SSL verification globally as this **will introduce a security risk**
and should only be used temporarily.

### 5B) Preparing Webex notifications

#### 5B-1) Create a Webex Bot

Go to <https://developer.webex.com> and login with CEC credentials. Select `My Webex Apps` and `Create a New App`.

![aac_webex_1](../assets/labs/guide_ansible_apic_gitlab_runner/webex1.png)

Select `Create a bot` and fill out all required fields. Use a unique bot username.

![aac_webex_2](../assets/labs/guide_ansible_apic_gitlab_runner/webex2.png)

Once finished, click `Add Bot` and your Webex bot will be created. You will receive a `Bot Access Token`. Copy this token as it will be required in the next section (e.g. SPARK_ACCESS_TOKEN).

#### 5B-2) Create a Webex space

Next, we will create a Webex space. In Webex, click the `+` icon and select ``Create Space`.

![aac_webex_3](../assets/labs/guide_ansible_apic_gitlab_runner/webex3.png)

Choose an appropriate name for your space. Then add the bot we created earlier as a member to this space.

![aac_webex_4](../assets/labs/guide_ansible_apic_gitlab_runner/webex4.png)

#### 5B-3) Retrieve Room ID

The Gitlab pipeline will need to know the room ID in order to be able to send messages to it. So in the section, we will retrieve the room ID for the room we just created. There are multiple ways to do this (e.g postman, python, CURL...). In this lab guide, we will use CURL.

Log into the Controller Virtual Machine using SSH.

```
~/Code/AAC_Lab$ ssh cisco@CONTROLLER_IP
cisco@aac-lab-pod-1-control:~$ curl -L -X GET 'https://api.ciscospark.com/v1/rooms' -H 'Authorization: Bearer <BEARER>' | json_pp -json_opt pretty,canonical
```

In the above command, replace the \<BEARER> value with Bot Access Token value that you received when the Webex Bot was created. If all went well, you will receive a response containing a JSON body. Copy the `id` and `title` as this contains the `Room ID` and the `Title` that will be needed in our Gitlab pipeline in a later section.

```
{
   "items" : [
      {
         "created" : "2022-03-18T12:50:41.167Z",
         "creatorId" : "Y2lzY29zcGFyazovL3VzL1BFT1BMRS85Y2EzY2UwNi01YTgxLTRiMjktODk0Zi0xMTU1MDQ0OTIwZWY",
         "id" : "Y2lzY29zcGFyazovL3VzL1JPT00vMDQ4NjIxZjAtYTZiYS0xMWVjLWIyMTctZGIxYmM5ZjJmZTQ3",
         "isLocked" : false,
         "lastActivity" : "2022-03-18T12:50:41.167Z",
         "ownerId" : "Y2lzY29zcGFyazovL3VzL09SR0FOSVpBVElPTi8xZWI2NWZkZi05NjQzLTQxN2YtOTk3NC1hZDcyY2FlMGUxMGY",
         "title" : "AAC Lab Notifications",
         "type" : "group"
      }
   ]
}
```

### 5C) Create Gitlab Access Token

Go to your Gitlab instance. Click on the profile icon in the upper right corner and go to `Edit Profile`. Next on the left select `Access Tokens`. Create a Personal Access Token and give it `api` scope.

![aac_gitlab_4](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab4.png)

Take a note of the value as it will need to be added as a secret in Gitlab in the next section (e.g. GITHUB_TOKEN)

### 5D) Configure Gitlab variables

Go to the `aci-iac/aac-inventory` repository on Gitlab and go to `Settings` and select `CI/CD`. We will add some variables to that will be used inside the `.gitlab-ci.yml` file.

![aac_gitlab_runner_2](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab_runner2.png)

Add the following variables:

- ANSIBLE_VAULT_PASSWORD: set this to the Vault password you used earlier to encrypt the Ansible passwords. Click on `Allow Pull requests`.
- SPARK_ACCESS_TOKEN: set this to the token you created in the `Preparing Webex notifications` section. Click on `Allow Pull requests`.
- GITHUB_TOKEN: set this to the token you created in the `Create Gitlab Access Token` section. Click on `Allow Pull requests`.
- APIC_HOST: set this to the IP address of the APIC

When finished you should see the following secrets added to your repository:

![aac_gitlab_runner_3](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab_runner3.png)

## Section 6: Customize inventory files

Next, we need to perform some preparation activities prior to working with the ACI as Code framework.

### 6A) Change hosts.yaml file

We need to change the `hosts.yaml` file which can be found in the `aac-inventory/data/lab/group_vars` folder. The `APIC_HOST` is read from an environment variable. We have set this already in section 5E.

```
---
aci:
  children:
    apic:
      hosts:
        apic1:
          apic_host: "{{ lookup('ansible.builtin.env', 'APIC_HOST') }}"
          ansible_connection: local
    # mso:
    #   hosts:
    #     mso1:
    #       mso_host: "{{ lookup('ansible.builtin.env', 'MSO_HOST') }}"
    #       ansible_connection: local
```

Note: as this lab guide focuses only on APIC, you can comment out the MSO section (see screenshot above).

### 6B) Change bootstrap.yaml file

We need to change the `bootstrap.yaml` file which can be found in the `aac-inventory/data/lab/host_vars/apic1` folder.

Make the following changes so that the admin password mathces the APIC password for the lab. You should have something similar to below example:

```yaml
---
apic:
  bootstrap:
    admin_username: admin
    admin_password: cisco123
    config_passphrase: C1sco123C1sco123
```

The `admin_password` variable must be specified in order for the AAC Bootstrap functionality to work later in this lab guide. If bootstrap is done manually, then the `admin_username` and `admin_password` configuration can be removed alltogether.

### 6C) Remove mso1 directory file

Since we only use an APIC configuration, go ahead and remove the `aac-inventory/data/lab/host_vars/mso1` directory

## Section 7: Gitlab CI pipeline configuration

In this section, we will create a `.gitlab-ci.yml` file. We will go step by step through the file and specify each of the required steps. Go to the local (cloned) repository and create a `.gitlab-ci.yml` file.

### Overall Pipeline Settings

The beginning of the `.gitlab-ci.yml` file contains the overall settings for the pipeline like variables, container image to use, define the pipeline stages, etc.

```
variables:
  # Disable SSL verification for git
  GIT_SSL_NO_VERIFY: "true"

  BOOTSTRAP: 'false'
  # APIC NAE Pre-Change Analysis
  APIC_NAE_PCA: 'false'
  # APIC Deploy Stages
  APIC_SNAPSHOT: 'true'
  APIC_DEPLOY: 'true'
  FULL_APIC_DEPLOY: 'false' # If true always deploy everything (no diff)
  # APIC Test Stages
  TEST_APIC_DEPLOY: 'true'
  FULL_APIC_TEST: 'false' # If true always test everything (no diff)

  PY_COLORS: '1'
  ANSIBLE_FORCE_COLOR: '1'

  # Needed in order for after_script to catch the job status successfully
  # see https://gitlab.com/gitlab-org/gitlab-runner/-/issues/27693 for details
  FF_USE_LEGACY_KUBERNETES_EXECUTION_STRATEGY: "true"

image: danischm/aac:0.4.0

# These before and after scripts are automatically used by every job not having a before/after script defined
default:
  before_script:
    - echo -e "\e[0Ksection_start:`date +%s`:before_script[collapsed=true]\r\e[0KExecuting before_script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - pip install iac-validate
    - ansible-galaxy install -r requirements.yml
    - echo -e "\e[0Ksection_end:`date +%s`:before_script\r\e[0K"
  after_script:
    # The pipeline_failure.txt file is used to signal if any job in the pipeline has failed
    - >
      if [ $CI_JOB_STATUS == 'failed' ]; then
        echo "failed" > pipeline_failure.txt
      fi

stages:
  - validate
  - bootstrap
  - render
  - deploy
  - test
  - git update
  - notify
```

The default before_script and after_script are automatically inherited by the jobs we will used in the different pipeline stages.

The before_script are used to install the required software packages as the pipeline space in Gitlab CI are not reused between stages.

The after_script is used to indicate if the stage failed. This functionality is implemented this way Gitlab CI do not have a build-in variable indicating the overall success/failure of the entire pipeline.

In addition, you will notice that the `Setup` step is referring to a `requirements.yml` file. This file will need to reference our own copy of the ansible-aac code which was added as a repository on our Gitlab instance.

Before:

```
---
collections:
  - name: https://wwwin-github.cisco.com/aac/ansible-aac.git
    type: git
    version: master

```

After:

```
---
collections:
  - name: https://CONTROLLER_IP/aci-iac/ansible-aac.git
    type: git
    version: master

```

### Step: Validate

Description: The `Validate` step is perform syntactic and semantic validations on your inventory.

Currently, the `Validate` step will contain following code. As this guide only covers ACI, if MSO is needed then additional Ansible playbook(s) may need to be run in the different stages.

```
# Template for the validate jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.validate: &validate
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - ansible-playbook -i data/lab/hosts.yaml apic_validate.yaml |& tee validate_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - validate_output.txt
    expire_in: 30 min
    when: always

validate (master branch):
  stage: validate
  <<: *validate
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"

validate (feature branch):
  stage: validate
  <<: *validate
  rules:
    - if: $CI_COMMIT_BRANCH != "master" && ( $CI_PIPELINE_SOURCE != "tag" || $CI_PIPELINE_SOURCE != "merge_request_event")

validate (PR):
  stage: validate
  <<: *validate
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```

Job artifacts are used for two purposes in this pipeline:

1. Used as means to transfer artifacts/files between the different stages in the pipeline. Examples of this is the `pipeline_falure.txt` file that are created by each individual job upon failure and consumed by the prepare notify job to indicate whether the pipeline was successful or not.
2. Used as regular artifacts allowing users to download robot test reports, etc.

As it can be seen above are multiple jobs for the same stage defined. This is required as jobs depending on each other must have identical rules for when they are run.

### Step: Bootstrap (first time only)

Description: the `Boostrap` step is responsible for setting up your ACI fabric for the first time. Hence the Bootstrap step is only required for Day-0 operations and can be removed once it was run successfully.

```
bootstrap (master branch):
  stage: bootstrap
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - ansible-playbook -i data/lab/hosts.yaml apic_bootstrap.yaml |& tee bootstrap_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  artifacts:
    paths:
      - pipeline_failure.txt
      - bootstrap_output.txt
    expire_in: 30 min
    when: always
  needs: ["validate (master branch)"]
```

### Step: Test Bootstrap (first time only)

Description: the `Test Bootstrap` step is responsible for testing the bootstrapped configuration.

```
test bootstrap (master branch):
  stage: bootstrap
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - ansible-playbook -i data/lab/hosts.yaml test_apic_bootstrap.yaml |& tee test_apic_bootstrap_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  artifacts:
    paths:
      - pipeline_failure.txt
      - test_apic_bootstrap_output.txt
      - test_results/
    expire_in: 30 min
    when: always
    reports:
      junit: test_results/lab/apic1/bootstrap_xunit.xml
  needs: ["validate (master branch)", "bootstrap (master branch)"]
```

### Step: Render

Description: the `Render APIC` step is responsible for creating the JSON bodies to effectly provision the fabric.

```
# Template for the render jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.render: &render
  stage: render
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - git clone --depth 1 --branch last_deploy https://10.50.223.165/aci-iac/aac-inventory.git previous/
    - git clone https://10.50.223.165/aci-iac/aac-inventory-config.git
    - 'echo "previous_inventory: ./previous/data/lab/" >> apic_render_vars.yaml'
    - >
      if [ "$FULL_APIC_DEPLOY" == "true" ]; then
        'echo "apic_mode: all" >> apic_render_vars.yaml'
      fi
    - ansible-playbook -i data/lab/hosts.yaml -e @apic_render_vars.yaml apic_render.yaml |& tee render_output.txt
    - >
      if [ -d "./rendered" ]; then
        /bin/cp -rf ./rendered/ ./aac-inventory-config/
      fi
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - render_output.txt
      - previous/
      - rendered/
      - aac-inventory-config/
    expire_in: 30 min
    when: always

render apic (master branch):
  <<: *render
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  needs: ["validate (master branch)"]

render apic w. bootstrap (master branch):
  <<: *render
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  needs: ["validate (master branch)"]

render apic (PR):
  <<: *render
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  needs: ["validate (PR)"]
```

### Step: NAE PCA

As this guide only focuses on APIC, so this step is not included in the pipeline.

### Step: Deploy APIC

Description: The `Deploy APIC` step is responsible for taking the rendered JSON bodies and use them to configure the ACI fabric.

```
# Template for the deploy jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.deploy: &deploy
  stage: deploy
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - 'echo "previous_inventory: ./previous/data/lab/" >> apic_deploy_vars.yaml'
    - >
      if [ "$FULL_APIC_DEPLOY" == "true" ]; then
        'echo "apic_mode: all" >> apic_deploy_vars.yaml'
      fi
    - ansible-playbook -i data/lab/hosts.yaml -e @apic_deploy_vars.yaml apic_deploy.yaml |& tee deploy_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - deploy_output.txt
    expire_in: 30 min
    when: always

deploy apic (master branch):
  <<: *deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)"]

deploy apic w. bootstrap (master branch):
  <<: *deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - render apic w. bootstrap (master branch)
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)"]
```

### Deploy MSO

As this guide only focuses on APIC, so this step is not included in the pipeline.

### Step: Test APIC

Description: the `Test APIC` step is responsible for testing the ACI fabric after the deployment has been finished

```
# Template for the apic test jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.test_apic: &test_apic
  stage: test
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - 'echo "test_apic_deploy: $TEST_APIC_DEPLOY" >> apic_test_vars.yaml'
    - 'echo "previous_inventory: ''./previous/data/lab/''" >> apic_test_vars.yaml'
    - >
      if [ "$FULL_APIC_TEST" == "true" ]; then
        'echo "apic_mode: 'all'" >> apic_test_vars.yaml'
      fi
    - ansible-playbook -i data/lab/hosts.yaml -e @apic_test_vars.yaml apic_test.yaml |& tee test_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - test_output.txt
      - test_results/
    expire_in: 30 min
    when: always
    reports:
      junit: test_results/lab/apic1/xunit.xml

test apic (master branch):
  <<: *test_apic
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)"]

test apic w. bootstrap (master branch):
  <<: *test_apic
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - render apic w. bootstrap (master branch)
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)"]
```

### Test MSO

As this guide only focuses on APIC, so this step is not included in the pipeline.

### Step: Git Config Update

Description: the `Git Config Update` will store the rendered files inside the config repository that was created earlier (e.g. `aac-inventory-config`).

Currently, the `GIT Config Update` step will contain following code. Pay attention to the following:

- change the location in the `cd` command (1st line under the commands section) to the config directory that was created earlier (e.g. `aac-inventory-config`)
- use the Gitlab access token name (3rd line under the commands section) as created in the `Create Gitlab Access Token` section (e.g in our case the token is stored in a variable called `GIT_TOKEN')

```
# Template for the GIT config update jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.git_config_update: &git_config_update
  stage: git update
  before_script: []
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - cd aac-inventory-config
    - git config credential.helper "store --file=.git/credentials"
    - echo "https://GIT_TOKEN:$GITHUB_TOKEN@10.50.223.165" > .git/credentials
    - git config user.email $GITLAB_USER_EMAIL
    - git config user.name $GITLAB_USER_NAME
    - git add -A
    - git commit -a -m "$CI_COMMIT_MESSAGE" --allow-empty
    - git push
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
    expire_in: 30 min
    when: always

git config update (master branch):
  <<: *git_config_update
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)"]

git config update w. bootstrap (master branch):
  <<: *git_config_update
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - render apic w. bootstrap (master branch)
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)"]
```

### Step: Git Tag Release

Description: the `GIT Tag Release` will tag the repository with the `last_deploy` tag.

Change the following:

- use the Gitlab access token name (3rd line under the commands section) as created in the `Create Gitlab Access Token` section (e.g in our case the token  is stored in a variable called `GIT_TOKEN')

```
# Template for the GIT config update jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.git_tag_release: &git_tag_release
  stage: git update
  before_script: []
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - git config credential.helper "store --file=.git/credentials"
    - echo "https://GIT_TOKEN:$GITHUB_TOKEN@10.50.223.165" > .git/credentials
    - git config user.email $GITLAB_USER_EMAIL
    - git config user.name $GITLAB_USER_NAME
    # Add git remote to allow write operations, as the origin from the gitlab ci clone is read-only
    - git remote add origin-write https://GIT_TOKEN:$GITHUB_TOKEN@10.50.223.165/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME.git
    - git push --delete origin-write last_deploy
    - git tag -d last_deploy
    - git tag last_deploy
    - git push origin-write --tags
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
    expire_in: 30 min
    when: always

git tag release (master branch):
  <<: *git_tag_release
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)", "test apic (master branch)"]

git tag release w. bootstrap (master branch):
  <<: *git_tag_release
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)", "test apic w. bootstrap (master branch)"]
```

Note: the first time we run the code, there is no `last_deploy` so we cannot delete it. Hence, the first time we run the pipeline, we will comment out that line.

### Step: Prepare Notify

Description: the `Prepare Notify` step is preparing the Webex notification messages.

```
# Template for the prepare notify jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.prepare_notify: &prepare_notify
  stage: notify
  before_script: []
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - python3 .ci/render-wx.py
    # Modify notification template to indicate pipeline success or failure
    # This is done this way, as Gitlab CI do not have a build-in variable for the overall pipeline success
    - if grep failed pipeline_failure.txt > /dev/null 2>&1; then sed -i 's/{{ build.status }}/failure/g' webex.txt; fi
    - if [ ! -f pipeline_failure.txt ]; then sed -i 's/{{ build.status }}/success/g' webex.txt; fi
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - webex.txt
    expire_in: 10 min
    when: always
  when: always

prepare notification (master branch):
  <<: *prepare_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - validate (master branch)
    - render apic (master branch)
    - deploy apic (master branch)
    - test apic (master branch)
    - git config update (master branch)
    - git tag release (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)", "test apic (master branch)", "git config update (master branch)", "git tag release (master branch)"]

prepare notification w. bootstrap (master branch):
  <<: *prepare_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - validate (master branch)
    - bootstrap (master branch)
    - test bootstrap (master branch)
    - render apic w. bootstrap (master branch)
    - deploy apic w. bootstrap (master branch)
    - test apic w. bootstrap (master branch)
    - git config update w. bootstrap (master branch)
    - git tag release w. bootstrap (master branch)
  needs: ["validate (master branch)", "bootstrap (master branch)", "test bootstrap (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)", "test apic w. bootstrap (master branch)", "git config update w. bootstrap (master branch)", "git tag release w. bootstrap (master branch)"]

prepare notification (feature branch):
  <<: *prepare_notify
  rules:
    - if: $CI_COMMIT_BRANCH != "master" && ( $CI_PIPELINE_SOURCE != "tag" || $CI_PIPELINE_SOURCE != "merge_request_event")
  dependencies:
    - validate (feature branch)
  needs: ["validate (feature branch)"]

prepare notification (PR):
  <<: *prepare_notify
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  dependencies:
    - validate (PR)
    - render apic (PR)
  needs: ["validate (PR)", "render apic (PR)"]
```

### Step: Notify

Description: the `Notify` is responsible for sending the rendered notifications to the selected Webex Teams room.

 Change the following lines:
- 'PLUGIN_ROOM': change to the name of the room (refer to the title value in section `Retrieve Room ID`)

```
# Template for the webex notify jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.webex_notify: &webex_notify
  stage: notify
  image: ciscosso/drone-webex-team:v0.0.1
  before_script: []
  variables:
    PLUGIN_ACCESS_TOKEN: $SPARK_ACCESS_TOKEN
    PLUGIN_ROOM: 'moskrive ACI Build'
    DRONE_REPO_OWNER: $CI_PROJECT_NAMESPACE
    DRONE_REPO_NAME: $CI_PROJECT_NAME
    DRONE_COMMIT_SHA: $CI_COMMIT_SHA
    DRONE_COMMIT_BRANCH: $CI_COMMIT_BRANCH
    DRONE_COMMIT_AUTHOR: $CI_COMMIT_AUTHOR
    DRONE_COMMIT_AUTHOR_EMAIL: ''
    DRONE_BUILD_NUMBER: $CI_PIPELINE_ID
    DRONE_BUILD_STATUS: 'unknown'
    DRONE_BUILD_LINK: $CI_PIPELINE_URL
    DRONE_COMMIT_MESSAGE: $CI_COMMIT_MESSAGE
    DRONE_COMMIT_LINK: $CI_REPOSITORY_URL
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - IFS=""
    - env PLUGIN_BODY=$(cat webex.txt) /bin/drone-spark
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  when: always

webex notification (master branch):
  <<: *webex_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - prepare notification (master branch)
  needs: ["prepare notification (master branch)"]

webex notification w. bootstrap (master branch):
  <<: *webex_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - prepare notification w. bootstrap (master branch)
  needs: ["prepare notification w. bootstrap (master branch)"]

webex notification (feature branch):
  <<: *webex_notify
  rules:
    - if: $CI_COMMIT_BRANCH != "master" && ( $CI_PIPELINE_SOURCE != "tag" || $CI_PIPELINE_SOURCE != "merge_request_event")
  dependencies:
    - prepare notification (feature branch)
  needs: ["prepare notification (feature branch)"]

webex notification (PR):
  <<: *webex_notify
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  dependencies:
    - prepare notification (PR)
  needs: ["prepare notification (PR)"]
```

### Complete Pipeline

Below can the complete `.gitlab-ci.yml` file be seen.

```
variables:
  # Disable SSL verification for git
  GIT_SSL_NO_VERIFY: "true"

  BOOTSTRAP: 'false'
  # APIC NAE Pre-Change Analysis
  APIC_NAE_PCA: 'false'
  # APIC Deploy Stages
  APIC_SNAPSHOT: 'true'
  APIC_DEPLOY: 'true'
  FULL_APIC_DEPLOY: 'false' # If true always deploy everything (no diff)
  # APIC Test Stages
  TEST_APIC_DEPLOY: 'true'
  FULL_APIC_TEST: 'false' # If true always test everything (no diff)

  PY_COLORS: '1'
  ANSIBLE_FORCE_COLOR: '1'

  # Needed in order for after_script to catch the job status successfully
  # see https://gitlab.com/gitlab-org/gitlab-runner/-/issues/27693 for details
  FF_USE_LEGACY_KUBERNETES_EXECUTION_STRATEGY: "true"

image: danischm/aac:0.4.0

# These before and after scripts are automatically used by every job not having a before/after script defined
default:
  before_script:
    - echo -e "\e[0Ksection_start:`date +%s`:before_script[collapsed=true]\r\e[0KExecuting before_script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - pip install iac-validate
    - ansible-galaxy install -r requirements.yml
    - echo -e "\e[0Ksection_end:`date +%s`:before_script\r\e[0K"
  after_script:
    # The pipeline_failure.txt file is used to signal if any job in the pipeline has failed
    - >
      if [ $CI_JOB_STATUS == 'failed' ]; then
        echo "failed" > pipeline_failure.txt
      fi

stages:
  - validate
  - bootstrap
  - render
  - deploy
  - test
  - git update
  - notify

# Template for the validate jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.validate: &validate
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - ansible-playbook -i data/lab/hosts.yaml apic_validate.yaml |& tee validate_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - validate_output.txt
    expire_in: 30 min
    when: always

validate (master branch):
  stage: validate
  <<: *validate
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"

validate (feature branch):
  stage: validate
  <<: *validate
  rules:
    - if: $CI_COMMIT_BRANCH != "master" && ( $CI_PIPELINE_SOURCE != "tag" || $CI_PIPELINE_SOURCE != "merge_request_event")

validate (PR):
  stage: validate
  <<: *validate
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

bootstrap (master branch):
  stage: bootstrap
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - ansible-playbook -i data/lab/hosts.yaml apic_bootstrap.yaml |& tee bootstrap_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  artifacts:
    paths:
      - pipeline_failure.txt
      - bootstrap_output.txt
    expire_in: 30 min
    when: always
  needs: ["validate (master branch)"]

test bootstrap (master branch):
  stage: bootstrap
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - ansible-playbook -i data/lab/hosts.yaml test_apic_bootstrap.yaml |& tee test_apic_bootstrap_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  artifacts:
    paths:
      - pipeline_failure.txt
      - test_apic_bootstrap_output.txt
      - test_results/
    expire_in: 30 min
    when: always
    reports:
      junit: test_results/lab/apic1/bootstrap_xunit.xml
  needs: ["validate (master branch)", "bootstrap (master branch)"]

# Template for the render jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.render: &render
  stage: render
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - git clone --depth 1 --branch last_deploy https://10.50.223.165/aci-iac/aac-inventory.git previous/
    - git clone https://10.50.223.165/aci-iac/aac-inventory-config.git
    - 'echo "previous_inventory: ./previous/data/lab/" >> apic_render_vars.yaml'
    - >
      if [ "$FULL_APIC_DEPLOY" == "true" ]; then
        'echo "apic_mode: all" >> apic_render_vars.yaml'
      fi
    - ansible-playbook -i data/lab/hosts.yaml -e @apic_render_vars.yaml apic_render.yaml |& tee render_output.txt
    - >
      if [ -d "./rendered" ]; then
        /bin/cp -rf ./rendered/ ./aac-inventory-config/
      fi
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - render_output.txt
      - previous/
      - rendered/
      - aac-inventory-config/
    expire_in: 30 min
    when: always

render apic (master branch):
  <<: *render
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  needs: ["validate (master branch)"]

render apic w. bootstrap (master branch):
  <<: *render
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  needs: ["validate (master branch)"]

render apic (PR):
  <<: *render
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  needs: ["validate (PR)"]

# Template for the deploy jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.deploy: &deploy
  stage: deploy
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - 'echo "previous_inventory: ./previous/data/lab/" >> apic_deploy_vars.yaml'
    - >
      if [ "$FULL_APIC_DEPLOY" == "true" ]; then
        'echo "apic_mode: all" >> apic_deploy_vars.yaml'
      fi
    - ansible-playbook -i data/lab/hosts.yaml -e @apic_deploy_vars.yaml apic_deploy.yaml |& tee deploy_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - deploy_output.txt
    expire_in: 30 min
    when: always

deploy apic (master branch):
  <<: *deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)"]

deploy apic w. bootstrap (master branch):
  <<: *deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - render apic w. bootstrap (master branch)
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)"]

# Template for the apic test jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.test_apic: &test_apic
  stage: test
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
    - set -o pipefail
    - 'echo "test_apic_deploy: $TEST_APIC_DEPLOY" >> apic_test_vars.yaml'
    - 'echo "previous_inventory: ''./previous/data/lab/''" >> apic_test_vars.yaml'
    - >
      if [ "$FULL_APIC_TEST" == "true" ]; then
        'echo "apic_mode: 'all'" >> apic_test_vars.yaml'
      fi
    - ansible-playbook -i data/lab/hosts.yaml -e @apic_test_vars.yaml apic_test.yaml |& tee test_output.txt
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
      - test_output.txt
      - test_results/
    expire_in: 30 min
    when: always
    reports:
      junit: test_results/lab/apic1/xunit.xml

test apic (master branch):
  <<: *test_apic
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)"]

test apic w. bootstrap (master branch):
  <<: *test_apic
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - render apic w. bootstrap (master branch)
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)"]

# Template for the GIT config update jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.git_config_update: &git_config_update
  stage: git update
  before_script: []
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - cd aac-inventory-config
    - git config credential.helper "store --file=.git/credentials"
    - echo "https://GIT_TOKEN:$GITHUB_TOKEN@10.50.223.165" > .git/credentials
    - git config user.email $GITLAB_USER_EMAIL
    - git config user.name $GITLAB_USER_NAME
    - git add -A
    - git commit -a -m "$CI_COMMIT_MESSAGE" --allow-empty
    - git push
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
    expire_in: 30 min
    when: always

git config update (master branch):
  <<: *git_config_update
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)"]

git config update w. bootstrap (master branch):
  <<: *git_config_update
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - render apic w. bootstrap (master branch)
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)"]

# Template for the GIT config update jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.git_tag_release: &git_tag_release
  stage: git update
  before_script: []
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - git config credential.helper "store --file=.git/credentials"
    - echo "https://GIT_TOKEN:$GITHUB_TOKEN@10.50.223.165" > .git/credentials
    - git config user.email $GITLAB_USER_EMAIL
    - git config user.name $GITLAB_USER_NAME
    # Add git remote to allow write operations, as the origin from the gitlab ci clone is read-only
    - git remote add origin-write https://GIT_TOKEN:$GITHUB_TOKEN@10.50.223.165/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME.git
    - git push --delete origin-write last_deploy
    - git tag -d last_deploy
    - git tag last_deploy
    - git push origin-write --tags
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - pipeline_failure.txt
    expire_in: 30 min
    when: always

git tag release (master branch):
  <<: *git_tag_release
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - render apic (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)", "test apic (master branch)"]

git tag release w. bootstrap (master branch):
  <<: *git_tag_release
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  needs: ["validate (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)", "test apic w. bootstrap (master branch)"]

# Template for the prepare notify jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.prepare_notify: &prepare_notify
  stage: notify
  before_script: []
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - python3 .ci/render-wx.py
    # Modify notification template to indicate pipeline success or failure
    # This is done this way, as Gitlab CI do not have a build-in variable for the overall pipeline success
    - if grep failed pipeline_failure.txt > /dev/null 2>&1; then sed -i 's/{{ build.status }}/failure/g' webex.txt; fi
    - if [ ! -f pipeline_failure.txt ]; then sed -i 's/{{ build.status }}/success/g' webex.txt; fi
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  artifacts:
    paths:
      - webex.txt
    expire_in: 10 min
    when: always
  when: always

prepare notification (master branch):
  <<: *prepare_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - validate (master branch)
    - render apic (master branch)
    - deploy apic (master branch)
    - test apic (master branch)
    - git config update (master branch)
    - git tag release (master branch)
  needs: ["validate (master branch)", "render apic (master branch)", "deploy apic (master branch)", "test apic (master branch)", "git config update (master branch)", "git tag release (master branch)"]

prepare notification w. bootstrap (master branch):
  <<: *prepare_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - validate (master branch)
    - bootstrap (master branch)
    - test bootstrap (master branch)
    - render apic w. bootstrap (master branch)
    - deploy apic w. bootstrap (master branch)
    - test apic w. bootstrap (master branch)
    - git config update w. bootstrap (master branch)
    - git tag release w. bootstrap (master branch)
  needs: ["validate (master branch)", "bootstrap (master branch)", "test bootstrap (master branch)", "render apic w. bootstrap (master branch)", "deploy apic w. bootstrap (master branch)", "test apic w. bootstrap (master branch)", "git config update w. bootstrap (master branch)", "git tag release w. bootstrap (master branch)"]

prepare notification (feature branch):
  <<: *prepare_notify
  rules:
    - if: $CI_COMMIT_BRANCH != "master" && ( $CI_PIPELINE_SOURCE != "tag" || $CI_PIPELINE_SOURCE != "merge_request_event")
  dependencies:
    - validate (feature branch)
  needs: ["validate (feature branch)"]

prepare notification (PR):
  <<: *prepare_notify
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  dependencies:
    - validate (PR)
    - render apic (PR)
  needs: ["validate (PR)", "render apic (PR)"]

# Template for the webex notify jobs, as multiple jobs are needed due to Gitlab CIs need for identical rules
.webex_notify: &webex_notify
  stage: notify
  image: ciscosso/drone-webex-team:v0.0.1
  before_script: []
  variables:
    PLUGIN_ACCESS_TOKEN: $SPARK_ACCESS_TOKEN
    PLUGIN_ROOM: 'moskrive ACI Build'
    DRONE_REPO_OWNER: $CI_PROJECT_NAMESPACE
    DRONE_REPO_NAME: $CI_PROJECT_NAME
    DRONE_COMMIT_SHA: $CI_COMMIT_SHA
    DRONE_COMMIT_BRANCH: $CI_COMMIT_BRANCH
    DRONE_COMMIT_AUTHOR: $CI_COMMIT_AUTHOR
    DRONE_COMMIT_AUTHOR_EMAIL: ''
    DRONE_BUILD_NUMBER: $CI_PIPELINE_ID
    DRONE_BUILD_STATUS: 'unknown'
    DRONE_BUILD_LINK: $CI_PIPELINE_URL
    DRONE_COMMIT_MESSAGE: $CI_COMMIT_MESSAGE
    DRONE_COMMIT_LINK: $CI_REPOSITORY_URL
  script:
    - echo -e "\e[0Ksection_start:`date +%s`:script\r\e[0KExecuting script"
    - IFS=""
    - env PLUGIN_BODY=$(cat webex.txt) /bin/drone-spark
    - echo -e "\e[0Ksection_end:`date +%s`:script\r\e[0K"
  when: always

webex notification (master branch):
  <<: *webex_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag"
  dependencies:
    - prepare notification (master branch)
  needs: ["prepare notification (master branch)"]

webex notification w. bootstrap (master branch):
  <<: *webex_notify
  rules:
    - if: $CI_COMMIT_BRANCH == "master" && $CI_PIPELINE_SOURCE != "tag" && $BOOTSTRAP == "true"
  dependencies:
    - prepare notification w. bootstrap (master branch)
  needs: ["prepare notification w. bootstrap (master branch)"]

webex notification (feature branch):
  <<: *webex_notify
  rules:
    - if: $CI_COMMIT_BRANCH != "master" && ( $CI_PIPELINE_SOURCE != "tag" || $CI_PIPELINE_SOURCE != "merge_request_event")
  dependencies:
    - prepare notification (feature branch)
  needs: ["prepare notification (feature branch)"]

webex notification (PR):
  <<: *webex_notify
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  dependencies:
    - prepare notification (PR)
  needs: ["prepare notification (PR)"]
```

## Section 8: Gitlab CI pipeline execution

Once the `.gitlab-ci.yml` file has been created is it time to run our pipeline. As all the changes were made on our local copy of the repository, it suffices to push the changes to our remote Gitlab repository. This can be done as follows:

```
~/Code/AAC_Lab$ git add .
~/Code/AAC_Lab$ git commit -m "Updating configuration"
~/Code/AAC_Lab$ git -c http.sslVerify=false push
```

You will notice that the local changes are pushed to the remote repository. Gitlab will automatically trigger a pipeline execution when it notices a .gitlab-ci.yml file. Hence, in Gitlab you should see that a pipeline is being executed. If all steps were completed successfully, the pipeline will show something like below

![aac_gitlab_runner_4](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab_runner4.png)

In case you encounter issues, go back to the local repository in your IDE, fix the issues for the corresponding step and push the changes back to the remote repository until the pipeline executes successfully.

You will see messages appearing in the Webex space you created earlier.

![gitlab_runner_webex_1](../assets/labs/guide_ansible_apic_gitlab_runner/gitlab_runner_webex1.png)
