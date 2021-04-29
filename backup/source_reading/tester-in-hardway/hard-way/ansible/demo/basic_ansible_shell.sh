#! /bin/sh

PLAYBOOK=$1
TAGS=$2
ansible-playbook $1 --tags $2 