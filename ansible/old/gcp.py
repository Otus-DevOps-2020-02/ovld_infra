#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import sys
import argparse
import json
import yaml
import googleapiclient.discovery
from google.oauth2 import service_account


inventory = {}
inventory['_meta'] = {}
inventory['_meta']['hostvars'] = {}
inventory['ungrouped'] = {}
inventory['ungrouped']['hosts'] = []
inventory['ungrouped']['vars'] = {}


def connection(cred_file):
    try:
        credentials = service_account.Credentials.from_service_account_file(cred_file)
        compute = googleapiclient.discovery.build('compute', 'v1', credentials=credentials)
    except Exception as exc:
        print(exc)
        sys.exit(1)
    else:
        return compute


def getInstances(connect, project, zone):

    try:
        instances = connect.instances().list(project=project, zone=zone).execute()
    except Exception as exc:
        print(exc)
        sys.exit(1)
    else:
        data = instances['items'] if 'items' in instances else None
        return data


def aggregation(instances):
    for instance in instances:
        inventory['_meta']['hostvars'][instance['networkInterfaces'][0]['accessConfigs'][0]['natIP']] = {k: instance[k] for k in instance if k}
        if 'items' in instance['tags']:
            for tag in instance['tags']['items']:
                inventory[tag] = {}
                inventory[tag]['hosts'] = []
                inventory[tag]['vars'] = {}

    for instance in inventory['_meta']['hostvars']:
        if 'items' in inventory['_meta']['hostvars'][instance]['tags']:
            for tag in inventory['_meta']['hostvars'][instance]['tags']['items']:
                if tag in inventory:
                    inventory[tag]['hosts'].append(instance)
        else:
            inventory['ungrouped']['hosts'].append(instance)

    for key in inventory:
        if '-' in key:
            inventory[key.replace('-', '_')] = inventory.pop(key)


def gen_config():
    config = {}
    with open("gcp.config", 'r') as stream:
        try:
            data = yaml.safe_load(stream)
            config['project'] = data['project']
            config['zone'] = data['zone']
            config['credentials_file'] = data['credentials_file']
        except yaml.YAMLError as exc:
            print(exc)
        else:
            return config


if __name__ == '__main__':
    config = gen_config()
    connect = connection(config['credentials_file'])
    instances = getInstances(connect, config['project'], config['zone'])
    aggregation(instances)

    parser = argparse.ArgumentParser()
    parser.add_argument('--list', help="Return inventory", action='store_true')
    parser.add_argument('--host', help="Return host vars if host exist in inventory['_meta']['hostvars']")
    args = parser.parse_args()
    if args.list:
        print(json.dumps(inventory))
    elif args.host:
        print(json.dumps(inventory['_meta']['hostvars'].get(args.host, {})))
    else:
        print(json.dumps(inventory))
