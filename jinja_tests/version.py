# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import operator as py_operator
from distutils.version import LooseVersion


class Test:
    name = "version"

    @classmethod
    def test(cls, value, version, operator="eq"):
        """Perform a version comparison on a value"""
        operator_map = {
            "==": "eq",
            "=": "eq",
            "eq": "eq",
            "<": "lt",
            "lt": "lt",
            "<=": "le",
            "le": "le",
            ">": "gt",
            "gt": "gt",
            ">=": "ge",
            "ge": "ge",
            "!=": "ne",
            "<>": "ne",
            "ne": "ne",
        }

        operator = operator_map[operator]

        method = getattr(py_operator, operator)
        return method(LooseVersion(str(value)), LooseVersion(str(version)))
