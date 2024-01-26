#!/bin/bash

# Read container names from a file
CONTAINER_NAMES=$(cat container_names.txt)

# Choose a container
PS3="Select a container to update: "
select CONTAINER_NAME in $CONTAINER_NAMES; do
  [[ -n "$CONTAINER_NAME" ]] && break
  echo "Invalid selection, please choose again."
done

# Prompt for the new image version
read -p "Enter the new image version for $CONTAINER_NAME: " NEW_IMAGE_VERSION

image_name_lower=$(echo "vielitech/$CONTAINER_NAME:$NEW_IMAGE_VERSION" | tr '[:upper:]' '[:lower:]')
# Pull the new image
echo "Pulling the new image..."
docker pull "$(echo "$image_name_lower")"

# Check if the pull was successful
if [ $? -ne 0 ]; then
  echo "Failed to pull the new image. Exiting."
  exit 1
fi

# Get the IDs of running containers with names containing "Gump"
container_ids=$(docker ps --format '{{.Names}}' | grep $CONTAINER_NAME | awk '{print $1}')

echo Iniciando atualização de containers...
# Iterate over each container ID
for container_id in $container_ids; do
    container_info=$(docker inspect "$container_id")
    # Load relevant information from container_info into variables
    current_image=$(echo "$container_info" | jq -r '.[0].Config.Image')
    network_mode="$(echo "$container_info" | jq -r '.[0].HostConfig.NetworkMode')"
    volumes=$(echo "$container_info" | jq -r '.[0].Mounts[] | "--volume \(.Source):\(.Destination)"' | tr '\n' ' ')
    env_variables=$(echo "$container_info" | jq -r '.[0].Config.Env[]' | sed 's/\([^=]*\)=\(.*\)/-e "\1=\2"/' | tr '\n' ' ')

    # Extrair as portas do JSON
    ports=$(echo "$container_info" | jq -r '.[0].NetworkSettings.Ports | keys[] as $port | "\(.[$port][0].HostPort):\($port | sub("/tcp$"; ""))"')
    echo -e "\e[43mATUALIZANDO $container_id => Porta $ports\e[0m"
    # Stop and remove the existing container
    docker stop $container_id  >/dev/null 2>&1
    docker rm "$container_id"  >/dev/null 2>&1

    # Create and start the new container
    docker create -p "$ports" $volumes $env_variables  --name "$container_id" $image_name_lower  >/dev/null 2>&1
    docker start "$container_id"   >/dev/null 2>&1
    echo -e "\e[32mCONTAINER  <<<< $container_id >>>> ATUALIZADO para versão $image_name_lower\e[0m"

  done

docker ps | grep "${container_id%???}"
