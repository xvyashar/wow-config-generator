# Ask config tag
Write-Host ":::::::::::::::::::::::::::::::::::::::::::" -ForegroundColor Yellow
Write-Host ".......... Wow Config Generator ..........." -ForegroundColor Yellow
Write-Host "............ Author: xvyashar ............." -ForegroundColor Yellow
Write-Host "... Github: https://github.com/xvyashar ..." -ForegroundColor Yellow
Write-Host ":::::::::::::::::::::::::::::::::::::::::::" -ForegroundColor Yellow

$ConfigTag = Read-Host "? Define a tag for your config"

function Extract-Zip {
    Param ($Path, $To)

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($Path, $To)
}

function Download-Warp-Scanner {
    Clear-Host
    Write-Host "- Downloading warpendpoint program..." -ForegroundColor Yellow

    # Download the file
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/win_warp_ip.zip" -OutFile ".\win_warp_ip.zip"
    
    # Extract the file
    Extract-Zip -Path ".\win_warp_ip.zip" -To ".\temp"

    # Remove junk files
    Remove-Item ".\win_warp_ip.zip"
    Remove-Item ".\temp\win_scanner.bat"

    Write-Host "- Done!" -ForegroundColor Blue
}

function Generate-Random-IPv4s {
    $i = 0
    $IpCount = 100
    Write-Host "- Generating $IpCount random IPv4s..." -ForegroundColor Yellow
    $IpList = @()

    while ($true) {
        $IpList += "162.159.192." + (Get-Random -Maximum 256)
        $i++
        if ($i -ge $IpCount) { break }

        $IpList += "162.159.193." + (Get-Random -Maximum 256)
        $i++
        if ($i -ge $IpCount) { break }

        $IpList += "162.159.195." + (Get-Random -Maximum 256)
        $i++
        if ($i -ge $IpCount) { break }

        $IpList += "188.114.96." + (Get-Random -Maximum 256)
        $i++
        if ($i -ge $IpCount) { break }

        $IpList += "188.114.97." + (Get-Random -Maximum 256)
        $i++
        if ($i -ge $IpCount) { break }

        $IpList += "188.114.98." + (Get-Random -Maximum 256)
        $i++
        if ($i -ge $IpCount) { break }

        $IpList += "188.114.99." + (Get-Random -Maximum 256)
        $i++
        if ($i -ge $IpCount) { break }
    }

    while ($true) {
        $UniqueIps = $IpList | Sort-Object | Get-Unique
        if ($UniqueIps.Count -ge $IpCount) { break }

        $IpList += "162.159.192." + (Get-Random -Maximum 256)
        $i++
        $UniqueIps = $IpList | Sort-Object | Get-Unique
        if ($UniqueIps.Count -ge $IpCount) { break }

        $IpList += "162.159.193." + (Get-Random -Maximum 256)
        $i++
        $UniqueIps = $IpList | Sort-Object | Get-Unique
        if ($UniqueIps.Count -ge $IpCount) { break }

        $IpList += "162.159.195." + (Get-Random -Maximum 256)
        $i++
        $UniqueIps = $IpList | Sort-Object | Get-Unique
        if ($UniqueIps.Count -ge $IpCount) { break }

        $IpList += "188.114.96." + (Get-Random -Maximum 256)
        $i++
        $UniqueIps = $IpList | Sort-Object | Get-Unique
        if ($UniqueIps.Count -ge $IpCount) { break }

        $IpList += "188.114.97." + (Get-Random -Maximum 256)
        $i++
        $UniqueIps = $IpList | Sort-Object | Get-Unique
        if ($UniqueIps.Count -ge $IpCount) { break }

        $IpList += "188.114.98." + (Get-Random -Maximum 256)
        $i++
        $UniqueIps = $IpList | Sort-Object | Get-Unique
        if ($UniqueIps.Count -ge $IpCount) { break }

        $IpList += "188.114.99." + (Get-Random -Maximum 256)
        $i++
    }

    # Move ipv4s to file that warp scanner can read it
    $IpList -join "`r`n" | Select-Object -Unique | Out-File -FilePath ".\ip.txt" -Encoding utf8
    
    Write-Host "- Done!" -ForegroundColor Blue
}

function Get-First-Cloudflare-Account {
    Write-Host "- Getting first free Cloudflare account..." -ForegroundColor Yellow

    $Output = Invoke-RestMethod -Uri "https://api.zeroteam.top/warp?format=sing-box"

    $global:FirstV4Address = $Output.local_address | Where-Object { $_ -match "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+" }
    $global:FirstV6Address = $Output.local_address | Where-Object { $_ -match "2606:4700:[0-9a-f:]+" }
    $global:FirstPrivateKey = $Output.private_key
    $global:FirstPeerPublicKey = $Output.peer_public_key
    $ReservedArray = $Output.reserved -split ' '
    $global:FirstReserved = "[" + ($ReservedArray -join ', ') + "]"
    $global:FirstMtu = $Output.mtu

    Write-Host "$FirstV6Address --> $FirstPrivateKey" -ForegroundColor Cyan
}
function Get-Second-Cloudflare-Account {
    Write-Host "- Getting second free Cloudflare account..." -ForegroundColor Yellow

    $Output = Invoke-RestMethod -Uri "https://api.zeroteam.top/warp?format=sing-box"

    $global:SecondV4Address = $Output.local_address | Where-Object { $_ -match "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+" }
    $global:SecondV6Address = $Output.local_address | Where-Object { $_ -match "2606:4700:[0-9a-f:]+" }
    $global:SecondPrivateKey = $Output.private_key
    $global:SecondPeerPublicKey = $Output.peer_public_key
    $ReservedArray = $Output.reserved -split ' '
    $global:SecondReserved = "[" + ($ReservedArray -join ', ') + "]"
    $global:SecondMtu = $Output.mtu

    Write-Host "$SecondV6Address --> $SecondPrivateKey" -ForegroundColor Cyan
    Write-Host "- Done!" -ForegroundColor Blue
}

