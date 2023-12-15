#!/bin/bash
output_dir="/tmp"
iso_file="$output_dir/virtio-win.iso"
build_version="$1"
packer_cache="$PACKER_CACHE_DIR"
base_directory="/mnt/iso/amd64/"

# Driver lookup based on build version.
function driverLookup {
    case "$build_version" in
        "2012")
            driver_directory="2k12"
            ;;
        "2012R2")
            driver_directory="2k12R2"
            ;;
        "2016")
            driver_directory="2k16"
            ;;
        "2019")
            driver_directory="2k19"
            ;;
        "2022")
            driver_directory="2k22"
            ;;
        "2008")
            driver_directory="2k8R2"
            ;;
        "10")
            driver_directory="w10"
            ;;
        "11")
            driver_directory="w11"
            ;;
        "8")
            driver_directory="w8"
            ;;
        "8.1")
            driver_directory="w8.1"
            ;;
        "7")
            driver_directory="w7"
            ;;
        *)
            echo "Variable value not found or mapped to a directory."
            exit 1
            ;;
    esac
}

# Function to get the latest download link for the virtio.iso file
function virtioURL {
    url="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/"
    link=$(curl -Ls "$url" | grep -oP 'href="\K([^"]*latest-virtio[^"]*)')

    if [ -n "$link" ]; then
        full_url="$url$link"
        redirected_url=$(curl -Ls -o /dev/null -w %{url_effective} "$full_url")
        iso_link=$(curl -Ls "$redirected_url" | grep -oP 'href="\K([^"]*virtio-win\.iso[^"]*)')
        if [ -n "$iso_link" ]; then
            full_iso_link="$redirected_url$iso_link"
            echo "$full_iso_link"
        else
            echo "No virtio-win.iso link found."
        fi
    else
        echo "No latest Virtio link found."
    fi
}

# Download the latest ISO file.
function downloadISO {
    local virtio_iso_url=$(virtioURL)

    curl -L -o "$iso_file" "$virtio_iso_url"
}

# Mount the ISO
function mountISO {
    local mount_point="/mnt/iso"

    if sudo mount | grep -q "$iso_file on $mount_point"; then
        echo "ISO file is already mounted at $mount_point"
    else
        sudo mount -o loop "$iso_file" "$mount_point"
        if [ $? -eq 0 ]; then
            echo "ISO file successfully mounted at $mount_point."
        else
            echo "Failed to mount ISO file at $mount_point."
            exit 1
        fi
    fi
}

# Copy driver files to a destination directory, including a "drivers" subdirectory
function copyDrivers {
    local src="$base_directory$driver_directory"
    local dest="$packer_cache"

    if [ ! -d "$src" ]; then
        echo "Driver directory '$src' not found in the mounted ISO."
        exit 1
    fi

    if [ ! -d "$dest" ]; then
        echo "Destination directory '$dest' does not exist."
        mkdir -p "$dest"
    fi

    # Create the "drivers" subdirectory if it doesn't exist
    if [ ! -d "$dest/drivers" ]; then
        mkdir "$dest/drivers"
    fi

    echo "Copying driver files from '$src' to '$dest/drivers':"
    cp -rv "$src"/* "$dest/drivers"
}


# Unmount the ISO
function unmountISO {
    local mount_point="/mnt/iso"

    if sudo mount | grep -q "$iso_file on $mount_point"; then
        sudo umount "$mount_point"
        if [ $? -eq 0 ]; then
            echo "ISO file successfully unmounted from $mount_point."
        else
            echo "Failed to unmount ISO file from $mount_point."
        fi
    fi
}

# Remove the ISO file
function removeISO {
    if [ -f "$iso_file" ]; then
        rm -f "$iso_file"
        echo "Removed ISO file: $iso_file"
    else
        echo "ISO file not found: $iso_file"
    fi
}

# Main function
function main {
    build_version="$1"

    if [ -z "$build_version" ]; then
        echo "Usage: $0 <build_version>"
        exit 1
    fi

    driverLookup "$build_version"
    downloadISO
    mountISO
    copyDrivers
    unmountISO
    removeISO
}

main "$1"
