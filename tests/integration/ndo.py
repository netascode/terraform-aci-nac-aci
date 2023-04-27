# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import json
import re
import sys

import requests
import urllib3

from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from util import TimeoutHTTPAdapter

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


class Ndo:
    def __init__(self, url: str, username: str, password: str):
        self.url = url
        self.username = username
        self.password = password
        urllib3.disable_warnings()
        self.session = requests.Session()
        self.session.verify = False
        self.session.headers["Content-Type"] = "application/json"
        self.lookup_cache = {}

    def enable_retries(self):
        retry_strategy = Retry(
            total=5,
            backoff_factor=5,
            status_forcelist=[400, 429, 500, 502, 503, 504],
            method_whitelist=["GET", "PUT", "POST", "DELETE"],
        )
        adapter = TimeoutHTTPAdapter(max_retries=retry_strategy)
        self.session.mount("https://", adapter)

    def login(self):
        """NDO login"""
        credentials = {"username": self.username, "password": self.password}
        json_credentials = json.dumps(credentials)
        base_url = self.url + "/api/v1/auth/login"

        resp = self.session.post(base_url, data=json_credentials)

        if resp.status_code not in [200, 201]:
            return "NDO login failed, status code: {}, response: {}.".format(
                resp.status_code, resp.text
            )

        token = json.loads(resp.text)["token"]
        self.session.headers["Authorization"] = "Bearer " + token
        return None

    def logout(self):
        """NDO logout"""
        base_url = self.url + "/api/v1/auth/logout"
        resp = self.session.delete(base_url)
        if resp.status_code != 200:
            return "NDO logout failed, status code: {}".format(resp.status_code)
        return None

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
            sys.exit("Key '{}' missing from data".format(key))

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

    def _update_references(self, payload):
        """Locate and resolve references (%%xxx%xxx%%) in payload"""
        if isinstance(payload, dict):
            match_regex = "%%.*?%.*?%%"
            for k, v in payload.items():
                if isinstance(v, list):
                    for o in v:
                        self._update_references(o)
                else:
                    m = re.search(match_regex, str(v))
                    if m is not None:
                        d = m.group().find("%", 2)
                        path = m.group()[2:d]
                        key = m.group()[d + 1 : -2]
                        id = self._lookup(path, key).get("id")
                        if id is None:
                            sys.exit("Lookup failed for key '{}'".format(key))
                        payload[k] = re.sub(match_regex, id, str(v))

    def post_or_put(self, path: str, data: str, method: str = ""):
        """NDO POST or PUT"""
        if data:
            payload = json.loads(data)
        else:
            payload = {}

        # replace names with IDs in references
        self._update_references(payload)

        # update references in path
        path_dict = {"path": path}
        self._update_references(path_dict)
        path = path_dict["path"]

        # Query for existing object(s)
        lookup_path = path
        lookup_value = None
        method = API_ENDPOINT_MAPPINGS.get(path, {}).get("method", method)
        if lookup_path in API_ENDPOINT_MAPPINGS and method in ["put", "post_or_put"]:
            key = API_ENDPOINT_MAPPINGS.get(lookup_path, {}).get("key")
            has_id = API_ENDPOINT_MAPPINGS.get(lookup_path, {}).get("has_id")
            if key is not None:
                lookup_value = payload.get(key)
            existing_obj = self._lookup(lookup_path, lookup_value)
            if existing_obj and has_id:
                obj_id = existing_obj["id"]
                payload["id"] = obj_id
                path = path + "/{}".format(obj_id)
                method = "put"
            elif method == "post_or_put":
                method = "post"

        api_version = API_ENDPOINT_MAPPINGS.get(path, {}).get("api_version", "v1")
        api_prefix = API_ENDPOINT_MAPPINGS.get(path, {}).get("api_prefix", "")
        base_url = "{}/{}api/{}/{}".format(self.url, api_prefix, api_version, path)

        if method.upper() == "PUT":
            resp = self.session.put(base_url, data=json.dumps(payload))
        else:
            resp = self.session.post(base_url, data=json.dumps(payload))

        if resp.status_code not in [200, 201]:
            if "Cannot run program" in resp.text and resp.status_code == 400:
                return ""
            if "Site already managed" in resp.text and resp.status_code == 400:
                return ""
            return "NDO {} failed, status code: {}, response: {}.".format(
                method, resp.status_code, resp.text
            )
        return ""

    def get(self, path: str) -> str:
        """NDO GET"""
        # update references in path
        path_dict = {"path": path}
        self._update_references(path_dict)
        path = path_dict["path"]

        base_url = self.url + "/mso/api/v1/" + path

        resp = self.session.get(base_url)

        if resp.status_code != 200:
            return "NDO GET failed, status code: {}, response: {}.".format(
                resp.status_code, resp.text
            )
        return ""
