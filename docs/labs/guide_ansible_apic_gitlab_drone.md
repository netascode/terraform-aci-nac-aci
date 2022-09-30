# ACI as Code using Ansible, APIC, Gitlab and Drone

## Introduction

This lab guide will help you to get `ACI as Code` up and running using Gitlab as the source control system and Drone as the CICD server.

## Assumptions

This lab guide assumes the 'aci' flavour was selected during provisioning. Hence, no Nexus Dashboard is available.

## Section 1: Lab infrastructure

As part of the setup, you will have the following components:

1. Control Virtual machine running a Gitlab and Drone CICD instance
2. ACI simulator

Take a note of the IP addresses that got allocated to your POD. The generic placeholders below (e.g. CONTROLLER_IP, APIC_IP...) should be replaced with the values that have been allocated to your POD.
You will be able to access the instances on the following addresses:

- Gitlab: <https://CONTROLLER_IP>
- Drone: <http://CONTROLLER_IP:30080> (note: http and not https)
- ACI simulator: <https://APIC_IP>

## Section 2: Gitlab Configuration

### 2A) Access Gitlab

Go to the Gitlab instance at <https://CONTROLLER_IP>. Login with username `cisco` and password `cisco123`.

![aac_gitlab_1](../assets/labs/guide_ansible_apic_gitlab_drone/gitlab1.png)

### 2B) Repositories for ACI as Code

Three repositories have been created during the provisioning process:

1. <b>aac-inventory</b>: contains a sample repository representing the desired state of the ACI configuration. This repo is available at <https://CONTROLLER_IP/aci-iac/aac-inventory>

2. <b>ansible-aac</b>: contains the ACI as Code framework consisting of Ansible collection, modules, plugins being used by the aac-inventory repository. This repo is available at <https://CONTROLLER_IP/aci-iac/ansible-aac>

3. <b>terraform-aac</b>: contains the ACI as Code framework consisting of Terraform, modules, plugins being used by the aac-inventory repository. This repo will **not** be used in this lab guide althrough it is available at <https://CONTROLLER_IP/aci-iac/terraform-aac>

### 2C) Creating new repository

We will need to create a fourth repository to contain our configuration (single source of truth)

3. <b>aac-inventory-config</b>: not created as part of the POD setup so we will create it as follows:

Once logged in into your Gitlab instance, click on `New Project` and choose `Create blank project`. Use `aac-inventory-config` as the project name and ensure you set the organization to `aci-iac` in the Project URL. See below screenshot for an example.

![aac_gitlab_2](../assets/labs/guide_ansible_apic_gitlab_drone/gitlab2.png)

This will create an empty repository called `aac-inventory-config` which will be required later.

## Section 3: Drone Configuration

Drone is an easy-to-use CICD system that integrates well with Gitlab. We need to perform two activities:

1. Authorize Drone
2. Activate required repositories

### 3A) Authorize Drone

Go to the Drone instance at <http://CONTROLLER_IP:30080>. Drone integrates nicely with Gitlab. Hence, you will be asked to authorize against the Gitlab system.

![aac_drone_1](../assets/labs/guide_ansible_apic_gitlab_drone/drone1.png)

Click Authorize.

### 3B) Activate repositories

Drone will pull all repositories from Gitlab so you will also see them into the Drone system.

![aac_drone_2](../assets/labs/guide_ansible_apic_gitlab_drone/drone2.png)

In case you don't see all repositories, ensure to click the `sync` button.

All repositories are disabled by default so we need to activate them first. Click on the `Activate` button for the `aci-iac/aac-inventory` repository. You will be presented with the following screen:

![aac_drone_3](../assets/labs/guide_ansible_apic_gitlab_drone/drone3.png)

Click `Activate Repository`

## Section 4: ACI Simulator

Go to the ACI simulator on `https://APIC_IP`. You should be able to see the login screen.

