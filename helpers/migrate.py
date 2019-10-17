#!/usr/bin/env python3

# Copyright 2019 Google LLC
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

import argparse
import copy
import subprocess
import sys
import re

MIGRATIONS = [
    {
        "resource_type": "google_container_cluster",
        "name": "zonal_primary",
        "rename": "primary",
        "module": ""
    },
    {
        "resource_type": "google_container_node_pool",
        "name": "zonal_pools",
        "rename": "pools",
        "module": ""
    },
    {
        "resource_type": "null_resource",
        "name": "wait_for_zonal_cluster",
        "rename": "wait_for_cluster",
        "module": "",
        "plural": False
    },
]


class ModuleMigration:
    """
    Migrate the resources from a flat project factory to match the new
    module structure created by the G Suite refactor.
    """

    def __init__(self, source_module):
        self.source_module = source_module

    def moves(self):
        """
        Generate the set of old/new resource pairs that will be migrated
        to the `destination` module.
        """
        resources = self.targets()
        moves = []
        for (old, migration) in resources:
            new = copy.deepcopy(old)
            new.module += migration["module"]

            # Update the copied resource with the "rename" value if it is set
            if "rename" in migration:
                new.name = migration["rename"]

            old.plural = migration.get("plural", True)
            new.plural = migration.get("plural", True)

            pair = (old.path(), new.path())
            moves.append(pair)
        return moves

    def targets(self):
        """
        A list of resources that will be moved to the new module        """
        to_move = []

        for migration in MIGRATIONS:
            resource_type = migration["resource_type"]
            resource_name = migration["name"]
            matching_resources = self.source_module.get_resources(
                resource_type,
                resource_name)
            to_move += [(r, migration) for r in matching_resources]

        return to_move


class TerraformModule:
    """
    A Terraform module with associated resources.
    """

    def __init__(self, name, resources):
        """
        Create a new module and associate it with a list of resources.
        """
        self.name = name
        self.resources = resources

    def get_resources(self, resource_type=None, resource_name=None):
        """
        Return a list of resources matching the given resource type and name.
        """

        ret = []
        for resource in self.resources:
            matches_type = (resource_type is None or
                            resource_type == resource.resource_type)

            name_pattern = re.compile(r'%s(\[\d+\])?' % resource_name)
            matches_name = (resource_name is None or
                            name_pattern.match(resource.name))

            if matches_type and matches_name:
                ret.append(resource)

        return ret

    def has_resource(self, resource_type=None, resource_name=None):
        """
        Does this module contain a resource with the matching type and name?
        """
        for resource in self.resources:
            matches_type = (resource_type is None or
                            resource_type == resource.resource_type)

            matches_name = (resource_name is None or
                            resource_name in resource.name)

            if matches_type and matches_name:
                return True

        return False

    def __repr__(self):
        return "{}({!r}, {!r})".format(
            self.__class__.__name__,
            self.name,
            [repr(resource) for resource in self.resources])


class TerraformResource:
    """
    A Terraform resource, defined by the the identifier of that resource.
    """

    @classmethod
    def from_path(cls, path):
        """
        Generate a new Terraform resource, based on the fully qualified
        Terraform resource path.
        """
        if re.match(r'\A[\w.\[\]-]+\Z', path) is None:
            raise ValueError(
                "Invalid Terraform resource path {!r}".format(path))

        parts = path.split(".")
        name = parts.pop()
        resource_type = parts.pop()
        module = ".".join(parts)
        return cls(module, resource_type, name)

    def __init__(self, module, resource_type, name):
        """
        Create a new TerraformResource from a pre-parsed path.
        """
        self.module = module
        self.resource_type = resource_type

        find_suffix = re.match(r'(^.+)\[(\d+)\]', name)
        if find_suffix:
            self.name = find_suffix.group(1)
            self.index = find_suffix.group(2)
        else:
            self.name = name
            self.index = -1

    def path(self):
        """
        Return the fully qualified resource path.
        """
        parts = [self.module, self.resource_type, self.name]
        if parts[0] == '':
            del parts[0]
        path = ".".join(parts)
        if self.index != -1 and self.plural:
            path = "{0}[{1}]".format(path, self.index)
        return path

    def __repr__(self):
        return "{}({!r}, {!r}, {!r})".format(
            self.__class__.__name__,
            self.module,
            self.resource_type,
            self.name)


def group_by_module(resources):
    """
    Group a set of resources according to their containing module.
    """

    groups = {}
    for resource in resources:
        if resource.module in groups:
            groups[resource.module].append(resource)
        else:
            groups[resource.module] = [resource]

    return [
        TerraformModule(name, contained)
        for name, contained in groups.items()
    ]


def read_state(statefile=None):
    """
    Read the terraform state at the given path.
    """
    argv = ["terraform", "state", "list"]
    result = subprocess.run(argv,
                            capture_output=True,
                            check=True,
                            encoding='utf-8')
    elements = result.stdout.split("\n")
    elements.pop()
    return elements


def state_changes_for_module(module, statefile=None):
    """
    Compute the Terraform state changes (deletions and moves) for a single
    module.
    """
    commands = []

    migration = ModuleMigration(module)

    for (old, new) in migration.moves():
        wrapper = '"{0}"'
        argv = ["terraform",
                "state",
                "mv",
                wrapper.format(old),
                wrapper.format(new)]
        commands.append(argv)

    return commands


def migrate(statefile=None, dryrun=False):
    """
    Migrate the terraform state in `statefile` to match the post-refactor
    resource structure.
    """

    # Generate a list of Terraform resource states from the output of
    # `terraform state list`
    resources = [
        TerraformResource.from_path(path)
        for path in read_state(statefile)
    ]

    # Group resources based on the module where they're defined.
    modules = group_by_module(resources)

    # Filter our list of Terraform modules down to anything that looks like a
    # zonal GKE module. We key this off the presence off of
    # `google_container_cluster.zonal_primary` since that should almost always
    # be unique to a GKE module.
    modules_to_migrate = [
        module for module in modules
        if module.has_resource("google_container_cluster", "zonal_primary")
    ]

    print("---- Migrating the following modules:")
    for module in modules_to_migrate:
        print("-- " + module.name)

    # Collect a list of resources for each module
    commands = []
    for module in modules_to_migrate:
        commands += state_changes_for_module(module, statefile)

    print("---- Commands to run:")
    for argv in commands:
        if dryrun:
            print(" ".join(argv))
        else:
            argv = [arg.strip('"') for arg in argv]
            subprocess.run(argv, check=True, encoding='utf-8')


def main(argv):
    parser = argparser()
    args = parser.parse_args(argv[1:])

    # print("cp {} {}".format(args.oldstate, args.newstate))
    # shutil.copy(args.oldstate, args.newstate)

    migrate(dryrun=args.dryrun)


def argparser():
    parser = argparse.ArgumentParser(description='Migrate Terraform state')
    parser.add_argument('--dryrun', action='store_true',
                        help='Print the `terraform state mv` commands instead '
                             'of running the commands.')
    return parser


if __name__ == "__main__":
    main(sys.argv)
