#!/bin/bash
set -eou pipefail

finish() {
    result=$?
    exit ${result}
    rm -rf "${scratch}"
}
trap finish EXIT ERR

scratch=$(mktemp -d -t -q tmp.XXXXXXXXXX)

pushd $(pwd) > /dev/null
cd "${scratch}"
pwd
today=$(date +'%Y-%m-%d')
homefiles="homefiles_${today}"
mkdir "${homefiles}" && cd "${homefiles}"

cp -r "${HOME}/vimwiki" .

favorite_dotfile=(
    ".bash_aliases"
    ".bashrc"
    ".gitconfig"
    ".p10k.zsh"
    ".profile"
    ".vimrc"
    ".zshrc"
)
mkdir dotfiles
for file in "${favorite_dotfile[@]}"; do
    cp "${HOME}/${file}" dotfiles/
done

popd > /dev/null
tar -zcf "save-${homefiles}.tar.gz" -C "${scratch}" "${homefiles}"

printf "Done 🦛\n"
