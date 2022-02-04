#!/bin/sh

function RemoveDocker {
  if [[ $(command -v brew) == "" ]]; then
    echo "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Updating Homebrew"
    brew update
  fi

  # stop all containers
  docker kill $(docker ps -q)

  # remove all containers, images, volumes, networks and caches
  docker system prune --all --force --volumes

  #stop docker desktop
  osascript -e 'quit app "Docker"'

  # uninstall docker desktop
  if brew ls --version --casks docker >/dev/null; then
    brew uninstall --zap --cask docker
  else
    rm -Rf /Applications/Docker.app
  fi

  # stop colima
  colima stop

  # delete image
  colima delete

  # uninstall colima
  brew uninstall colima

  # uninstall docker
  brew uninstall docker

  # uninstall docker-compose
  brew uninstall docker-compose

  # edit .docker/config.json to remove 's' from 'credsStore'
  # if not remove, it will cause a error while trying to download a new image.
  sed -i.bak 's/credsStore/credStore/g' ~/.docker/config.json
}

function InstallLima {
  RemoveDocker

  rm -rf ~/.lima

  brew install lima
  brew install docker
  brew install docker-compose

  limactl start --tty=false lima.yaml

  docker context rm lima -f
  docker context create lima --docker "host=unix://$HOME/.lima/lima/sock/docker.sock"
  docker context use lima

  break
}

clear
echo ''
echo 'This script will install Lima as an alternative to Docker Desktop.'
echo ''
echo 'ATTENTION!'
echo '    An attempt to remove Docker Desktop and all its containers and images will occur.'
echo '    Are you sure that you want to continue?'
echo ''

while true; do
  read -r -p 'Type "y" to continue, "n" to cancel: ' choice
  case "$choice" in
  n | N | not | Not | NOT | nao | NAO | Nao) break ;;
  y | Y | yes | Yes | YES | sim | SIM | Sim) InstallLima ;;
  *) echo 'Y - yes or N - no' ;;
  esac
done
