#!/bin/bash

echo "Updating tdarr.."
sudo docker-compose -f /home/fran/tdarr/docker-compose.yml stop
sudo docker-compose -f /home/fran/tdarr/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/tdarr/docker-compose.yml pull
sudo docker-compose -f /home/fran/tdarr/docker-compose.yml up -d
echo "Done updating tdarr!"

