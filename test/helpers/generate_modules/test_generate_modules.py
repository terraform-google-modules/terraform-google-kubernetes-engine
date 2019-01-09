#!/usr/bin/env python

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import sys
import unittest

sys.path.append(
    os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            '../../../helpers/generate_modules')))

import generate_modules  # noqa: E402, F401


class TestGenerateRootMainTf(unittest.TestCase):
    def setUp(self):
        self.variables = {
            "var1": {},
            "var2": {"description": "variable 2 description"},
            "var3": {"type": "list"},
            "var4": {"default": [""]},
        }
        self.root_main_tf = generate_modules.root_main_tf(self.variables)

    def test_has_boilerplate(self):
        with open("./test/boilerplate/boilerplate.tf.txt") as fh:
            boilerplate = fh.read()
            self.assertIn(boilerplate, self.root_main_tf)

    def test_has_variables(self):
        for variable in self.variables:
            assignment = "{name} = \"${{var.{name}}}\"".format(name=variable)
            self.assertIn(assignment, self.root_main_tf)


class TestGenerateRootOutputsTf(unittest.TestCase):
    def setUp(self):
        self.outputs = {
            'output1': {'value': 'google_project.project.project_id'},
            'output2': {
                'description': 'Output 1 description',
                'value': 'google_service_account.default_service_account.email'
            }
        }
        self.root_outputs_tf = generate_modules.root_outputs_tf(self.outputs)

    def test_has_boilerplate(self):
        with open("./test/boilerplate/boilerplate.tf.txt") as fh:
            boilerplate = fh.read()
            self.assertIn(boilerplate, self.root_outputs_tf)

    def test_has_outputs(self):
        for output in self.outputs:
            name = 'output "{output}"'.format(output=output)
            self.assertIn(name, self.root_outputs_tf)

            value = 'value = "${{module.kubernetes-engine.{0}}}"'.format(
                output
            )
            self.assertIn(value, self.root_outputs_tf)

    def test_has_descriptions(self):
        described_outputs = {
            name: attrs for (name, attrs) in list(self.outputs.items())
            if "description" in attrs
        }

        for (name, attrs) in list(described_outputs.items()):
            value = 'description = "{desc}"'.format(desc=attrs["description"])
            self.assertIn(value, self.root_outputs_tf)


if __name__ == "__main__":
    unittest.main()
