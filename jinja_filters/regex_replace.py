import re


class Filter:
    name = "regex_replace"

    @classmethod
    def filter(cls, value, pattern, replacement):
        """Helper function for jinja rendering emulating Ansible regex_replace filter"""
        return re.compile(pattern).sub(replacement.replace("\\\\g", "\\g"), str(value))
