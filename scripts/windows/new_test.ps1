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
        $msi_link = (Invoke-WebRequest -Uri $download_url -ErrorAction Stop).Content
        $htmlContent = "$msi_link"
        $regexPattern = '<a href="([^"]*qemu-ga-win-[^"]*/)">([^<]+)</a>\s+([0-9-]+\s[0-9:]+)'
        $matches = [regex]::Matches($htmlContent, $regexPattern)
        $entryList = @()

        foreach ($match in $matches) {
            $link = $match.Groups[1].Value
            $name = $match.Groups[2].Value
            $modified = [DateTime]::ParseExact($match.Groups[3].Value, "yyyy-MM-dd HH:mm", $null)
        
            $entryObject = [PSCustomObject]@{
                Link = $link
                Name = $name
                Modified = $modified
            }
        
            $entryList += $entryObject
        }

        # Sort the entries by descending last modified date
        $sortedEntries = $entryList | Sort-Object -Property Modified -Descending

        # Output the sorted entries
        if ($sortedEntries.Count -gt 0) {
            $firstLink = $sortedEntries[0].Link
            $msi_link = "$download_url$firstLink"+"qemu-ga-$arch.msi"
        } else {
            Write-Output "No sorted entries found."
        }

        if (-not [string]::IsNullOrEmpty($msi_link)) {
            $full_msi_link = "$msi_link"
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

<#
$htmlContent = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
 <head>
  <title>Index of /groups/virt/virtio-win/direct-downloads/archive-qemu-ga</title>
 </head>
 <body>
<!DOCTYPE html>
<html>

  <head>
    <title>Fedora People</title>
    <style type="text/css" media="screen">
      @import url("https://fedorapeople.org/userdefs/css/fedora.css");
      @import url("https://fedorapeople.org/userdefs/css/style.css");
    </style>
  </head>

  <body>

    <div id="wrapper">
      <div id="head">
        <h1><a href="https://fedoraproject.org/">Fedora</a></h1>
      </div>
      <div id="sidebar">
        <div class="nav">
          <h2>Navigation</h2>
          <ul>

            <li><strong><a href="/">Home</a></strong></li>

          </ul>
        </div>
      </div>
      <div id="content">
        <div id="pageLogin">
        </div>
<pre><img src="/icons/blank.gif" alt="Icon "> <a href="?C=N;O=D">Name</a>                                      <a href="?C=M;O=A">Last modified</a>      <a href="?C=S;O=A">Size</a>  <a href="?C=D;O=A">Description</a><hr><img src="/icons/back.gif" alt="[PARENTDIR]"> <a href="/groups/virt/virtio-win/direct-downloads/">Parent Directory</a>                                               -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-100.0.0.0-3.el7ev/">qemu-ga-win-100.0.0.0-3.el7ev/</a>            2019-02-04 17:47    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-101.1.0-1.el7ev/">qemu-ga-win-101.1.0-1.el7ev/</a>              2020-06-03 19:20    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-101.2.0-1.el7ev/">qemu-ga-win-101.2.0-1.el7ev/</a>              2020-11-24 02:37    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-102.10.0-0.el8_5/">qemu-ga-win-102.10.0-0.el8_5/</a>             2022-01-11 06:45    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-102.6.0-0.el8/">qemu-ga-win-102.6.0-0.el8/</a>                2021-07-26 06:00    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-102.7.0-0.el8/">qemu-ga-win-102.7.0-0.el8/</a>                2021-09-13 05:07    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-103.0.0-1.el9_0/">qemu-ga-win-103.0.0-1.el9_0/</a>              2022-04-14 08:02    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-104.0.2-1.el9/">qemu-ga-win-104.0.2-1.el9/</a>                2022-07-24 11:30    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-105.0.2-1.el9/">qemu-ga-win-105.0.2-1.el9/</a>                2023-01-09 09:28    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-106.0.1-1.el9/">qemu-ga-win-106.0.1-1.el9/</a>                2023-09-19 06:31    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.0-10/">qemu-ga-win-7.0-10/</a>                       2015-05-02 01:48    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.2.1-1/">qemu-ga-win-7.2.1-1/</a>                      2015-08-30 13:29    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.3.2-1/">qemu-ga-win-7.3.2-1/</a>                      2016-06-16 15:34    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.4.2-1/">qemu-ga-win-7.4.2-1/</a>                      2017-03-23 18:57    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.4.3-1/">qemu-ga-win-7.4.3-1/</a>                      2017-03-26 12:01    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.4.4-1/">qemu-ga-win-7.4.4-1/</a>                      2017-04-03 21:54    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.4.5-1/">qemu-ga-win-7.4.5-1/</a>                      2017-04-28 00:22    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.5.0-2.el7ev/">qemu-ga-win-7.5.0-2.el7ev/</a>                2018-04-05 23:53    -   
<img src="/icons/folder.gif" alt="[DIR]"> <a href="qemu-ga-win-7.6.2-2.el7ev/">qemu-ga-win-7.6.2-2.el7ev/</a>                2018-08-15 20:59    -   
<hr></pre>
      </div>
    </div>
    <div id="bottom">
      <div id="footer">
        <p class="disclaimer">
        The Fedora Project is maintained and driven by the community and sponsored by Red Hat.  This is a community maintained site.  Red Hat is not responsible for content.
        </p>
        <ul>
          <li class="first"><a href="http://fedoraproject.org/wiki/Legal">Legal</a></li>
          <li><a href="http://fedoraproject.org/wiki/Legal/TrademarkGuidelines">Trademark Guidelines</a></li>

        </ul>
      </div>
    </div>
  </body>
</html>
</body></html>
"@

$regexPattern = '<a href="([^"]*qemu-ga-win-[^"]*/)">([^<]+)</a>\s+([0-9-]+\s[0-9:]+)'
$matches = [regex]::Matches($htmlContent, $regexPattern)
$entryList = @()

foreach ($match in $matches) {
    $link = $match.Groups[1].Value
    $name = $match.Groups[2].Value
    $modified = [DateTime]::ParseExact($match.Groups[3].Value, "yyyy-MM-dd HH:mm", $null)

    $entryObject = [PSCustomObject]@{
        Link = $link
        Name = $name
        Modified = $modified
    }

    $entryList += $entryObject
}

# Sort the entries by descending last modified date
$sortedEntries = $entryList | Sort-Object -Property Modified -Descending

# Output the sorted entries
if ($sortedEntries.Count -gt 0) {
    $firstLink = $sortedEntries[0].Link
    Write-Output "First Link: $firstLink"
} else {
    Write-Output "No sorted entries found."
}
#>
