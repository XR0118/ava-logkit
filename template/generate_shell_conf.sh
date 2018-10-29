#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit
mkdir script
mkdir confs

generate_script() {
  cp template/template.sh script 
  mv script/template.sh script/readLog-"$1".sh
  sed -i 's/\"<dockerName>\"/\"'"$1"'\"/' script/readLog-"$1".sh
}

genreate_conf() {
  cp template/template.conf confs
  mv template/template.conf template/runner."$1"Log.conf
  sed -i 's/<dockerName>/'"$1"'/' template/runner."$1"Log.conf
  sed -i 's/\"<workflow_name>\"/\"'"$1"'\"/' template/runner."$1"Log.conf
  sed -i 's/\"<repo_name>\"/\"'"$1"'\"/' template/runner."$1"Log.conf
}



for docker in $(docker ps | awk '/alluxio-worker/||/alluxio-master/{print $NF}'); do
  generate_script "$docker"
  genreate_conf "$docker"
done