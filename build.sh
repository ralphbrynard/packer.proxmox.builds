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

menu_option_4() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/server/2022
    echo -e "\nCONFIRM: Build all Windows Server 2022 Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build Windows Server 2022 Template for Proxmox. ###
    echo "Building all Windows Server 2022 Template for Proxmox..."

    ### Initialize Packer ###
    echo "Initializing Hashicorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "2022"
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

menu_option_5() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/server/2022
    echo -e "\nCONFIRM: Build Microsoft Windows Server 2022 Standard Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build Microsoft Windows Server 2022 Standard Templates for Proxmox. ###
    echo "Building Microsoft Windows Server 2022 Standard Templates for Proxmox..."

    ### Initialize Packer ###
    echo "Initializing Hashicorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "2022"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-server-2022.proxmox-iso.windows-server-standard-dexp,windows-server-2019.proxmox-iso.windows-server-standard-core \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build complete ###
    echo "Build Complete."
}

menu_option_6() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/server/2022
    echo -e "\nCONFIRM: Build Microsoft Windows Server 2022 Standard Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build Microsoft Windows Server 2022 Datacenter Templates for Proxmox. ###
    echo "Building Microsoft Windows Server 2022 Standard Templates for Proxmox..."

    ### Initialize Packer ###
    echo "Initializing Hashicorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "2022"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-server-2022.proxmox-iso.windows-server-datacenter-dexp,windows-server-2019.proxmox-iso.windows-server-datacenter-core \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build complete ###
    echo "Build Complete."
}

menu_option_7() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/desktop/11/
    echo -e "\nCONFIRM: Build all Windows 11 Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build all Windows 11 Templates for Proxmox. ###
    echo "Building all Windows 11 Templates for Proxmox..."

    ### Initialize HashiCorp Packer and required plugins. ###
    echo "Initializing HashiCorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "11"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build Complete. ###
    echo "Build Complete."
}

menu_option_8() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/desktop/11/
    echo -e "\nCONFIRM: Build a Windows 11 - Professional Only for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build all Windows 11 Templates for Proxmox. ###
    echo "Building a Windows 11 - Professional Only Template for Proxmox..."

    ### Initialize HashiCorp Packer and required plugins. ###
    echo "Initializing HashiCorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "11"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-11.proxmox-iso.windows-desktop-pro \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build Complete. ###
    echo "Build Complete."
}

menu_option_9() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/desktop/11/
    echo -e "\nCONFIRM: Build a Windows 11 - Enterprise Only for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build all Windows 11 Templates for Proxmox. ###
    echo "Building a Windows 11 - Enterprise Only Template for Proxmox..."

    ### Initialize HashiCorp Packer and required plugins. ###
    echo "Initializing HashiCorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "11"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-11.proxmox-iso.windows-desktop-ent \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build Complete. ###
    echo "Build Complete."
}

menu_option_10() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/desktop/10/
    echo -e "\nCONFIRM: Build all Windows 10 Templates for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build all Windows 10 Templates for Proxmox. ###
    echo "Building all Windows 10 Templates for Proxmox..."

    ### Initialize HashiCorp Packer and required plugins. ###
    echo "Initializing HashiCorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "10"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build Complete. ###
    echo "Build Complete."
}

menu_option_11() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/desktop/10/
    echo -e "\nCONFIRM: Build a Windows 10 - Professional Only for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build all Windows 10 Templates for Proxmox. ###
    echo "Building a Windows 10 - Professional Only Template for Proxmox..."

    ### Initialize HashiCorp Packer and required plugins. ###
    echo "Initializing HashiCorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "10"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-10.proxmox-iso.windows-desktop-pro \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build Complete. ###
    echo "Build Complete."
}

menu_option_12() {
    INPUT_PATH="$SCRIPT_PATH"/builds/windows/desktop/10/
    echo -e "\nCONFIRM: Build a Windows 10 - Enterprise Only for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build all Windows 10 Templates for Proxmox. ###
    echo "Building a Windows 10 - Enterprise Only Template for Proxmox..."

    ### Initialize HashiCorp Packer and required plugins. ###
    echo "Initializing HashiCorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "Starting the build...."
    echo "Running script to get required drivers for Windows build."
    ./utils/virtio-drivers.sh "10"
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        --only windows-10.proxmox-iso.windows-desktop-ent \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        "$INPUT_PATH"

    ### Build Complete. ###
    echo "Build Complete."
}

menu_option_13() {
    INPUT_PATH="$SCRIPT_PATH"/builds/linux/debian/12/
    echo -e "\nCONFIRM: Build a Debian 12 Template for Proxmox?"
    echo -e "\nContinue? (y/n)"
    read -r REPLY
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    ### Build Debian 12 Template for Proxmox. ###
    echo "Building a Debian 12 Template for Proxmox..."

    ### Initialize Hashicorp Packer and required plugins. ###
    echo "Initializing Hashicorp Packer and required plugins..."
    packer init "$INPUT_PATH"

    ### Start the build ###
    echo "packer build -force -on-error=ask $debug_option"
    packer build -force -on-error=ask $debug_option \
        -var-file="$CONFIG_PATH/proxmox.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/common.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/build.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/proxy.pkrvars.hcl" \
        -var-file="$CONFIG_PATH/ansible.pkrvars.hcl" \
        "$INPUT_PATH"

}

press_enter() {
  cd "$SCRIPT_PATH"
  echo -n "Press Enter to continue."
  read -r
  clear
}

info() {
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
    echo "              1 - Windows Server 2019 - All"
    echo "              2 - Windows Server 2019 - Standard Only"
    echo "              3 - Windows Server 2019 - Datacenter Only"
    echo "              4 - Windows Server 2022 - All"
    echo "              5 - Windows Server 2022 - Standard Only"
    echo "              6 - Windows Server 2022 - Datacenter Only"
    echo "              7 - Windows 11 - All"
    echo "              8 - Windows 11 - Professional Only"
    echo "              9 - Windows 11 - Enterprise Only"
    echo "              10 - Windows 10 - All"
    echo "              11 - Windows 10 - Professional Only"
    echo "              12 - Windows 10 - Enterprise Only"
    echo ""
    echo "          Linux Distribution:"
    echo ""
    echo "              13 - Debian 12"
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
        4 ) clear ; menu_option_4 ; press_enter ;;
        5 ) clear ; menu_option_5 ; press_enter ;;
        6 ) clear ; menu_option_6 ; press_enter ;;
        7 ) clear ; menu_option_7 ; press_enter ;;
        8 ) clear ; menu_option_8 ; press_enter ;;
        9 ) clear ; menu_option_9 ; press_enter ;;
        10 ) clear ; menu_option_10 ; press_enter ;;
        11 ) clear ; menu_option_11 ; press_enter ;;
        12 ) clear ; menu_option_12 ; press_enter ;;
        13 ) clear ; menu_option_13 ; press_enter ;;
        i|I ) clear ; info ; press_enter ;;
        q|Q ) clear ; exit ;;
        * ) clear ; incorrect_selection ; press_enter ;;
    esac
done
