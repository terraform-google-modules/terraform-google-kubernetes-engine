#!/usr/bin/env python3

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

# Please note that this file was generated from
# [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template).
# Please make sure to contribute relevant changes upstream!

''' Combine file from:
  * script argument 1
  with content of file from:
  * script argument 2
  using the beginning of line separators
  hardcoded using regexes in this file:

  We exclude any text using the separate
  regex specified here
'''

import os
import re
import sys

insert_separator_regex = r'(.*?\[\^\]\:\ \(autogen_docs_start\))(.*?)(\n\[\^\]\:\ \(autogen_docs_end\).*?$)'  # noqa: E501
exclude_separator_regex = r'(.*?)Copyright 20\d\d Google LLC.*?limitations under the License.(.*?)$'  # noqa: E501

if len(sys.argv) != 3:
    sys.exit(1)

if not os.path.isfile(sys.argv[1]):
    sys.exit(0)

input = open(sys.argv[1], "r").read()
replace_content = open(sys.argv[2], "r").read()

# Exclude the specified content from the replacement content
groups = re.match(
    exclude_separator_regex,
    replace_content,
    re.DOTALL
).groups(0)
replace_content = groups[0] + groups[1]

# Find where to put the replacement content, overwrite the input file
match = re.match(insert_separator_regex, input, re.DOTALL)
if match is None:
    print("ERROR: Could not find autogen docs anchors in", sys.argv[1])
    print("To fix this, insert the following anchors in your README where "
          "module inputs and outputs should be documented.")
    print("[^]: (autogen_docs_start)")
    print("[^]: (autogen_docs_end)")
    sys.exit(1)
groups = match.groups(0)
output = groups[0] + replace_content + groups[2] + "\n"
open(sys.argv[1], "w").write(output)
