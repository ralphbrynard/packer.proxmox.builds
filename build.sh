#!/usr/bin/bash

set -e

follow_link() {
  FILE="$1"
  while [ -h "$FILE" ]; do
    # On Mac OS, readlink -f doesn't work.
    FILE="$(readlink "$FILE")"
  done
  echo "$FILE"
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Usage: script.sh [OPTIONS] [CONFIG_PATH]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message and exit."
    echo "  -d, --debug     Run builds in debug mode."
    echo ""
    echo "Arguments:"
    echo "  CONFIG_PATH     Path to the configuration directory."
    echo ""
    echo "Examples:"
    echo "  ./build.sh"
    echo "  ./build.sh --debug"
    echo "  ./build.sh config"
    echo "  ./build.sh --debug config"
    exit 0
fi

if [ "$1" == "--debug" ] || [ "$1" == "-d" ]; then
  debug_mode=true
  debug_option="-debug"
  shift
else
  debug_mode=false
  debug_option=""
fi

SCRIPT_PATH=$(realpath "$(dirname "$(follow_link "$0")")")

if [ -n "$1" ]; then
  CONFIG_PATH=$(realpath "$1")
else
  CONFIG_PATH=$(realpath "${SCRIPT_PATH}/config")
fi

menu_banner=$(cat << "EOF"
    ____             __                ____        _ __    __     
   / __ \____ ______/ /_____  _____   / __ )__  __(_) /___/ /____ 
  / /_/ / __  / ___/ //_/ _ \/ ___/  / __  / / / / / / __  / ___/ 
 / ____/ /_/ / /__/ ,< /  __/ /     / /_/ / /_/ / / / /_/ (__  )  
/_/    \__,_/\___/_/|_|\___/_/     /_____/\__,_/_/_/\__,_/____/   
EOF
)

menu_message="Select a HashiCorp Packer build for Proxmox."

if [ "$debug_mode" = true ]; then
  menu_message+=" \e[31m(Debug Mode)\e[0m"
fi

menu_option_1() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/server/2019
    echo -e "\nCONFIRM: Build all Windows Server 2019 Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build Windows Server 2019 Template for Proxmox. ###
    echo "Building all Windows Server 2019 Template for Proxmox..."

    ### Initialize Packer ###
    echo "Initializing Hashicorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "2019"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"
    
    ### Build complete ###
    echo "Build Complete."
}

menu_option_2() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/server/2019
    echo -e "\nCONFIRM: Build Microsoft Windows Server 2019 Standard Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build Microsoft Windows Server 2019 Standard Templates for Proxmox. ###
    echo "Building Microsoft Windows Server 2019 Standard Templates for Proxmox..."   

    ### Initialize Packer ###
    echo "Initializing Hashicorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "2019"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-server-2019.proxmox-iso.windows-server-standard-dexp,windows-server-2019.proxmox-iso.windows-server-standard-core \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"
    
    ### Build complete ###
    echo "Build Complete." 
}

menu_option_3() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/server/2019
    echo -e "\nCONFIRM: Build Microsoft Windows Server 2019 Standard Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build Microsoft Windows Server 2019 Datacenter Templates for Proxmox. ###
    echo "Building Microsoft Windows Server 2019 Standard Templates for Proxmox..."   

    ### Initialize Packer ###
    echo "Initializing Hashicorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "2019"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-server-2019.proxmox-iso.windows-server-datacenter-dexp,windows-server-2019.proxmox-iso.windows-server-datacenter-core \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"
    
    ### Build complete ###
    echo "Build Complete." 
}

press_enter() {
  cd "$SCRIPT_PATH"
  echo -n "Press Enter to continue."
  read -r
  clear
}

info() {
  echo "Copyright 2023 Broadcom. All Rights Reserved."
  echo "License: BSD-2"
  echo ""
  echo "GitHub Repository: github.com/ralphbrynard/packer.proxmox.builds/"
  read -r
}

incorrect_selection() {
  echo "Invalid selection, please try again."
}

until [ "$selection" = "0" ]; do
    clear
    echo ""
    echo -e "$menu_banner"
    echo ""
    echo -e "$menu_message"
    echo ""
    echo "          Microsoft Windows:"
    echo ""
    echo "          1 - Windows Server 2019 - All"
    echo "          2 - Windows Server 2019 - Standard Only"
    echo "          3 - Windows Server 2019 - Datacenter Only"
    echo ""
    echo "          Other:"
    echo "              I - Information"
    echo "              Q - Quit"
    echo ""
    read -r selection
    echo ""
    case $selection in
        1 ) clear ; menu_option_1 ; press_enter ;;
        2 ) clear ; menu_option_2 ; press_enter ;;
        3 ) clear ; menu_option_3 ; press_enter ;;
        i|I ) clear ; info ; press_enter ;;
        q|Q ) clear ; exit ;;
        * ) clear ; incorrect_selection ; press_enter ;;
    esac
done