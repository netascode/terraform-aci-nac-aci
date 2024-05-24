# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

# mypy: ignore-errors

import json

import requests
from robot.api.deco import keyword
import urllib3

__version__ = "0.2.0"

API_ENDPOINT_MAPPINGS = {
    "users": {
        "container": None,
        "key": "loginID",
        "id_key": "userID",
        "api_version": "v2",
    },
    "sites": {
        "container": "sites",
        "key": "common.name",
        "api_version": "v2",
    },
    "tenants": {
        "container": "tenants",
        "key": "name",
    },
    "schemas": {
        "container": "schemas",
        "key": "displayName",
    },
}


class Ndo(object):
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self, url: str, username: str, password: str):
        self.url = url
        self.username = username
        self.password = password
        urllib3.disable_warnings()
        self.session = requests.Session()
        self.session.verify = False
        self.session.headers["Content-Type"] = "application/json"
        self.lookup_cache = {}
        self._login()

    def _login(self):
        """NDO login"""
        credentials = {"username": self.username, "password": self.password}
        json_credentials = json.dumps(credentials)
        base_url = self.url + "/api/v1/auth/login"

        resp = self.session.post(base_url, data=json_credentials)

        if resp.status_code not in [200, 201]:
            raise Exception(
                "NDO login failed, status code: {}, response: {}.".format(
                    resp.status_code, resp.text
                )
            )

        token = json.loads(resp.text)["token"]
        self.session.headers["Authorization"] = "Bearer " + token

    def _query_objs(self, path, key=None, api_version="v1", **kwargs):
        """Retrieve objects via REST GET and optionally filter by key"""
        found = []
        base_url = self.url + "/mso/api/" + api_version + "/" + path
        resp = self.session.get(base_url)
        objs = json.loads(resp.text)

        if objs == {}:
            return found

        if key is not None and key not in objs:
            raise Exception("Key '{}' missing from data".format(key))

        if key is None and isinstance(objs, list):
            return objs
        if key is None:
            return [objs]
        if not isinstance(objs[key], list):
            return [objs[key]]
        for obj in objs[key]:
            for kw_key, kw_value in kwargs.items():
                if kw_value is None:
                    continue
                if obj[kw_key] != kw_value:
                    break
            else:
                found.append(obj)
        return found

    def _lookup(self, path, search_key, use_cache=True):
        """Lookup object by key either from a cache or via REST GET"""

        def check_cache(key):
            for obj in self.lookup_cache.get(path, []):
                keys = key.split(".")
                if search_key is None or obj.get(key) == search_key:
                    return obj
                elif len(keys) == 2 and obj.get(keys[0]).get(keys[1]) == search_key:
                    return obj
            return None

        container = API_ENDPOINT_MAPPINGS.get(path, {}).get("container")
        key = API_ENDPOINT_MAPPINGS.get(path, {}).get("key")
        obj = check_cache(key)
        if obj and use_cache:
            return obj
        self.lookup_cache[path] = self._query_objs(path, key=container, api_version=API_ENDPOINT_MAPPINGS.get(path, {}).get("api_version","v1"))
        obj = check_cache(key)
        if obj:
            return obj
        return {}

    @keyword("NDO Lookup")
    def lookup(self, path, key):
        key_id = API_ENDPOINT_MAPPINGS.get(path, {}).get("id_key","id")
        return self._lookup(path, key).get(key_id)
