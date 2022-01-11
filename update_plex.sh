#!/bin/bash

echo "Updating Plex..."
echo "Pulling latest image"
docker pull linuxserver/plex
echo "Stopping Plex"
docker stop plex
echo "Removing old plex"
docker rm plex
echo "Creating new plex container"
docker create   --name=plex   --net=host   -e PUID=1000   -e PGID=1000   -e VERSION=docker   -e UMASK_SET=022 `#optional`   -e PLEX_CLAIM= `#optional`   -v /home/fran/plex:/config    -v /mnt/FranArchives/Media/Music_Videos:/music_videos -v /mnt/FranArchives/Media/Music:/music  -v /mnt/FranArchives/Media/Movies:/movies   -v /mnt/FranArchives/Media/TV_Shows:/tvshows   -v /mnt/FranArchives/Home_Media/Family_Videos:/family_videos   -v /mnt/FranArchives/Home_Media/Frans_Videos/for_plex:/fran_plex_videos   --restart always   linuxserver/plex
echo "Starting container"
docker start plex
echo "Pruning old images"
docker image prune -f

echo "Done"