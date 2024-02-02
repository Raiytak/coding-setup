#!/bin/bash
set -eou pipefail

scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function finish {
    rm -rf "${scratch}"
}
trap finish EXIT

short_args=(e: h k t: u: v:)
long_args=(environment: help k8s target_host: target_user: verbose:)

environment=""
target_host=""
verbose="-v"
target_user=""
with_k8s=false

ansible_cfg="${scratch}/ansible.cfg"
ansible_cfg_template="$(pwd)/ansible/ansible.cfg.template"
roles_path="$(pwd)/ansible/roles"

usage()
{
    printf "Help is on its way\n"
}

validate_args()
{
    if [ -z "${environment}" ]; then
        printf "No 'environment' provided\n"
        exit 1
    fi
    if [ -z "${target_host}" ]; then
        printf "No 'target_host' provided\n"
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
        -e | --environment )
            environment="$2"
            shift 2
            ;;
        -k | --k8s )
            with_k8s=true
            shift 1
            ;;
        -t | --target_host )
            target_host="$2"
            shift 2
            ;;
        -u | --target_user )
            target_user="$2"
            shift 2
            ;;
        -v | --verbose )
            verbose="$2"
            shift 2
            ;;
        -h | --help )
            usage
            exit 0
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

if [[ "${environment}" == "prod" ]]; then
    printf "Are you sure you want to launch the script on !! PROD !! ? {y/n}\n"
    read confirmation
    if [[ "${confirmation}" == "y" ]]; then
        printf "Exiting safely\n"
        exit 0
    fi
fi

# Prepare ansible config
cp "${ansible_cfg_template}" "${ansible_cfg}"
sed --in-place "s|ROLES_PATH|${roles_path}|" "${ansible_cfg}"

export ANSIBLE_CONFIG="${ansible_cfg}"
ansible-playbook  ansible/playbooks/dev_setup.yml                   \
    --inventory ansible/inventories/${environment}/hosts.yml        \
    --extra-vars "env=${environment}"                               \
    --extra-vars "target_host=${target_host}"                       \
    --extra-vars "target_user=${target_user}"                       \
    ${verbose}
if [ "${with_k8s}" ]; then
    ansible-playbook  ansible/playbooks/k8s_setup.yml                   \
        --inventory ansible/inventories/${environment}/hosts.yml        \
        --extra-vars "env=${environment}"                               \
        --extra-vars "target_host=${target_host}"                       \
        --extra-vars "target_user=${target_user}"                       \
        ${verbose}
fi
