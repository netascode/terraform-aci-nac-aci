# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Daniel Schmidt <danischm@cisco.com>

# mypy: ignore-errors

import json

import requests
from robot.api.deco import keyword
import urllib3

__version__ = "0.1.0"

API_ENDPOINT_MAPPINGS = {
    "platform/remote-locations": {
        "container": "remoteLocations",
        "key": "name",
        "has_id": True,
    },
    "auth/providers/radius": {
        "container": "radiusProviders",
        "key": "host",
        "has_id": True,
    },
    "auth/providers/tacacs": {
        "container": "tacacsProviders",
        "key": "host",
        "has_id": True,
    },
    "auth/providers/ldap": {
        "container": "ldapProviders",
        "key": "host",
        "has_id": True,
    },
    "auth/domains": {
        "container": "domains",
        "key": "name",
        "has_id": True,
    },
    "users": {
        "container": "users",
        "key": "username",
        "has_id": True,
    },
    "roles": {
        "container": "roles",
        "key": "name",
        "has_id": True,
    },
    "sites": {
        "container": "sites",
        "key": "name",
        "has_id": True,
    },
    "sites/manage": {
        "container": "sites",
        "key": "name",
        "has_id": True,
        "method": "post",
        "api_version": "v2",
        "api_prefix": "mso/",
    },
    "tenants": {
        "container": "tenants",
        "key": "name",
        "has_id": True,
    },
    "schemas": {
        "container": "schemas",
        "key": "displayName",
        "has_id": True,
    },
    "auth/security/certificates": {
        "container": "caCertificates",
        "key": "name",
        "has_id": True,
    },
    "platform/systemConfig": {
        "container": "systemConfigs",
        "key": None,
        "has_id": True,
        "method": "put",
    },
    "policies/dhcp/relay": {
        "container": "DhcpRelayPolicies",
        "key": "name",
        "has_id": True,
    },
    "policies/dhcp/option": {
        "container": "DhcpRelayPolicies",
        "key": "name",
        "has_id": True,
    },
    "platform/security/keyrings": {
        "container": "keyrings",
        "key": "name",
        "has_id": True,
    },
    "sites/fabric-connectivity": {
        "container": None,
        "key": None,
        "has_id": False,
        "method": "put",
    },
    "tenants/allowed-users": {
        "container": None,
        "key": "domain_username",
        "has_id": True,
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

    def _query_tenant_users(self):
        """Helper to handle allowed-users queries"""
        found = []
        domains = {}
        base_url = self.url + "/api/v1/tenants/allowed-users/domains"
        resp = self.session.get(base_url)
        for obj in json.loads(resp.text)["domains"]:
            domains[obj["id"]] = obj["name"]
        base_url = self.url + "/api/v1/tenants/allowed-users"
        resp = self.session.get(base_url)
        if json.loads(resp.text) is None:
            return found
        for obj in json.loads(resp.text)["users"]:
            if obj["domainId"] in domains:
                obj["domain_username"] = (
                    domains[obj["domainId"]] + "/" + obj["username"]
                )
                found.append(obj)
        return found

    def _query_objs(self, path, key=None, **kwargs):
        """Retrieve objects via REST GET and optionally filter by key"""
        if path == "tenants/allowed-users":
            return self._query_tenant_users()
        found = []
        base_url = self.url + "/api/v1/" + path
        resp = self.session.get(base_url)
        objs = json.loads(resp.text)

        if objs == {}:
            return found

        if key is not None and key not in objs:
            raise Exception("Key '{}' missing from data".format(key))

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
                if search_key is None or obj.get(key) == search_key:
                    return obj
            return None

        container = API_ENDPOINT_MAPPINGS.get(path, {}).get("container")
        key = API_ENDPOINT_MAPPINGS.get(path, {}).get("key")
        obj = check_cache(key)
        if obj and use_cache:
            return obj
        self.lookup_cache[path] = self._query_objs(path, key=container)
        obj = check_cache(key)
        if obj:
            return obj
        return {}

    @keyword("NDO Lookup")
    def lookup(self, path, key):
        return self._lookup(path, key).get("id")
