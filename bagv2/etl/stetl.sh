#!/bin/bash
#
# ETL voor BAG Extract versie 2 XML met gebruik Stetl en GDAL LVBAG Driver.
#
# Dit is een front-end/wrapper shell-script om  Stetl met een configuratie
# (etl-imbag.cfg) en parameters (options/myoptions.args) aan te roepen.
#
# Author: Just van den Broecke
#

# log
function log_info() {
  local msg=$1
  echo "INFO: $(date +"%y-%m-%d %H:%M:%S") - ${msg}"
}

NLX_ETL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NLX_HOME=$(cd ${NLX_ETL_DIR}/../../ && pwd)

pushd ${NLX_ETL_DIR}

# Set STETL_HOME directly
STETL_HOME="/c/Users/aminj/Anaconda3/Lib/site-packages/stetl"

# Ensure PYTHONPATH includes this new STETL_HOME
export PYTHONPATH="${STETL_HOME}:${NLX_HOME}:.:${PYTHONPATH}"

# Default arguments/options, common.args is always applied
common_options_file="${NLX_ETL_DIR}/options/common.args"
docker_options_file="${NLX_ETL_DIR}/options/docker.args"
options_file="${NLX_ETL_DIR}/options/default.args"

# Optionally overules default options file by using a host-based file options/<your hostname>.args
# To add your localhost add <your hostname>.args in options directory
[[ -f /.dockerenv  ]] && options_file="${docker_options_file}"
host_options_file="options/$(hostname).args"
[[ -f "${host_options_file}" ]] && options_file="${host_options_file}"

# Evt via commandline overrulen: etl.sh <my options file>  other args
# e.g. etl.sh options/docker.args
user_args="${@}"
[ -f "${1}" ] && options_file="${1}" && user_args="${@:2}"

log_info "Using options_file=${options_file} and user_args=${user_args}"

# Use the Python module to run stetl
python ${STETL_HOME}/main.py -a ${common_options_file} -a ${options_file} ${user_args}

popd
