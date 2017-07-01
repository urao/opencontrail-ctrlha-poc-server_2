#!/usr/bin/env bash

cleanup_function () {

    DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    export PYTHONPATH=$PYTHONPATH:$DIR

    if [ `whoami` != "root" ]; then
        echo "must run as root, try \"sudo su\" and re-run"
        exit -1
    fi

    #log file
    path_to_log_file=$DIR/logs/$1

    source $DIR/.pockit/bin/activate
    
    echo
    echo "************************************"
    echo "Cleanup the complete installation"
    echo "===================================="
    echo
    echo "This may take a while..............."
    echo
    echo "************************************"
    
    python -u $DIR/post_deployment/sk_cleanup.py
    if [ $? -eq 1 ]; then
        echo
        echo "====================================================="
        echo "cleanup environment encountered errors"
        echo "please check log file at $path_to_log_file for errors"
        echo "====================================================="
        exit 1
    else
        echo
        echo "*******************************************************"
        echo "cleanup environment is done"
        echo "*******************************************************"
        echo
        exit 0
    fi
}

log_file_name="cleanup_log"
new_log_file="$log_file_name-$(date "+%Y_%m_%d_%H_%M_%S").txt"
cleanup_function $new_log_file 2>&1 | tee -a logs/$new_log_file
