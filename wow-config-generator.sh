#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # no-color

# Ask config tag
echo -e "${YELLOW}---------- Wow Config Generator ----------${NC}"
read -p "? Define a tag for your config:" CONFIG_TAG

# Detect CPU architecture
case "$(uname -m)" in
	x86_64 | x64 | amd64 )
	    cpu=amd64
	;;
	i386 | i686 )
        cpu=386
	;;
	armv8 | armv8l | arm64 | aarch64 )
        cpu=arm64
	;;
	armv7l )
        cpu=arm
	;;
	* )
	echo -e "The current architecture $(uname -m), is ${RED}not supported${NC}"
	exit
	;;
esac

download_warpendpoint() {
    if [[ ! -f "$PREFIX/bin/warpendpoint" ]]; then
	clear
        echo -e "${YELLOW}- Downloading warpendpoint program...${NC}"
        
	if [[ -n $cpu ]]; then
            curl -L -o warpendpoint -# --retry 2 https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/$cpu > /dev/null 2>&1
            cp warpendpoint $PREFIX/bin > /dev/null 2>&1
            chmod +x $PREFIX/bin/warpendpoint > /dev/null 2>&1
        fi

	echo -e "${BLUE}- Done!${NC}"
    fi
}

generate_random_ipv4s(){
	n=0
	ip_count=100
	echo -e "${YELLOW}- Generating ${ip_count} random IPv4s...${NC}"
	while true
	do
		ip_list[$n]="162.159.192.$(($RANDOM%256))"
		n=$[$n+1]
		if [ $n -ge $ip_count ]
		then
			break
		fi
		ip_list[$n]="162.159.193.$(($RANDOM%256))"
		n=$[$n+1]
		if [ $n -ge $ip_count ]
		then
			break
		fi
		ip_list[$n]="162.159.195.$(($RANDOM%256))"
		n=$[$n+1]
		if [ $n -ge $ip_count ]
		then
			break
		fi
		ip_list[$n]="188.114.96.$(($RANDOM%256))"
		n=$[$n+1]
		if [ $n -ge $ip_count ]
		then
			break
		fi
		ip_list[$n]="188.114.97.$(($RANDOM%256))"
		n=$[$n+1]
		if [ $n -ge $ip_count ]
		then
			break
		fi
		ip_list[$n]="188.114.98.$(($RANDOM%256))"
		n=$[$n+1]
		if [ $n -ge $ip_count ]
		then
			break
		fi
		ip_list[$n]="188.114.99.$(($RANDOM%256))"
		n=$[$n+1]
		if [ $n -ge $ip_count ]
		then
			break
		fi
	done
	while true
	do
		if [ $(echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $ip_count ]
		then
			break
		else
			ip_list[$n]="162.159.192.$(($RANDOM%256))"
			n=$[$n+1]
		fi
		if [ $(echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $ip_count ]
		then
			break
		else
			ip_list[$n]="162.159.193.$(($RANDOM%256))"
			n=$[$n+1]
		fi
		if [ $(echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $ip_count ]
		then
			break
		else
			ip_list[$n]="162.159.195.$(($RANDOM%256))"
			n=$[$n+1]
		fi
		if [ $(echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $ip_count ]
		then
			break
		else
			ip_list[$n]="188.114.96.$(($RANDOM%256))"
			n=$[$n+1]
		fi
		if [ $(echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $ip_count ]
		then
			break
		else
			ip_list[$n]="188.114.97.$(($RANDOM%256))"
			n=$[$n+1]
		fi
		if [ $(echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $ip_count ]
		then
			break
		else
			ip_list[$n]="188.114.98.$(($RANDOM%256))"
			n=$[$n+1]
		fi
		if [ $(echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $ip_count ]
		then
			break
		else
			ip_list[$n]="188.114.99.$(($RANDOM%256))"
			n=$[$n+1]
		fi
	done
	
	echo -e "${BLUE}- Done!${NC}"
}

get_first_cloudflare_account(){
	echo -e "${YELLOW}- Getting first free Cloudflare account...${NC}"

	output=$(curl -sL "https://api.zeroteam.top/warp?format=sing-box" | grep -Eo --color=never '"2606:4700:[0-9a-f:]+/128"|"private_key":"[0-9a-zA-Z\/+]+="|"reserved":\[[0-9]+(,[0-9]+){2}\]')
	first_public_key=$(echo "$output" | grep -oP '("2606:4700:[0-9a-f:]+/128")' | tr -d '"')
	first_private_key=$(echo "$output" | grep -oP '("private_key":"[0-9a-zA-Z\/+]+=")' | cut -d':' -f2 | tr -d '"')
	first_reserved=$(echo "$output" | grep -oP '(\[[0-9]+(,[0-9]+){2}\])' | tr -d '"' | sed 's/"reserved"://')
}
get_second_cloudflare_account(){
	echo -e "${YELLOW}- Getting second free Cloudflare account...${NC}"
	
	output=$(curl -sL "https://api.zeroteam.top/warp?format=sing-box" | grep -Eo --color=never '"2606:4700:[0-9a-f:]+/128"|"private_key":"[0-9a-zA-Z\/+]+="|"reserved":\[[0-9]+(,[0-9]+){2}\]')
	second_public_key=$(echo "$output" | grep -oP '("2606:4700:[0-9a-f:]+/128")' | tr -d '"')
	second_private_key=$(echo "$output" | grep -oP '("private_key":"[0-9a-zA-Z\/+]+=")' | cut -d':' -f2 | tr -d '"')
	second_reserved=$(echo "$output" | grep -oP '(\[[0-9]+(,[0-9]+){2}\])' | tr -d '"' | sed 's/"reserved"://')

	echo -e "${BLUE}- Done!"
}

manage_result() {
    # Generate result file
    echo "$1" > result.json

    # Use xclip to copy into clipboard
    if command -v xclip > /dev/null 2>&1; then
	echo "$1" | xclip -sel clip
    elif command -v pkg > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo pkg update > /dev/null 2>&1
	sudo pkg install xclip > /dev/null 2>&1
    elif command -v apt > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo apt update > /dev/null 2>&1
	sudo apt install -y xclip > /dev/null 2>&1
    elif command -v dnf > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo dnf install -y xclip > /dev/null 2>&1
    elif command -v yum > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo yum install -y xclip > /dev/null 2>&1
    elif command -v zypper > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo zypper install -y xclip > /dev/null 2>&1
    elif command -v pacman > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo pacman -S --noconfirm xclip > /dev/null 2>&1
    elif command -v emerge > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo emerge --ask x11-misc/xclip > /dev/null 2>&1
    elif command -v apk > /dev/null 2>&1; then
	echo -e "${YELLOW}- Installing xclip...${NC}"
	sudo apk add xclip > /dev/null 2>&1
    fi

    if command -v xclip > /dev/null 2>&1; then
	echo "$1" | xclip -sel clip
	echo -e "${GREEN}Config copied to your clipboard successfully.\nYou can also use generated json file at: ./result.json${NC}"
    else
	echo -e "${RED}Failed to copy into clipboard.${NC}\nUse generated file at: ./result.json"
    fi
}

generate_config() {
    echo -e "${YELLOW}- Generating Config..."

    echo ${ip_list[@]} | sed -e 's/ /\n/g' | sort -u > ip.txt
    ulimit -n 102400
    chmod +x warpendpoint > /dev/null 2>&1

    if command -v warpendpoint &>/dev/null; then
        warpendpoint > /dev/null 2>&1
    else
        ./warpendpoint > /dev/null 2>&1
    fi
    
    found_set=$(cat result.csv | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+" | head -n 1)
	ipv4="${found_set%:*}"
	port="${found_set##*:}"
    
	get_first_cloudflare_account
	get_second_cloudflare_account

	template='{
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
			"'$CONFIG_TAG'",
			"'$CONFIG_TAG'"
		],
		"default": "auto"
		},
		{
		"type": "urltest",
		"tag": "auto",
		"outbounds": [
			"'$CONFIG_TAG'",
			"'$CONFIG_TAG'"
		],
		"url": "http://cp.cloudflare.com/",
		"interval": "10m0s"
		},
		{
		"type": "wireguard",
		"tag": "'$CONFIG_TAG'",
		"local_address": [
			"172.16.0.2/32",
			"'$first_public_key'"
		],
		"private_key": "'$first_private_key'",
		"server": "'$ipv4'",
		"server_port": '$port',
		"peer_public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
		"reserved": '$first_reserved',
		"mtu": 1280,
		"fake_packets": "5-10"
		},
		{
		"type": "wireguard",
		"tag": "'$CONFIG_TAG'",
		"detour": "'$CONFIG_TAG'",
		"local_address": [
			"172.16.0.2/32",
			"'$second_public_key'"
		],
		"private_key": "'$second_private_key'",
		"server": "'$ipv4'",
		"server_port": '$port',
		"peer_public_key": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
		"reserved": '$second_reserved',
		"mtu": 1280,
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
	}'

    manage_result "$template"

    rm warpendpoint > /dev/null 2>&1
    rm -rf ip.txt
    rm -rf result.csv
    exit
}

download_warpendpoint
generate_random_ipv4s
generate_config
