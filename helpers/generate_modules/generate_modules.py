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

import os
import subprocess
import sys

from jinja2 import Environment, FileSystemLoader

TEMPLATE_FOLDER = "./autogen/main"
SAFER_TEMPLATE_FOLDER = "./autogen/safer-cluster"
AUTOGEN_NOTE = '// This file was automatically generated from a template in '


class Module(object):
    path = None
    options = {}

    def __init__(self, path, template_options):
        self.path = path
        self.options = template_options

    def template_options(self, base):
        return {k: v for d in [base, self.options] for k, v in d.items()}


MODULES = [
    Module("./", {
        'private_cluster': False,
    }),
    Module("./modules/private-cluster", {
        'module_path': '//modules/private-cluster',
        'private_cluster': True
    }),
    Module("./modules/beta-private-cluster", {
        'module_path': '//modules/beta-private-cluster',
        'private_cluster': True,
        'beta_cluster': True,
    }),
    Module("./modules/private-cluster-update-variant", {
        'module_path': '//modules/private-cluster-update-variant',
        'private_cluster': True,
        'update_variant': True,
    }),
    Module("./modules/beta-private-cluster-update-variant", {
        'module_path': '//modules/beta-private-cluster-update-variant',
        'private_cluster': True,
        'update_variant': True,
        'beta_cluster': True,
    }),
    Module("./modules/beta-public-cluster", {
        'module_path': '//modules/beta-public-cluster',
        'private_cluster': False,
        'beta_cluster': True,
    }),
]

SAFER_MODULES = [
    Module("./modules/safer-cluster", {
        'module_path': '//modules/safer-cluster',
    }),
    Module("./modules/safer-cluster-update-variant", {
        'module_path': '//modules/safer-cluster-update-variant',
        'update_variant': True,
    }),
]

DEVNULL_FILE = open(os.devnull, 'w')


def render_modules(template_folder, modules_list):
    env = Environment(
        keep_trailing_newline=True,
        loader=FileSystemLoader(template_folder),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    templates = env.list_templates()
    for module in modules_list:
        for template_file in templates:
            template = env.get_template(template_file)
            if template_file.endswith(".tf.tmpl"):
                template_file = template_file.replace(".tf.tmpl", ".tf")
            rendered = template.render(
                module.template_options(
                    {'autogeneration_note': AUTOGEN_NOTE + template_folder}
                )
            )
            with open(os.path.join(module.path, template_file), "w") as f:
                f.write(rendered)
                if template_file.endswith(".tf"):
                    subprocess.call(
                        [
                            "terraform",
                            "fmt",
                            "-write=true",
                            os.path.join(module.path, template_file)
                        ],
                        stdout=DEVNULL_FILE,
                        stderr=subprocess.STDOUT
                    )
                if template_file.endswith(".sh"):
                    os.chmod(os.path.join(module.path, template_file), 0o755)


def main(argv):
    render_modules(TEMPLATE_FOLDER, MODULES)
    render_modules(SAFER_TEMPLATE_FOLDER, SAFER_MODULES)

    DEVNULL_FILE.close()


if __name__ == "__main__":
    main(sys.argv)
