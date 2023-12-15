# Download the appropriate QEMU GA MSI installer based on architecture.
$url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/"
$uri = [System.Uri]$url
$rootUrl = $uri.GetLeftPart([System.UriPartial]::Authority)
try {
    $response = Invoke-WebRequest -Uri $url -MaximumRedirection 0 -ErrorAction Stop
    $link = [regex]::Match($response.Content, 'href="([^"]*latest-qemu-ga[^"]*)"').Groups[1].Value
    if (-not [string]::IsNullOrEmpty($link)) {
        $full_url = "$url$link"
        $response = (Invoke-WebRequest -Uri $full_url -MaximumRedirection 1 -ErrorAction Stop)
        $redirected_url = [regex]::Match($response.Content, 'href="([^"]*qemu-ga[^"]*)"').Groups[1].Value
        $download_url = "$rootUrl$redirected_url"
        $arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else { "i386" }
        $msi_link = [regex]::Match((Invoke-WebRequest -Uri $download_url -ErrorAction Stop).Content, "href=`"([^`"]*qemu-ga-$arch\.msi[^`"]*)`"").Groups[1].Value
        if (-not [string]::IsNullOrEmpty($msi_link)) {
            $full_msi_link = "$redirected_url$msi_link"
            Write-Output "Downloading QEMU GA MSI Installer..."
            Invoke-WebRequest -Uri $full_msi_link -OutFile "qemu-ga-$arch.msi"
            Write-Output "Download completed: qemu-ga-$arch.msi"

            # Run the downloaded MSI installer.
            Write-Output "Running QEMU GA MSI Installer..."
            $logFilePath="$env:TEMP/quemu-ga-installation.log"
            Start-Process -Wait -FilePath "msiexec.exe" -ArgumentList "/i", "qemu-ga-$arch.msi", "/L*v", $logFilePath
            Write-Output "Installation of QEMU GA MSI completed."
        }
        else {
            Write-Output "No qemu-ga-$arch.msi link found."
        }
    }
    else {
        Write-Output "No latest QEMU GA link found."
    }
}
catch {
    Write-Output "Error: $($_.Exception.Message)"
}