class Filter:
    name = "cisco.aac.aac_bool"

    @classmethod
    def filter(cls, value, format):
        """Helper function for jinja rendering emulating Ansible cisco.aac.aac_bool filter"""
        v = False
        if value in [True, "enabled", "yes", "on"]:
            v = True

        if format is True:
            return v
        elif format == "enabled":
            return "enabled" if v else "disabled"
        elif format == "yes":
            return "yes" if v else "no"
        elif format == "on":
            return "on" if v else "off"
