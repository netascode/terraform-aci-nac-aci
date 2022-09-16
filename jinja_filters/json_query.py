import jmespath


class Filter:
    name = "community.general.json_query"

    @classmethod
    def filter(cls, data, expr):
        """Helper function for jinja rendering emulating Ansible json_query filter"""
        return jmespath.search(expr, data)
