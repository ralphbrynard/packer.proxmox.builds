param(
    [string] $OSVERSION=$env:OSVERSION
)

$uri="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win.iso"
$file="$env:TEMP\virtio-win.iso"
$arch=$env:PROCESSOR_ARCHITECTURE

Write-Host "Downloading Virtio ISO..."
Start-BitsTransfer -Source $uri -Destination $file

Write-Host "Mounting virtio-win.iso..."
Mount-DiskImage "$file"

Set-Location F:

Write-Host "Installing Drivers..."
if ($arch -eq "AMD64"){
   $packageName="virtio-win-gt-x64.msi"
   Start-Process msiexec "/i F:\$packageName /qr /norestart" -Wait
}else{
   $packageName="virtio-win-gt-x64.msi"
   Start-Process msiexec "/i F:\$packageName /qr /norestart" -Wait
}

Write-Host "Installing Qemu Guest Agent..."
if ($arch -eq "AMD64"){
    $packageName="qemu-ga-x86_64.msi"
    Start-Process msiexec "/i F:\guest-agent\$packageName /qr /norestart"
}else{
    $packageName="qemu-ga-i386.msi"
    Start-Process msiexec "/i F:\guest-agent\$packageName /qr /norestart" -Wait 
}

$Running=$false
$iRepeat=0

while (-not $Running -and $iRepeat -lt 5){
    Start-Sleep -s 2
    Write-Output "Checking Qemu Guest Agent Service..."
    $Service = Get-Service "QEMU-GA" -ErrorAction SilentlyContinue
    $ServiceStatus = $Service.Status

    if ($ServiceStatus -ne "Running"){
        $iRepeat++
    }else{
        $Running=$true
        Write-Output "Qemu Guest Agent Service is in a running state."
    }
}

if (-not $Running){
    Write-Output "Uninstalling Qemu Guest Agent..."
    wmic product where "Name like '%QEMU%'" call uninstall /nointeractive

    Write-Output "Reinstalling Qemu Guest Agent..."
    Start-Process msiexec "/i .\guest-agent\$packageName /qr /norestart" -Wait

    Write-Output "Checking Qemu Guest Agent Status..."
    $iRepeat = 0
    while (-not $Running -and $iRepeat -lt 5){
        Start-Sleep -s 2
        $Service = Get-Service "QEMU-GA" -ErrorAction SilentlyContinue
        $ServiceStatus = $Service.Status

        if ($ServiceStatus -ne "Running"){
            $iRepeat++
        }else{
            $Running = $true
            Write-Output "Qemu Guest Agent is in a running state."
        }
    }    

    if (-not $Running){
        Write-Error "Qemu Guest Agent installation was unsuccessful."
    }
}
