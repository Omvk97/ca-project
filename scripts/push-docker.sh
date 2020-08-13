#!/bin/bash

docker push "$DOCKERCREDS_USR/ca-project:latest" &
wait