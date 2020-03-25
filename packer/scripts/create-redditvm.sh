#!/bin/bash

function doit() {

  echo "[$(date +"%d-%m-%Y %I:%M:%S")] Deploy VM"
  echo "[$(date +"%d-%m-%Y %I:%M:%S")] Checking gcloud"
  if ( ! gcloud -v ); then
      echo "gcloud 404 :)"
  else
      echo "[$(date +"%d-%m-%Y %I:%M:%S")] gcloud ok"
      echo "[$(date +"%d-%m-%Y %I:%M:%S")] do with image is $image and image-project $image_project"
      echo "[$(date +"%d-%m-%Y %I:%M:%S")] creating instance reddit-app"
      gcloud compute instances create reddit-app \
      --boot-disk-size 10GB \
      --image $image \
      --image-project $image_project \
      --machine-type f1-micro \
      --tags puma-server \
      --restart-on-failure \
      --zone europe-west4-b
      if [ "$?" != "0" ]; then echo "[$(date +"%d-%m-%Y %I:%M:%S")] creating instance has failed"; exit 1; fi
      echo "[$(date +"%d-%m-%Y %I:%M:%S")] creating firewall-rule default-puma-server"
      gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags puma-server
      if [ "$?" != "0" ]; then echo "[$(date +"%d-%m-%Y %I:%M:%S")] reating firewall-rule has failed"; exit 1; fi
  fi

}


if [ -n "$1" ] && [ -f "$1" ]; then
    . $1
    doit
else
    echo "Usage: ./create-redditvm.sh path-to-config"
    exit 1
fi
