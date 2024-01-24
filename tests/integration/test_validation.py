# -*- coding: utf-8 -*-

# Copyright: (c) 2022, Daniel Schmidt <danischm@cisco.com>

import os
import errorhandler
import pytest
from iac_validate.validator import Validator

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.validate

error_handler = errorhandler.ErrorHandler()

APIC_SCHEMA_PATH = "schemas/apic_schema.yaml"
NDO_SCHEMA_PATH = "schemas/ndo_schema.yaml"
VALIDATION_RULES_PATH = "validation/rules/"


@pytest.mark.parametrize(
    "data_paths", [(["tests/integration/fixtures/apic/standard/"])]
)
def test_apic_validation(data_paths):
    validator = Validator(APIC_SCHEMA_PATH, VALIDATION_RULES_PATH)
    validator.validate_syntax(data_paths)
    if validator.errors:
        pytest.fail("Syntactic validation has failed.")
    validator.validate_semantics(data_paths)
    if validator.errors:
        pytest.fail("Semantic validation has failed.")


@pytest.mark.parametrize("data_paths", [(["tests/integration/fixtures/ndo/standard/"])])
def test_ndo_validation(data_paths):
    validator = Validator(NDO_SCHEMA_PATH, ".rules/")
    validator.validate_syntax(data_paths)
    if validator.errors:
        pytest.fail("Syntactic validation has failed.")
