#!/bin/bash
cd ../makes
export PS4=${BASH_SOURCE}:${LINENO}: 
set -x

./entries.sh
