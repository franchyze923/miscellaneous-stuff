#!/bin/bash

echo "Updating Plex..."
sudo docker-compose -f /home/fran/plex/docker-compose.yml stop
sudo docker-compose -f /home/fran/plex/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/plex/docker-compose.yml pull
sudo docker-compose -f /home/fran/plex/docker-compose.yml up -d
echo "Done Updating Plex!"

echo "Updating Tautulli..."
sudo docker-compose -f /home/fran/tautulli/docker-compose.yml stop
sudo docker-compose -f /home/fran/tautulli/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/tautulli/docker-compose.yml pull
sudo docker-compose -f /home/fran/tautulli/docker-compose.yml up -d
echo "Done Updating Tautulli!"

echo "Updating SabNZB..."
sudo docker-compose -f /home/fran/sabnzbd/docker-compose.yml stop
sudo docker-compose -f /home/fran/sabnzbd/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/sabnzbd/docker-compose.yml pull
sudo docker-compose -f /home/fran/sabnzbd/docker-compose.yml up -d
echo "Done Updating SabNZB!"

echo "Updating lidarr..."
sudo docker-compose -f /home/fran/lidarr/docker-compose.yml stop
sudo docker-compose -f /home/fran/lidarr/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/lidarr/docker-compose.yml pull
sudo docker-compose -f /home/fran/lidarr/docker-compose.yml up -d
echo "Done Updating lidarr!"

echo "Updating sonarr..."
sudo docker-compose -f /home/fran/sonarr/docker-compose.yml stop
sudo docker-compose -f /home/fran/sonarr/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/sonarr/docker-compose.yml pull
sudo docker-compose -f /home/fran/sonarr/docker-compose.yml up -d
echo "Done updaing sonarr!"

echo "Updating radarr..."
sudo docker-compose -f /home/fran/radarr/docker-compose.yml stop
sudo docker-compose -f /home/fran/radarr/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/radarr/docker-compose.yml pull
sudo docker-compose -f /home/fran/radarr/docker-compose.yml up -d
echo "Done updating radarr!"

echo "Updating jackett.."
sudo docker-compose -f /home/fran/jackett/docker-compose.yml stop
sudo docker-compose -f /home/fran/jackett/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/jackett/docker-compose.yml pull
sudo docker-compose -f /home/fran/jackett/docker-compose.yml up -d
echo "Done updating jackett!"

echo "Updating Heimdall.."
sudo docker-compose -f /home/fran/heimdall/docker-compose.yml stop
sudo docker-compose -f /home/fran/heimdall/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/heimdall/docker-compose.yml pull
sudo docker-compose -f /home/fran/heimdall/docker-compose.yml up -d
echo "Done updating Heimdall!"

echo "Updating Jellyfin.."
sudo docker-compose -f /home/fran/jellyfin/docker-compose.yml stop
sudo docker-compose -f /home/fran/jellyfin/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/jellyfin/docker-compose.yml pull
sudo docker-compose -f /home/fran/jellyfin/docker-compose.yml up -d
echo "Done updating Jellyfin!"

echo "Updating Portainer.."
sudo docker-compose -f /home/fran/portainer/docker-compose.yml stop
sudo docker-compose -f /home/fran/portainer/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/portainer/docker-compose.yml pull
sudo docker-compose -f /home/fran/portainer/docker-compose.yml up -d
echo "Done updating Portainer!"

echo "Updating Wireguard.."
sudo docker-compose -f /home/fran/wireguard/docker-compose.yml stop
sudo docker-compose -f /home/fran/wireguard/docker-compose.yml rm -f
sudo docker-compose -f /home/fran/wireguard/docker-compose.yml pull
sudo docker-compose -f /home/fran/wireguard/docker-compose.yml up -d
echo "Done updating Wireguard!"

# echo "Updating tdarr.."
# sudo docker-compose -f /home/fran/tdarr/docker-compose.yml stop
# sudo docker-compose -f /home/fran/tdarr/docker-compose.yml rm -f
# sudo docker-compose -f /home/fran/tdarr/docker-compose.yml pull
# sudo docker-compose -f /home/fran/tdarr/docker-compose.yml up -d
# echo "Done updating tdarr!"

echo "Done Updating everything!!!"
