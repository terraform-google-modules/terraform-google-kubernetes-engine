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

''' A simple test for the verify_boilerplate python script.
This will create a set of test files, both valid and invalid,
and confirm that the has_valid_header call returns the correct
value.

It also checks the number of files that are found by the
get_files call.
'''
from copy import deepcopy
from tempfile import mkdtemp
from shutil import rmtree
import unittest
from verify_boilerplate import has_valid_header, get_refs, get_regexs, \
    get_args, get_files


class AllTestCase(unittest.TestCase):
    """
    All of the setup, teardown, and tests are contained in this
    class.
    """

    def write_file(self, filename, content, expected):
        """
        A utility method that creates test files, and adds them to
        the cases that will be tested.

        Args:
            filename: (string) the file name (path) to be created.
            content: (list of strings) the contents of the file.
            expected: (boolean) True if the header is expected to be valid,
                false if not.
        """

        file = open(filename, 'w+')
        for line in content:
            file.write(line + "\n")
        file.close()
        self.cases[filename] = expected

    def create_test_files(self, tmp_path, extension, header):
        """
        Creates 2 test files for .tf, .xml, .go, etc and one for
        Dockerfile, and Makefile.

        The reason for the difference is that Makefile and Dockerfile
        don't have an extension. These would be substantially more
        difficult to create negative test cases, unless the files
        were written, deleted, and re-written.

        Args:
            tmp_path: (string) the path in which to create the files
            extension: (string) the file extension
            header: (list of strings) the header/boilerplate content
        """

        content = "\n...blah \ncould be code or could be garbage\n"
        special_cases = ["Dockerfile", "Makefile"]
        header_template = deepcopy(header)
        valid_filename = tmp_path + extension
        valid_content = header_template.append(content)
        if extension not in special_cases:
            # Invalid test cases for non-*file files (.tf|.py|.sh|.yaml|.xml..)
            invalid_header = []
            for line in header_template:
                if "2018" in line:
                    invalid_header.append(line.replace('2018', 'YEAR'))
                else:
                    invalid_header.append(line)
            invalid_header.append(content)
            invalid_content = invalid_header
            invalid_filename = tmp_path + "invalid." + extension
            self.write_file(invalid_filename, invalid_content, False)
            valid_filename = tmp_path + "testfile." + extension

        valid_content = header_template
        self.write_file(valid_filename, valid_content, True)

    def setUp(self):
        """
        Set initial counts and values, and initializes the setup of the
        test files.
        """
        self.cases = {}
        self.tmp_path = mkdtemp() + "/"
        self.my_args = get_args()
        self.my_refs = get_refs(self.my_args)
        self.my_regex = get_regexs()
        self.prexisting_file_count = len(
            get_files(self.my_refs.keys(), self.my_args))
        for key in self.my_refs:
            self.create_test_files(self.tmp_path, key,
                                   self.my_refs.get(key))

    def tearDown(self):
        """ Delete the test directory. """
        rmtree(self.tmp_path)

    def test_files_headers(self):
        """
        Confirms that the expected output of has_valid_header is correct.
        """
        for case in self.cases:
            if self.cases[case]:
                self.assertTrue(has_valid_header(case, self.my_refs,
                                                 self.my_regex))
            else:
                self.assertFalse(has_valid_header(case, self.my_refs,
                                                  self.my_regex))

    def test_invalid_count(self):
        """
        Test that the initial files found isn't zero, indicating
        a problem with the code.
        """
        self.assertFalse(self.prexisting_file_count == 0)


if __name__ == "__main__":
    unittest.main()
