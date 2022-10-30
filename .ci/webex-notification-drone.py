# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

# Expects the following environment variables:
# - WEBEX_TOKEN
# - WEBEX_ROOM_ID
# - DRONE_BUILD_STATUS
# - DRONE_REPO_OWNER
# - DRONE_REPO_NAME
# - DRONE_BUILD_NUMBER
# - DRONE_BUILD_LINK
# - DRONE_COMMIT_MESSAGE
# - DRONE_COMMIT_LINK
# - DRONE_COMMIT_AUTHOR_NAME
# - DRONE_COMMIT_AUTHOR_EMAIL
# - DRONE_COMMIT_BRANCH
# - DRONE_BUILD_EVENT

import json
import os
import requests

TEMPLATE = """[**[{build_status}] {repo_owner}/{repo_name} #{build_number}**]({build_link})
* _Commit_: [{commit_message}]({commit_link})
* _Author_: {commit_author_name} {commit_author_email}
* _Branch_: {commit_branch}
* _Event_:  {build_event}
* Test Reports: [APIC 4.2](https://engci-maven-master.cisco.com/artifactory/list/AS-release/Community/{repo_owner}/{repo_name}/{build_number}/apic_4.2_log.html) [APIC 5.2](https://engci-maven-master.cisco.com/artifactory/list/AS-release/Community/{repo_owner}/{repo_name}/{build_number}/apic_5.2_log.html) [MSO](https://engci-maven-master.cisco.com/artifactory/list/AS-release/Community/{repo_owner}/{repo_name}/{build_number}/mso_log.html)
""".format(
    build_status=os.getenv("DRONE_BUILD_STATUS"),
    repo_owner=os.getenv("DRONE_REPO_OWNER"),
    repo_name=os.getenv("DRONE_REPO_NAME"),
    build_number=os.getenv("DRONE_BUILD_NUMBER"),
    build_link=os.getenv("DRONE_BUILD_LINK"),
    commit_message=os.getenv("DRONE_COMMIT_MESSAGE"),
    commit_link=os.getenv("DRONE_COMMIT_LINK"),
    commit_author_name=os.getenv("DRONE_COMMIT_AUTHOR_NAME"),
    commit_author_email=os.getenv("DRONE_COMMIT_AUTHOR_EMAIL"),
    commit_branch=os.getenv("DRONE_COMMIT_BRANCH"),
    build_event=os.getenv("DRONE_BUILD_EVENT"),
)


def main():
    message = TEMPLATE

    body = {"roomId": os.getenv("WEBEX_ROOM_ID"), "markdown": message}
    headers = {
        "Authorization": "Bearer {}".format(os.getenv("WEBEX_TOKEN")),
        "Content-Type": "application/json",
    }
    resp = requests.post(
        "https://api.ciscospark.com/v1/messages", headers=headers, data=json.dumps(body)
    )
    if resp.status_code != 200:
        print(
            "Webex notification failed, status code: {}, response: {}.".format(
                resp.status_code, resp.text
            )
        )


if __name__ == "__main__":
    main()
