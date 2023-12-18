#!/bin/bash
output_dir="/tmp"
iso_file="$output_dir/virtio-win.iso"
build_version="$1"
repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"
windows_files="$(git rev-parse --show-toplevel 2>/dev/null)/windows_files"
base_directory="/mnt/iso"

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

    if [ "$build_version" == "2012" ]; then
        echo "Getting drivers for Windows Server 2012"
    elif [ "$build_version" == "2012R2" ]; then
        echo "Getting drivers for Windows Server 2012R2"
    elif [ "$build_version" == "2016" ]; then
        echo "Getting drivers for Windows Server 2016"
    elif [ "$build_version" == "2019" ]; then
        echo "Getting drivers for Windows Server 2019"
    elif [ "$build_version" == "2022" ]; then
       echo "Getting drivers for Windows Server 2022"
    elif [ "$build_version" == "2008" ]; then
        echo "Getting drivers for Windows Server 2008R2"
    elif [ "$build_version" == "10" ]; then
        echo "Getting drivers for Windows 10"
    elif [ "$build_version" == "11" ]; then
        echo "Getting drivers for Windows 11"
    elif [ "$build_version" == "8" ]; then
        echo "Getting drivers for Windows 8"
    elif [ "$build_version" == "8.1"]; then
        echo "Getting drivers for Windows 8.1"
    elif [ "$build_version" == "7"]; then
        echo "Getting drivers for Windows 7"
    fi
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
    echo "Downloading latest virtio-win.iso"
    curl -L -o "$iso_file" "$virtio_iso_url" --progress-bar
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
    local vioscsi="$base_directory/amd64/$driver_directory"
    local vioserial="$base_directory/vioserial/$driver_directory/amd64"
    local src="$base_directory$driver_directory"
    local dest="$windows_files"

    if [ ! -d "$vioscsi" ]; then
        echo "vioscsi driver directory not found in the mounted ISO."
        exit 1
    elif [ ! -d "$vioserial" ]; then
        echo "vioserial driver directory not found in the mounted ISO."
    fi

    if [ ! -d "$dest" ]; then
        echo "Destination directory '$dest' does not exist."
        mkdir -p "$dest"
    fi

    # Create the "drivers" subdirectory if it doesn't exist
    if [ ! -d "$dest/drivers" ]; then
        mkdir "$dest/drivers"
    fi

    echo "Copying driver files from '$vioscsi' to '$dest/drivers':"
    cp -rv "$vioscsi"/* "$dest/drivers"

    echo "Copying driver files from '$vioserial' to '$dest/drivers'"
    cp -rv "$vioserial"/*  "$dest/drivers"
}


# Unmount the ISO
function unmountISO {
    local mount_point="/mnt/iso"
    echo "Unmounting .ISO file"
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
    echo "Cleaning up"
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
