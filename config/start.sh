#!/bin/bash

# The bootstrap file is split to two. All the steps before we start the supervisor is located in init.sh
# This is intentional. The purpose of this is to use the same image for both web-container and cronjobs (See Kubernetes CronJob implementation)

/bin/bash init.sh

# Start the webserver
supervisord -n
