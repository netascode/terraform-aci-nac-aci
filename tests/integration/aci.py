# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import json

import requests
import urllib3
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from util import TimeoutHTTPAdapter


class Apic:
    def __init__(self, url: str, username: str, password: str):
        self.url = url
        self.username = username
        self.password = password
        self.cookie = None
        retry_strategy = Retry(
            total=4,
            status_forcelist=[429, 500, 502, 503, 504],
            allowed_methods=["GET", "POST", "DELETE"],
            backoff_factor=5,
        )
        adapter = TimeoutHTTPAdapter(max_retries=retry_strategy)
        urllib3.disable_warnings()
        self.session = requests.Session()
        self.session.mount("https://", adapter)
        self.session.verify = False

    def login(self) -> str:
        """APIC login"""
        credentials = {
            "aaaUser": {"attributes": {"name": self.username, "pwd": self.password}}
        }
        json_credentials = json.dumps(credentials)
        base_url = self.url + "/api/aaaLogin.json"

        resp = self.session.post(base_url, data=json_credentials)

        if resp.status_code != 200:
            return "APIC login failed, status code: {}, response: {}.".format(
                resp.status_code, resp.text
            )

        token = json.loads(resp.text)["imdata"][0]["aaaLogin"]["attributes"]["token"]
        self.cookie = {"APIC-Cookie": token}
        return ""

    def post(self, data: str) -> str:
        """APIC POST"""
        base_url = self.url + "/api/mo/uni.json"
        resp = self.session.post(base_url, data=data, cookies=self.cookie)
        if resp.status_code != 200:
            return "APIC POST failed, status code: {}, response: {}".format(
                resp.status_code, resp.text
            )
        return ""

    def logout(self) -> str:
        """APIC logout"""
        base_url = self.url + "/api/aaaLogout.json"
        resp = self.session.post(base_url, cookies=self.cookie)
        if resp.status_code != 200:
            return "APIC logout failed, status code: {}".format(resp.status_code)
        return ""
