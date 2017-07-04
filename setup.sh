#!/bin/bash
# Respectfully copied from https://github.com/christian-posta/kube-demos/blob/master/util.sh

reset=$(tput sgr0)
green=$(tput bold; tput setaf 2)
yellow=$(tput bold; tput setaf 3)
blue=$(tput bold; tput setaf 6)

function desc() {
    maybe_first_prompt
    echo "$blue# $@$reset"
    prompt
}

function prompt() {
    echo -n "$yellow\$ $reset"
}

started=""
function maybe_first_prompt() {
    if [ -z "$started" ]; then
        prompt
        started=true
    fi
}

function run() {
    maybe_first_prompt
    rate=25
    if [ -n "$DEMO_RUN_FAST" ]; then
      rate=1000
    fi
    echo "$green$1$reset" | pv -qL $rate
    if [ -n "$DEMO_RUN_FAST" ]; then
      sleep 0.5
    fi
    eval "$1"
    r=$?
    read -d '' -t 1 -n 10000 # clear stdin
    prompt
    if [ -z "$DEMO_AUTO_RUN" ]; then
      read -s
    fi
    return $r
}

function relative() {
    for arg; do
        echo "$(realpath $(dirname $(which $0)))/$arg" | sed "s|$(realpath $(pwd))|.|"
    done
}

trap "echo" EXIT
