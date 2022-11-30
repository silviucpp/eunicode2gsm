#!/usr/bin/env bash

ROOT=$(pwd)
DEPS_LOCATION=_build/deps
OS=$(uname -s)
KERNEL=$(echo $(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 | awk '{print $1;}') | awk '{print $1;}')
CPUS=`getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu`

# https://github.com/silviucpp/unicode2gsm.git

U2GSM_DESTINATION=unicode2gsm
U2GSM_REPO=https://github.com/silviucpp/unicode2gsm.git
U2GSM_BRANCH=main
U2GSM_REV=24406c85a665d4cb73f3604a7956e71e182439a0
U2GSM_SUCCESS=build/libunidecode2gsm.a

fail_check()
{
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1" >&2
        exit 1
    fi
}

CheckoutLib()
{
    if [ -f "$DEPS_LOCATION/$4/$5" ]; then
        echo "$4 fork already exist. delete $DEPS_LOCATION/$4 for a fresh checkout ..."
    else
        #repo rev branch destination

        echo "repo=$1 rev=$2 branch=$3"

        mkdir -p $DEPS_LOCATION
        pushd $DEPS_LOCATION

        if [ ! -d "$4" ]; then
            fail_check git clone -b $3 $1 $4
        fi

        pushd $4
        fail_check git checkout $2
        BuildLibrary $4
        popd
        popd
    fi
}

BuildLibrary()
{
    unset CFLAGS
    unset CXXFLAGS

    case $1 in
        $U2GSM_DESTINATION)
            mkdir build
            pushd build
            fail_check cmake ..
            fail_check make -j $CPUS
            popd
            ;;
        *)
            ;;
    esac
}

CheckoutLib $U2GSM_REPO $U2GSM_REV $U2GSM_BRANCH $U2GSM_DESTINATION $U2GSM_SUCCESS
