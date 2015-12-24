#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Wrapper module for gdrive command"""

import os
import subprocess


# directory id in google drive of jsk
DIR_ID = '0B9P1L--7Wd2vUGplQkVLTFBWcFE'


def run_gdrive(args=None, stdout=True):
    if args is None:
        args = ''
    ros_home = os.getenv('ROS_HOME', os.path.expanduser('~/.ros'))
    pkg_ros_home = os.path.join(ros_home, 'jsk_data')
    config = os.path.join(pkg_ros_home, '.gdrive')
    cmd = 'rosrun jsk_data drive-linux-x64 --config {config} {args}'\
          .format(args=args, config=config)
    if stdout:
        return subprocess.check_output(cmd, shell=True)
    else:
        subprocess.call(cmd, shell=True)


def _init_gdrive():
    """This should be called before any commands with gdrive"""
    ros_home = os.getenv('ROS_HOME', os.path.expanduser('~/.ros'))
    pkg_ros_home = os.path.join(ros_home, 'jsk_data')
    config = os.path.join(pkg_ros_home, '.gdrive')
    if os.path.exists(config):
        return
    if not os.path.exists(pkg_ros_home):
        os.makedirs(pkg_ros_home)
    run_gdrive(stdout=False)


def list_gdrive():
    _init_gdrive()
    args = '''list --query " '{id}' in parents"'''.format(id=DIR_ID)
    return run_gdrive(args=args)


def upload_gdrive(filename):
    _init_gdrive()
    args = 'upload --file {file} --parent {id}'.format(file=filename,
                                                       id=DIR_ID)
    return run_gdrive(args=args)
