class Rule:
    id = "306"
    description = "Verify PTP Profiles"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        try:
            ptp_profiles = inventory["apic"]["access_policies"]["ptp_profiles"]

            for ptp in ptp_profiles:
                if ptp.get("template", "aes67") == "aes67":
                    if not 0 <= ptp.get("announce_interval", 1) <= 4:
                        results.append(
                            "apic.access_policies.ptp_profiles.announce_interval - "
                            + ptp.get("name")
                            + " is using AES67 where announce interval is not in the range of 0 to 4."
                        )

                    if not -4 <= ptp.get("sync_interval", -3) <= 1:
                        results.append(
                            "apic.access_policies.ptp_profiles.sync_interval - "
                            + ptp.get("name")
                            + " is using AES67 where announce interval is not in the range of -4 to 1."
                        )

                    if not -3 <= ptp.get("delay_interval", -3) <= 5:
                        results.append(
                            "apic.access_policies.ptp_profiles.delay_interval - "
                            + ptp.get("name")
                            + " is using AES67 where delay interval is not in the range of -3 to 5."
                        )

                    if not 2 <= ptp.get("announce_timeout", 3) <= 10:
                        results.append(
                            "apic.access_policies.ptp_profiles.announce_timeout - "
                            + ptp.get("name")
                            + " is using AES67 where timeout is not in the range of 2 to 10."
                        )

                elif ptp.get("template", "aes67") == "smpte":
                    if not -3 <= ptp.get("announce_interval", 1) <= 1:
                        results.append(
                            "apic.access_policies.ptp_profiles.announce_interval - "
                            + ptp.get("name")
                            + " is using SMTPE where announce interval is not in the range of -3 to 1."
                        )

                    if not -4 <= ptp.get("sync_interval", -3) <= -1:
                        results.append(
                            "apic.access_policies.ptp_profiles.sync_interval - "
                            + ptp.get("name")
                            + " is using SMTPE where sync interval is not in the range of -4 to -1."
                        )

                    if not -4 <= ptp.get("delay_interval", -3) <= 4:
                        results.append(
                            "apic.access_policies.ptp_profiles.delay_interval - "
                            + ptp.get("name")
                            + " is using SMTPE where delay interval is not in the range of -4 to 4."
                        )

                    if not 2 <= ptp.get("announce_timeout", 3) <= 10:
                        results.append(
                            "apic.access_policies.ptp_profiles.announce_timeout - "
                            + ptp.get("name")
                            + " is using SMPTE where timeout is not in the range of 2 to 10."
                        )

                elif ptp.get("template", "aes67") == "telecom":
                    if ptp.get("announce_interval", 1) != -3:
                        results.append(
                            "apic.access_policies.ptp_profiles.announce_interval - "
                            + ptp.get("name")
                            + " is using Telecom G.8275.1 where delay can only be -3."
                        )

                    if ptp.get("delay_interval", -3) != -4:
                        results.append(
                            "apic.access_policies.ptp_profiles.delay_interval - "
                            + ptp.get("name")
                            + " is using Telecom G.8275.1 where delay can only be -4."
                        )

                    if ptp.get("delay_interval", -3) != -4:
                        results.append(
                            "apic.access_policies.ptp_profiles.sync_interval - "
                            + ptp.get("name")
                            + " is using Telecom G.8275.1 where delay can only be -4."
                        )

                    if not 2 <= ptp.get("announce_timeout", 3) <= 4:
                        results.append(
                            "apic.access_policies.ptp_profiles.announce_timeout - "
                            + ptp.get("name")
                            + " is using Telecom G.8275.1 where timeout is not in the range of 2 to 4."
                        )
        except KeyError:
            pass
        return results
