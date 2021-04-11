#!/usr/bin/env bash

#
# This file should be used to prepare and run your WebProxy after set up your .env file
# Source: https://github.com/evertramos/nginx-proxy-automation
#

# 1. Check if .env file exists

if [ -e .env ]; then
    echo ".env file found, sourcing contents..."
    source .env
else 
    echo 
    echo "Please set up your .env file before starting your cloud environment."
    echo 
    exit 1
fi

# 2. Copy configuration files

if [ -w ${NEXTCLOUD_PATH} ]; then 
    echo "${NEXTCLOUD_PATH} is user writable. Copying config files..."
    mkdir -p ${NEXTCLOUD_PATH}/config
    cp ./config-files/nextcloud-web/nginx.conf ${NEXTCLOUD_PATH}/config/
else
    echo "'${NEXTCLOUD_PATH}' is not user writable. Copying config files with sudo..."
    sudo mkdir -p ${NEXTCLOUD_PATH}/config
    sudo cp ./config-files/nextcloud-web/nginx.conf ${NEXTCLOUD_PATH}/config/
fi

# 2.1 If there was any errors inform the user
if [ $? -ne 0 ]; then
    echo
    echo "#######################################################"
    echo
    echo "There was an error trying to copy the nginx conf files."
    echo "Unable to continue, exiting..."
    echo 
    echo "#######################################################"
    exit 1
fi

# 3. Check if user set to use Special Conf Files
if [ ! -z ${USE_NGINX_CONF_FILES+X} ] && [ "$USE_NGINX_CONF_FILES" = true ]; then

    if [ -w ${NGINX_PROXY_PATH} ]; then
        echo "'${NGINX_PROXY_PATH}' is user writable. Copying config files..."
        mkdir -p ${NGINX_PROXY_PATH}/conf.d
        # Copy the special configurations to the nginx conf folder
        cp -R ./config-files/nginx-proxy-conf.d/*.conf $NGINX_PROXY_PATH/conf.d
    else
        echo "'${NGINX_PROXY_PATH}' is not user writable. Copying config files with sudo..."
        sudo mkdir -p ${NGINX_PROXY_PATH}/conf.d
        sudo cp -R ./config-files/nginx-proxy-conf.d/*.conf $NGINX_PROXY_PATH/conf.d
    fi

    # 3.1 If there was any errors inform the user
    if [ $? -ne 0 ]; then
        echo
        echo "#######################################################"
        echo
        echo "There was an error trying to copy the nginx conf files."
        echo "The proxy will still work with default options, but"
        echo "the custom settings your have made could not be loaded."
        echo 
        echo "#######################################################"
    fi
fi 


# 4. Create proxy network
docker network create ${INSTANCE_PREFIX}-proxy-network $PROXY_NETWORK_OPTIONS

# 5. Create nextcloud network
docker network create ${INSTANCE_PREFIX}-nextcloud-network $NEXTCLOUD_NETWORK_OPTIONS

# 6. Update local images
docker-compose pull

# 7. Release the kraken!

docker-compose up -d

exit 0
