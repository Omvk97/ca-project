#!/bin/bash

docker-compose up --force-recreate -d

if curl -s --head --request GET http://35.205.95.108:5000/ | grep "200 OK" >/dev/null; then
   echo "App is running on port 5000"
   exit 0
else
   echo "App is not running. Trying again in 5 seconds"
   sleep 5 # try again in 5 seconds
   if curl -s --head --request GET http://35.205.95.108:5000/ | grep "200 OK" >/dev/null; then
      exit 0
   else
      exit 1
   fi

fi
