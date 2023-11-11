module "aci_match_rule" {
  source  = "netascode/nac-aci/aci//modules/terraform-aci-match-rule"
  version = ">= 0.8.0"

  tenant      = "ABC"
  name        = "MR1"
  description = "My Description"
  regex_community_terms = [{
    name        = "REGEX1"
    regex       = "1234"
    type        = "extended"
    description = "REGEX1 description"
  }]
  community_terms = [{
    name        = "COM1"
    description = "COM1 description"
    factors = [{
      community   = "regular:as2-nn2:1:2345"
      description = "2345 description"
      scope       = "non-transitive"
    }]
  }]
  prefixes = [{
    ip          = "10.1.1.0"
    description = "Prefix Description"
    aggregate   = true
    from_length = 25
    to_length   = 32
  }]
}
