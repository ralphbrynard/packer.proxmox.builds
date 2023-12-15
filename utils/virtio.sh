#!/bin/bash

# Function to get the latest download link for the virtio.iso file
function virtioURL {
    # URL to fetch
    url="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/"

    # Use curl to fetch the webpage content and grep to find the "latest-virtio" link
    link=$(curl -Ls "$url" | grep -oP 'href="\K([^"]*latest-virtio[^"]*)')

    # Check if a link was found
    if [ -n "$link" ]; then
        # Construct the full URL
        full_url="$url$link"

        #echo "Latest Virtio link found: $full_url"

        # Fetch the redirected URL if any
        redirected_url=$(curl -Ls -o /dev/null -w %{url_effective} "$full_url")

        #echo "Redirected URL: $redirected_url"

        # Find the virtio-win.iso link in the redirected URL
        iso_link=$(curl -Ls "$redirected_url" | grep -oP 'href="\K([^"]*virtio-win\.iso[^"]*)')
        if [ -n "$iso_link" ]; then
            # Construct the full ISO link
            full_iso_link="$redirected_url$iso_link"
            echo "$full_iso_link"
        else
            echo "No virtio-win.iso link found."
        fi
    else
        echo "No latest Virtio link found."
    fi
}

function downloadISO {
    local show_progress=$1
    local virtio_iso_url=$(virtioURL)
    local output_dir="/tmp"

    # Debug: Print the ISO URL being passed to curl
    #echo "Debug: Downloading from URL: $virtio_iso_url" >&2

    # Create the output directory if it doesn't exist
    if [[ ! -d "$output_dir" ]]; then
        mkdir -p "$output_dir"
    fi

    local iso_file="$output_dir/virtio-win.iso"

    if [[ -f "$iso_file" ]]; then
        # If the ISO file already exists, use it for computing SHA256
        local sha256=$(sha256sum "$iso_file" | awk '{ print $1 }')
        #echo "Using existing ISO file: $iso_file"
        #echo "SHA256: $sha256"
        echo $sha256
    else
        # If the ISO file doesn't exist, download it
        if [[ "$show_progress" == "yes" ]]; then
            curl -L -o "$iso_file" "$virtio_iso_url" --progress-bar
        else
            curl -Ls -o "$iso_file" "$virtio_iso_url"
        fi

        local sha256=$(sha256sum "$iso_file" | awk '{ print $1 }')
        echo "Downloaded ISO file: $iso_file"
        echo "SHA256: $sha256"
    fi
}

function main {
    local show_progress="no"
    local action=""

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --virtio-url)
                action="virtioURL"
                ;;
            --compute-sha256)
                action="downloadISO"
                ;;
            --show-progress)
                show_progress="yes"
                ;;
            *)
                echo "Usage: $0 [--show-progress] (--virtio-url | --compute-sha256)"
                exit 1
                ;;
        esac
        shift
    done

    if [[ "$action" == "downloadISO" ]]; then
        downloadISO "$show_progress"
    elif [[ "$action" == "virtioURL" ]]; then
        virtioURL
    else
        echo "No valid action specified."
        exit 1
    fi
}

# Call main with all the passed arguments
main "$@"