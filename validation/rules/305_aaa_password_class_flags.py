class Rule:
    id = "305"
    description = "Verify AAA Security Settings - Password Class Flags"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        try:

            password_class_flags = inventory["apic"]["fabric_policies"]["aaa"]['management_settings']['password_strength_profile']['password_class_flags']
            
            # insert the list to the set
            list_set = set(password_class_flags)
            # convert the set to the list
            unique_list = (list(list_set))

            if len(unique_list) < 3 or len(unique_list) > 4:
                results.append(
                    "apic.fabric_policies.aaa.management_settings.password_class_flags - " +
                     str(password_class_flags) +
                     " is not a combination of at least three out of four options: digits,lowercase,specialchars,uppercase.")
        except KeyError:
            pass
        return results