![aac_aci_1](../assets/labs/guide_ansible_apic_gitlab_drone/aci1.png)

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
- [Configure Drone secrets](#5d-configure-drone-secrets)

### 5A) Clone aac-inventory locally

Go to the aac-inventory repo (<https://CONTROLLER_IP/aci-iac/aac-inventory>) and click on the `Clone` dropdown. Take note of the `Clone with HTTPS` value.

![aac_gitlab_3](../assets/labs/guide_ansible_apic_gitlab_drone/gitlab3.png)

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

![aac_webex_1](../assets/labs/guide_ansible_apic_gitlab_drone/webex1.png)

Select `Create a bot` and fill out all required fields. Use a unique bot username.

![aac_webex_2](../assets/labs/guide_ansible_apic_gitlab_drone/webex2.png)

Once finished, click `Add Bot` and your Webex bot will be created. You will receive a `Bot Access Token`. Copy this token as it will be required in the next section (e.g. SPARK_ACCESS_TOKEN).

#### 5B-2) Create a Webex space

Next, we will create a Webex space. In Webex, click the `+` icon and select ``Create Space`.

![aac_webex_3](../assets/labs/guide_ansible_apic_gitlab_drone/webex3.png)

Choose an appropriate name for your space. Then add the bot we created earlier as a member to this space.

![aac_webex_4](../assets/labs/guide_ansible_apic_gitlab_drone/webex4.png)

#### 5B-3) Retrieve Room ID

The Drone pipeline will need to know the room ID in order to be able to send messages to it. So in the section, we will retrieve the room ID for the room we just created. There are multiple ways to do this (e.g postman, python, CURL...). In this lab guide, we will use CURL.

Log into the Controller Virtual Machine using SSH.

```
~/Code/AAC_Lab$ ssh cisco@CONTROLLER_IP
cisco@aac-lab-pod-1-control:~$ curl -L -X GET 'https://api.ciscospark.com/v1/rooms' -H 'Authorization: Bearer <BEARER>' | json_pp -json_opt pretty,canonical
```

In the above command, replace the \<BEARER> value with Bot Access Token value that you received when the Webex Bot was created. If all went well, you will receive a response containing a JSON body. Copy the `id` and `title` as this contains the `Room ID` and the `Title` that will be needed in our drone pipeline in a later section.

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

![aac_gitlab_4](../assets/labs/guide_ansible_apic_gitlab_drone/gitlab4.png)

Take a note of the value as it will need to be added as a secret in Drone in the next section (e.g. GITHUB_TOKEN)

### 5D) Configure Drone secrets

Go to the `aci-iac/aac-inventory` repository on Drone and go to `Settings`. We will add some secrets to Drone that will be used inside the drone.yml file.

![aac_drone_4](../assets/labs/guide_ansible_apic_gitlab_drone/drone4.png)

Add the following secrets:

- ANSIBLE_VAULT_PASSWORD: set this to the Vault password you used earlier to encrypt the Ansible passwords. Click on `Allow Pull requests`.
- ARTIFACTORY_PASSWORD: we will use the Cisco internal artifactory (<https://engci-maven.cisco.com/artifactory>). Set this password to 'yp41v2t9wiuanhfr'.
- SPARK_ACCESS_TOKEN: set this to the token you created in the `Preparing Webex notifications` section. Click on `Allow Pull requests`.
- GITHUB_TOKEN: set this to the token you created in the `Create Gitlab Access Token` section. Click on `Allow Pull requests`.
- APIC_HOST: set this to the IP address of the APIC

When finished you should see the following secrets added to your repository:

![aac_drone_5](../assets/labs/guide_ansible_apic_gitlab_drone/drone5a.png)

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

### 6B) Change aci.yaml file

We need to change the `aci.yaml` file which can be found in the `aac-inventory/data/lab` folder. Make the following changes:

A. For simplicity we will use a simple APIC password. Add the `apic_password` password of the `ansible` user and comment out the `apic_private_key` and `apic_public_cert` section. You should have something similar to below example:

```
---
apic_mode: only_changed
apic_username: ansible
apic_password: C1sco123
# apic_private_key: !vault |
# ...
# apic_public_cert: |
# ...
```

Note: as this lab guide focuses only on APIC, you can comment out the MSO and NEA relevant parts in the rest of the file. These include:

- mso_mode
- apic_mso_username and apic_mso_password
- mso_test_username and mso_test_password
- mso_option_render
- mso_option_configure
- mso_option_delete
- mso_option_deploy
- nae_host
- nae_username
- nae_password
- nae_ignore_smart_events

### 6C) Remove mso1 directory file

Since we only use an APIC configuration, go ahead and remove the `aac-inventory/data/lab/host_vars/mso1` directory

## Section 7: Drone pipeline configuration

In this section, we will modify the drone.yml file. We will go step by step through the drone.yml file and specify the changes that are required in each of the steps. Go to the local (cloned) repository and open the `.drone.yml` file.

### Step: Setup

Description: the `Setup` step is installing the Ansible collection and is performing a git clone operation of the aci-inventory into the Drone container

Before:

```
  - name: Setup
    image: danischm/aac:0.3.1
    environment:
      GIT_SSL_NO_VERIFY: 'true'
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - ansible-galaxy install -r requirements.yml
      - mkdir previous
      - git clone --depth 1 --branch last_deploy https://CONTROLLER_IP/aci-iac/aac-inventory.git previous/
    depends_on:
      - Clone Repo
```

When you run the pipeline for the very first time, there will be no `last_deploy` branch yet. Hence we need to remove the --branch parameter (only the first time we run the pipeline).

After (first time):

```
  - name: Setup
    image: danischm/aac:0.3.1
    environment:
      GIT_SSL_NO_VERIFY: 'true'
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - ansible-galaxy install -r requirements.yml
      - mkdir previous
      - git clone --depth 1 https://CONTROLLER_IP/aci-iac/aac-inventory.git previous/
    depends_on:
      - Clone Repo
```

Once your pipeline will run successfully, you can change it to the following:

After (once pipeline was executed successfully)

```
  - name: Setup
    image: danischm/aac:0.3.1
    environment:
      GIT_SSL_NO_VERIFY: 'true'
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - ansible-galaxy install -r requirements.yml
      - mkdir previous
      - git clone --depth 1 --branch last_deploy https://CONTROLLER_IP/aci-iac/aac-inventory.git previous/
    depends_on:
      - Clone Repo
```

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

Currently, the `Validate` step will contain following code. As this guide only covers ACI, go ahead and comment out the MSO and NAE section.

```
  - name: Validate
    image: danischm/aac:0.3.1
    environment:
      ANSIBLE_VAULT_PASSWORD:
        from_secret: ANSIBLE_VAULT_PASSWORD
      APIC_HOST:
        from_secret: APIC_HOST
      MSO_HOST:
        from_secret: MSO_HOST
      NAE_HOST:
        from_secret: NAE_HOST
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - set -o pipefail
      - ansible-playbook -i data/lab/hosts.yaml apic_validate.yaml |& tee validate_output.txt
      # - ansible-playbook -i data/lab/hosts.yaml mso_validate.yaml |& tee validate_output.txt
    depends_on:
      - Setup
```

### Step: Bootstrap (first time only)

Description: the `Boostrap` step is responsible for setting up your ACI fabric for the first time. Hence the Bootstrap step is only required for Day-0 operations and can be removed once it was run successfully.

Currently, the `Bootstrap` step will not be in the drone.yml file so we need to add it. Copy and paste the following snippet to your drone file.

```
  - name: Bootstrap
    image: danischm/aac:0.3.1
    pull: never
    environment:
      ANSIBLE_VAULT_PASSWORD:
        from_secret: ANSIBLE_VAULT_PASSWORD
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - set -o pipefail
      - ansible-playbook -i data/lab/hosts.yaml apic_bootstrap.yaml |& tee bootstrap_output.txt
    when:
      # status: [failure]
      branch:
        - main
    depends_on:
      - Validate
```

The bootstrap step will only be executed on `status: [FAILURE]` so for the very first execution we need to comment it out so that it will always run.

### Step: Test Bootstrap (first time only)

Description: the `Test Bootstrap` step is responsible for testing the bootstrapped configuration.

Currently, the `Bootstrap` step will not be in the drone.yml file so we need to add it. Copy and paste the following snippet to your drone file.

```
  - name: Test Bootstrap
    image: danischm/aac:0.3.1
    pull: never
    environment:
      ANSIBLE_VAULT_PASSWORD:
        from_secret: ANSIBLE_VAULT_PASSWORD
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - set -o pipefail
      - ansible-playbook -i data/lab/hosts.yaml test_apic_bootstrap.yaml |& tee test_apic_bootstrap_output.txt
    depends_on:
      - Bootstrap
    when:
      branch:
        - master
```

### Step: Render

Description: the `Render APIC` step is responsible for creating the JSON bodies to effectly provision the fabric.

Currently, the `Render` step will contain following code. We need to make 3 changes:

- Comment out the MSO and NAE environment variables
- Change the `git clone` command to point it to your `aac-inventory-config` repository
- Change the if clause to point to the correct local directory

You should end up with the following:

```
  - name: Render APIC
    image: danischm/aac:0.3.1
    environment:
      GIT_SSL_NO_VERIFY: 'true'
      ANSIBLE_VAULT_PASSWORD:
        from_secret: ANSIBLE_VAULT_PASSWORD
      APIC_HOST:
        from_secret: APIC_HOST
    commands:
      - git clone https://CONTROLLER_IP/aci-iac/aac-inventory-config.git
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - 'echo "previous_inventory: ''./previous/data/lab/''" >> apic_render_vars.yaml'
      - >
        if [ "$FULL_APIC_DEPLOY" == "true" ]; then
          echo "apic_mode: 'all'" >> apic_render_vars.yaml
        fi
      - set -o pipefail
      - ansible-playbook -i data/lab/hosts.yaml -e @apic_render_vars.yaml apic_render.yaml |& tee render_output.txt
      - >
        if [ -d "./rendered" ]; then
          /bin/cp -rf ./rendered/ ./aac-inventory-config/
        fi
    depends_on:
      - Test Bootstrap
      - Validate
    when:
      branch:
        - master
```

Note: the first time we run our pipeline, we will add a dependency on the `Test Bootstrap`. After the pipeline was run successfully, that dependency can be removed.

### Step: NAE PCA

As this guide only focuses on APIC, you can comment out this section

### Step: Deploy APIC

Description: The `Deploy APIC` step is responsible for taking the rendered JSON bodies and use them to configure the ACI fabric.

The following changes are required:

- comment out the MSO and NAE environment variables
- comment out the' NAE PCA' dependency in the `depends on` part

You should have the following

```
  - name: Deploy APIC
    image: danischm/aac:0.3.1
    environment:
      ANSIBLE_VAULT_PASSWORD:
        from_secret: ANSIBLE_VAULT_PASSWORD
      APIC_HOST:
        from_secret: APIC_HOST
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - 'echo "apic_snapshot: $APIC_SNAPSHOT" >> apic_deploy_vars.yaml'
      - 'echo "apic_deploy: $APIC_DEPLOY" >> apic_deploy_vars.yaml'
      - 'echo "previous_inventory: ''./previous/data/lab/''" >> apic_deploy_vars.yaml'
      - >
        if [ "$FULL_APIC_DEPLOY" == "true" ]; then
          echo "apic_mode: 'all'" >> apic_deploy_vars.yaml
        fi
      - set -o pipefail
      - ansible-playbook -i data/lab/hosts.yaml -e @apic_deploy_vars.yaml apic_deploy.yaml |& tee deploy_output.txt
    when:
      branch:
        - master
      event:
        - push
    depends_on:
      - Render APIC
```

### Deploy MSO

As this guide only focuses on APIC, you can comment out this section

### Step: Test APIC

Description: the `Test APIC` step is responsible for testing the ACI fabric after the deployment has been finished

The following changes are required:

- comment out the MSO and NAE environment variables
- comment out the 'Deploy MSO' dependency in the `depends on` part

```
  - name: Test APIC
    image: danischm/aac:0.3.1
    environment:
      ANSIBLE_VAULT_PASSWORD:
        from_secret: ANSIBLE_VAULT_PASSWORD
      APIC_HOST:
        from_secret: APIC_HOST
    commands:
      - export ANSIBLE_CONFIG=$(pwd)/ansible.cfg
      - 'echo "test_apic_deploy: $TEST_APIC_DEPLOY" >> apic_test_vars.yaml'
      - 'echo "previous_inventory: ''./previous/data/lab/''" >> apic_test_vars.yaml'
      - >
        if [ "$FULL_APIC_TEST" == "true" ]; then
          echo "apic_mode: 'all'" >> apic_test_vars.yaml
        fi
      - set -o pipefail
      - ansible-playbook -i data/lab/hosts.yaml -e @apic_test_vars.yaml apic_test.yaml |& tee test_output.txt
    when:
      branch:
        - master
      event:
        - push
    depends_on:
      - Deploy APIC
```

### Test MSO

As this guide only focuses on APIC, you can comment out this section

### Step: Git Config Update

Description: the `Git Config Update` will store the rendered files inside the config repository that was created earlier (e.g. `aac-inventory-config`).

Currently, the `GIT Config Update` step will contain following code. Pay attention to the following:

- change the location in the `cd` command (1st line under the commands section) to the config directory that was created earlier (e.g. `aac-inventory-config`)
- use the Gitlab access token name (3rd line under the commands section) as created in the `Create Gitlab Access Token` section (e.g in our case the token was called `GIT_TOKEN')
- comment out the 'Deploy MSO' dependency in the `depends on` part

Your code should look as follows:

```
  - name: GIT Config Update
    image: danischm/aac:0.3.1
    environment:
      GIT_SSL_NO_VERIFY: 'true'
      GITHUB_TOKEN:
        from_secret: GITHUB_TOKEN
    commands:
      - cd aac-inventory-config
      - git config credential.helper "store --file=.git/credentials"
      - echo "https://GIT_TOKEN:$GITHUB_TOKEN@CONTROLLER_IP" > .git/credentials
      - git config user.email "$$DRONE_COMMIT_AUTHOR_EMAIL"
      - git config user.name "$$DRONE_COMMIT_AUTHOR"
      - git add -A
      - git commit -a -m "$$DRONE_COMMIT_MESSAGE" --allow-empty
      - git push
    when:
      branch:
        - master
      event:
        - push
    depends_on:
      - Deploy APIC
```

### Step: Git Tag Release

Description: the `GIT Tag Release` will tag the repository with the `last_deploy1 tag.

Change the following:

- use the Gitlab access token name (3rd line under the commands section) as created in the `Create Gitlab Access Token` section (e.g in our case the token was called `GIT_TOKEN')
- comment out the 'Test MSO' dependency in the depends on part

```
  - name: GIT Tag Release
    image: danischm/aac:0.3.1
    environment:
      GIT_SSL_NO_VERIFY: 'true'
      GITHUB_TOKEN:
        from_secret: GITHUB_TOKEN
    commands:
      - git config credential.helper "store --file=.git/credentials"
      - echo "https://GIT_TOKEN:$GITHUB_TOKEN@CONTROLLER_IP" > .git/credentials
      # - git push --delete origin last_deploy
      - git tag last_deploy
      - git push --tags
    when:
      branch:
        - master
      event:
        - push
    depends_on:
      - GIT Config Update
      - Test APIC
```

Note: the first time we run the code, there is no `last_deploy` so we cannot delete it. Hence, the first time we run the pipeline, we will comment out that line.

### Step: Upload Artifacts

Description: the `Upload Artifacts` step is responsible for uploading the automated test reports to an artifactory repository

Make the following changes:

- change the path to a different location so your reports are stored in a folder that belongs to you (e.g CEC_USERNAME/aac-lab)
- comment out the MSO related item under the sources part
- comment out the 'Test MSO' dependency in the depends on part

You should have something similar to:

```
  - name: Upload Artifacts
    image: jmccann/drone-artifactory:3.3
    settings:
      username: as-deployer
      password:
        from_secret: ARTIFACTORY_PASSWORD
      url: https://engci-maven.cisco.com/artifactory
      actions:
        - action: upload
          path: AS-release/Community/CEC_USERNAME/aac-lab/${DRONE_BUILD_NUMBER}/
          flat: false
          sources:
            - test_results/lab/apic1/*.*
    when:
      status: [changed, failure, success]
      branch:
        - master
      event:
        - push
    depends_on:
      - GIT Config Update
      - Test APIC
```

You will notice that we are using an internal Artifactory server. To login we use the as-deployer user. The password has been set as a Drone secret in a previous section .

### Step: Prepare Notify

Description: the `Prepare Notify` step is preparing the Webex notification messages.

Currently, the `Prepare Notify` step will contain following code. No changes as such are required.

```
  - name: Prepare Notify
    image: danischm/aac:0.3.1
    commands:
      - python3 .ci/render-wx.py
    when:
      status: [changed, failure, success]
    depends_on:
      - GIT Tag Release
      - Upload Artifacts
```

### Step: Notify

Description: the `Notify` is responsible for sending the rendered notifications to the selected Webex Teams room.

Currently, the `Prepare Notify` step will contain following code. Change the following lines:

- 'room': change to the name of the room (refer to the title value in section `Retrieve Room ID`)
- 'room_id': change to the room_id (refer to the id value in section `Retrieve Room ID`)

```
  - name: Notify
    image: ciscosso/drone-webex-team:v0.0.1
    settings:
      pull: true
      room: 'AAC Lab Notifications'
      room_id: 'Y2lzY29zcGFyazovL3VzL1JPT00vMDQ4NjIxZjAtYTZiYS0xMWVjLWIyMTctZGIxYmM5ZjJmZTQ3'
      access_token:
        from_secret: SPARK_ACCESS_TOKEN
      body: file:///drone/src/webex.txt
    when:
      status: [changed, failure, success]
    depends_on:
      - Prepare Notify
```

## Section 8: Drone pipeline execution

Once all the above changes have been made, it's time to run our pipeline. As all the changes were made on our local copy of the repository, it suffices to push the changes to our remote Gitlab repository. This can be done as follows:

```
~/Code/AAC_Lab$ git add .
~/Code/AAC_Lab$ git commit -m "Updating configuration"
~/Code/AAC_Lab$ git push origin master
```

You will notice that the local changes are pushed to the remote repository. Drone is configured to trigger a pipeline execution when it notices a .drone.yml file. Hence, in Drone you should see that a pipeline is being executed. If all steps were completed successfully, the pipeline will show something like below

![aac_drone_6](../assets/labs/guide_ansible_apic_gitlab_drone/drone6.png)

In case you encounter issues, go back to the local repository in your IDE, fix the issues for the corresponding step and push the changes back to the remote repository until the pipeline executes successfully.

You will see messages appearing in the Webex space you created earlier.

![aac_webex_5](../assets/labs/guide_ansible_apic_gitlab_drone/webex5.png)
