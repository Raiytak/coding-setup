#!/bin/bash
set -eou pipefail

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish {
    rm -rf "${scratch}"
}
trap finish EXIT

short_args=(e: h t: u: v:)
long_args=(help tags: target-host: target-user: verbose)

tags="all"
target_host=""
target_user=""
verbose="-v"

ansible_cfg="${scratch}/ansible.cfg"
roles_path="$(pwd)/ansible/roles"

usage()
{
    printf "Help is on its way\n"
}

validate_args()
{
    if [ -z "${target_host}" ]; then
        printf "No 'target-host' provided\n"
        exit 1
    fi
    if [ -z "${target_user}" ]; then
        printf "No 'target_user' provided\n"
        exit 1
    fi
}

parse_args()
{
    local ARGUMENTS=$(getopt                        \
        --options $(IFS=; echo "${short_args[*]}") \
        --long $(IFS=,; echo "${long_args[*]}")     \
        --name $(basename $0)                       \
        -- "$@")
    if [ $? -ne 0 ]; then
        usage
        exit 1
    fi
    eval set -- "$ARGUMENTS"
    while true; do
    case "$1" in
        -h | --help )
            usage
            exit 0
            ;;
        --tags )
            tags="$2"
            shift 2
            ;;
        -t | --target-host )
            target_host="$2"
            shift 2
            ;;
        -u | --target-user )
            target_user="$2"
            shift 2
            ;;
        -v | --verbose )
            verbose="-vvv"
            shift 2
            ;;
        -- )
            shift
            appargs="$@"
            break
            ;;
        * )
            echo "Invalid argument: $1"
            usage
            exit 1
            ;;
    esac
    done

    validate_args
}

parse_args "$@"

# Prepare ansible config
echo """
[defaults]
roles_path = ${roles_path}
host_key_checking = False
enable_plugins = yaml, ini
""" > ${ansible_cfg}
export ANSIBLE_CONFIG="${ansible_cfg}"
sed --in-place "s|ROLES_PATH|${roles_path}|" "${ansible_cfg}"

export ANSIBLE_CONFIG="${ansible_cfg}"
ansible-playbook  ansible/playbooks/dev_setup.yml   \
    --extra-vars "target_host=${target_host}"       \
    --extra-vars "target_user=${target_user}"       \
    --tags "${tags}"                                \
    "${verbose}"
