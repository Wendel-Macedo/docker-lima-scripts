# **Scripts for using Docker with Lima**

Scripts repository to automate the uninstall of Docker Desktop app and install and configuration of lima as an alternative.

## **install_lima.sh**

**In this script we:**

1. Install brew (if not installed)
1. Stop all docker containers
1. Remove all docker's containers, images, volumes, networks and caches,
1. Stop docker desktop
1. Uninstall docker desktop
1. Stop, delete images and remove colima (if installed)
1. Uninstall docker and docker-compose (only to be sure of a clean installation)
1. Remove .lima folder (only to be sure of a clean installation)
1. Install Lima, Docker and Docker-Compose
1. Create lima instance with lima.yaml (Configs file for this instance)
1. Set newly created instance as docker context

## **start_lima.sh**

**In this script we:**

1. Start lima with the instance created on above script (Needed only once per each system reboot/shutdown )

PS: This script could be set to run at each SO boot
