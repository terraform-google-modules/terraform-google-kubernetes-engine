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
import json

MIGRATIONS = [
    {
        "resource_type": "google_container_node_pool",
        "name": "pools",
        "module": "",
        "for_each_migration": True,
        "for_each_migration_key": "name"
    },
]


class ModuleMigration:
    """
    Migrate the resources from a flat project factory to match the new
    module structure created by the G Suite refactor.
    """

    def __init__(self, source_module, state):
        self.source_module = source_module
        self.state = state

    def moves(self):
        """
        Generate the set of old/new resource pairs that will be migrated
        to the `destination` module.
        """
        resources = self.targets()
        for_each_migrations = []

        moves = []
        for (old, migration) in resources:
            new = copy.deepcopy(old)
            new.module += migration["module"]

            # Update the copied resource with the "rename" value if it is set
            if "rename" in migration:
                new.name = migration["rename"]

            old.plural = migration.get("old_plural", True)
            new.plural = migration.get("new_plural", True)

            if (migration.get("for_each_migration", False) and
                    migration.get("old_plural", True)):
                pass
                for_each_migrations.append((old, new, migration))
            else:
                pair = (old.path(), new.path())
                moves.append(pair)

        for_each_moves = self.for_each_moves(for_each_migrations)
        return moves + for_each_moves

    def for_each_moves(self, for_each_migrations):
        """
        When migrating from count to for_each we need to move the
        whole collection first
        https://github.com/hashicorp/terraform/issues/22301
        """
        for_each_initial_migration = {}
        moves = []

        for (old, new, migration) in for_each_migrations:
            # Do the initial migration of the whole collection
            # only once if it hasn't been done yet
            key = old.resource_type + "." + old.name
            if key not in for_each_initial_migration:
                for_each_initial_migration[key] = True
                old.plural = False
                new.plural = False

                pair = (old.path(), new.path())
                # moves.append(pair)

            # Whole collection is moved to new location. Now needs right index
            new.plural = True
            new_indexed = copy.deepcopy(new)
            new_indexed.key = self.state.resource_value(
                old, migration["for_each_migration_key"])
            pair = (new.path(), new_indexed.path())
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
        if re.match(r'\A[\w.\["/\]-]+\Z', path) is None:
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
        self.key = None
        self.plural = True

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
        if self.key is not None:
            path = "{0}[\"{1}\"]".format(path, self.key)
        elif self.index != -1 and self.plural:
            path = "{0}[{1}]".format(path, self.index)
        return path

    def __repr__(self):
        return "{}({!r}, {!r}, {!r})".format(
            self.__class__.__name__,
            self.module,
            self.resource_type,
            self.name)


class TerraformState:
    """
    A Terraform state representation, pulled from terraform state pull
    Used for getting values out of individual resources
    """

    def __init__(self):
        self.read_state()

    def read_state(self):
        """
        Read the terraform state
        """
        argv = ["terraform", "state", "pull"]
        result = subprocess.run(argv,
                                capture_output=True,
                                check=True,
                                encoding='utf-8')

        self.state = json.loads(result.stdout)

    def resource_value(self, resource, key):
        # Find the resource in the state
        state_resource_list = [r for r in self.state["resources"] if
                               r.get("module", "none") == resource.module and
                               r["type"] == resource.resource_type and
                               r["name"] == resource.name]

        if (len(state_resource_list) != 1):
            raise ValueError(
                "Could not find resource list in state for {}"
                .format(resource))

        index = int(resource.index)
        # If this a collection use the index to find the right resource,
        # otherwise use the first
        if (index >= 0):
            state_resource = [r for r in state_resource_list[0]["instances"] if
                              r["index_key"] == index]

            if (len(state_resource) != 1):
                raise ValueError(
                    "Could not find resource in state for {} key {}"
                    .format(resource, resource.index))
        else:
            state_resource = state_resource_list[0]["instances"]

        return state_resource[0]["attributes"][key]


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


def read_resources():
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


def state_changes_for_module(module, state):
    """
    Compute the Terraform state changes (deletions and moves) for a single
    module.
    """
    commands = []

    migration = ModuleMigration(module, state)

    for (old, new) in migration.moves():
        wrapper = "'{0}'"
        argv = ["terraform",
                "state",
                "mv",
                wrapper.format(old),
                wrapper.format(new)]
        commands.append(argv)

    return commands


def migrate(state=None, dryrun=False):
    """
    Generate and run terraform state mv commands to migrate resources from one
    state structure to another
    """

    # Generate a list of Terraform resource states from the output of
    # `terraform state list`
    resources = [
        TerraformResource.from_path(path)
        for path in read_resources()
    ]

    # Group resources based on the module where they're defined.
    modules = group_by_module(resources)

    # Filter our list of Terraform modules down to anything that looks like a
    # google network original module. We key this off the presence off of
    # `terraform-google-network` resource type and names
    modules_to_migrate = [
        module for module in modules
        if module.has_resource("google_container_node_pool", "pools")
    ]

    print("---- Migrating the following modules:")
    for module in modules_to_migrate:
        print("-- " + module.name)

    # Collect a list of resources for each module
    commands = []
    for module in modules_to_migrate:
        commands += state_changes_for_module(module, state)

    print("---- Commands to run:")
    for argv in commands:
        if dryrun:
            print(" ".join(argv))
        else:
            argv = [arg.strip("'") for arg in argv]
            subprocess.run(argv, check=True, encoding='utf-8')


def main(argv):
    parser = argparser()
    args = parser.parse_args(argv[1:])

    state = TerraformState()

    migrate(state=state, dryrun=args.dryrun)


def argparser():
    parser = argparse.ArgumentParser(description='Migrate Terraform state')
    parser.add_argument('--dryrun', action='store_true',
                        help='Print the `terraform state mv` commands instead '
                             'of running the commands.')
    return parser


if __name__ == "__main__":
    main(sys.argv)
