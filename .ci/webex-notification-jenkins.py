# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

# Expects the following environment variables:
# - WEBEX_TOKEN
# - WEBEX_ROOM_ID
# - JOB_NAME
# - BUILD_DISPLAY_NAME
# - RUN_DISPLAY_URL
# - BUILD_URL
# - GIT_COMMIT
# - GIT_URL
# - BUILD_STATUS

import json
import os
import requests

TEMPLATE = """[**[{status}] {job_name} {build}**]({url})
* _Commit_: [{commit}]({git_url})
* _Test Reports_: [APIC 4.2]({apic_42_url}) [APIC 5.2]({apic_52_url}) [MSO]({mso_url})
""".format(
    status=str(os.getenv("BUILD_STATUS") or "").lower(),
    job_name=os.getenv("JOB_NAME"),
    build=os.getenv("BUILD_DISPLAY_NAME"),
    url=os.getenv("RUN_DISPLAY_URL"),
    commit=os.getenv("GIT_COMMIT"),
    git_url=os.getenv("GIT_URL"),
    apic_42_url="",
    apic_52_url="",
    mso_url="",
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