function Read-Result {
    Param ($Path)
    
    # Import the CSV file
    $Data = Import-Csv -Path $Path -Header 'IP:PORT', 'LOSS', 'DELAY'

    # Filter out rows where DELAY is 'timeout ms' or the header
    $Data = $Data | Where-Object { $_.DELAY -ne 'timeout ms' -and $_.DELAY -ne 'DELAY' }

    # Convert DELAY to integer for comparison
    $Data | ForEach-Object { 
        if ([int32]::TryParse($_.DELAY.TrimEnd(' ms'), [ref]$null)) {
            $_.DELAY = [int]$_.DELAY.TrimEnd(' ms')
        } else {
            $_.DELAY = [int]::MaxValue
        }
    }

    # Get the row with the lowest DELAY
    $LowestDelay = $Data | Sort-Object { $_.DELAY } | Select-Object -First 1
    
    # Extract the IP and port
    $IpPort = $LowestDelay.'IP:PORT' -split ':'
    $global:Server = $IpPort[0]
    $global:Port = $IpPort[1]
    $global:Ping = $LowestDelay.DELAY
}

function Manage-Result {
    Param ($JsonString)

    # Save to file
    $JsonString | Out-File -FilePath ".\result.json" -Encoding utf8

    # Copy to clipboard
    $JsonString | Set-Clipboard

    Write-Host "Config copied to your clipboard successfully.`nYou can also use generated json file at: .\result.json" -ForegroundColor Green
}

function Genrate-Config {
    Write-Host "- Generating config..." -ForegroundColor Yellow

    # Run warp scanner
    & ".\temp\warp.exe" 2>&1 > $null

    Read-Result .\result.csv

    Write-Host "- Server ping: ${Server}: ${Port} -> ${Ping}" -ForegroundColor Cyan

    Get-First-Cloudflare-Account
    Get-Second-Cloudflare-Account

    $JsonConfig = @"
    {
        "route": {
            "geoip": {
                "path": "geo-assets\\sagernet-sing-geoip-geoip.db"
            },
            "geosite": {
                "path": "geo-assets\\sagernet-sing-geosite-geosite.db"
            },
            "rules": [
                {
                    "inbound": "dns-in",
                    "outbound": "dns-out"
                },
                {
                    "port": 53,
                    "outbound": "dns-out"
                },
                {
                    "clash_mode": "Direct",
                    "outbound": "direct"
                },
                {
                    "clash_mode": "Global",
                    "outbound": "select"
                }
            ],
            "auto_detect_interface": true,
            "override_android_vpn": true
        },
        "outbounds": [
            {
                "type": "selector",
                "tag": "select",
                "outbounds": [
                    "auto",
                    "[1] - $ConfigTag",
                    "[2] - $ConfigTag"
                ],
                "default": "auto"
            },
            {
                "type": "urltest",
                "tag": "auto",
                "outbounds": [
                    "[1] - $ConfigTag",
                    "[2] - $ConfigTag"
                ],
                "url": "http://cp.cloudflare.com/",
                "interval": "10m0s"
            },
            {
                "type": "wireguard",
                "tag": "[1] - $ConfigTag",
                "local_address": [
                    "$FirstV4Address",
                    "$FirstV6Address"
                ],
                "private_key": "$FirstPrivateKey",
                "server": "$Server",
                "server_port": $Port,
                "peer_public_key": "$FirstPeerPublicKey",
                "reserved": $FirstReserved,
                "mtu": $FirstMtu,
                "fake_packets": "5-10"
            },
            {
                "type": "wireguard",
                "tag": "[2] - $ConfigTag",
                "detour": "[1] - $ConfigTag",
                "local_address": [
                    "$SecondV4Address",
                    "$SecondV6Address"
                ],
                "private_key": "$SecondPrivateKey",
                "server": "$Server",
                "server_port": $Port,
                "peer_public_key": "$SecondPeerPublicKey",
                "reserved": $SecondReserved,
                "mtu": $SecondMtu,
                "fake_packets": "5-10"
            },
            {
                "type": "dns",
                "tag": "dns-out"
            },
            {
                "type": "direct",
                "tag": "direct"
            },
            {
                "type": "direct",
                "tag": "bypass"
            },
            {
                "type": "block",
                "tag": "block"
            }
        ]  
    }
"@

    Write-Host '- Done!' -ForegroundColor Blue

    Manage-Result -JsonString $JsonConfig

    Remove-Item ".\temp" -Recurse
    Remove-Item ".\ip.txt"
    Remove-Item ".\result.csv"
}

# Main Execution
Download-Warp-Scanner
Generate-Random-IPv4s
Genrate-Config