#!/bin/bash
zenity --width=320 --height=200 --info --text "Script to install the oVirt-Engine.
Version 2.0			                              
Developed by: Wesley Morais de Oliveira"                  
menu()
{
zenity --info --text "Setting a fixed IP."
		board=$(cd /etc/sysconfig/network-scripts/ && ls -1 | egrep "ifcfg-")  
		nic=$(zenity --width=600 --height=200 --entry --text "$board" --entry-text "" --title "Choose a network card? (just enter the name of the card without the ifcfg- command)")
		if [ "$nic" == "eth0" ] || [ "$nic" == "eth1" ] || [ "$nic" == "eth2" ]|| [ "$nic" == "eth3" ];
	then 
		eth
		elif [ "$nic" == "enp1s0" ] || [ "$nic" == "enp2s0" ] || [ "$nic" == "enp3s0" ] || [ "$nic" == "enp4s0" ];
	then
		enp
		elif [ "$nic" == "ens1" ] || [ "$nic" == "ens2" ] || [ "$nic" == "ens3" ] || [ "$nic" == "ens4" ];
	then
		ens
	else
		exit	
		fi 
		service network restart | zenity --width=400 --height=100 --progress --pulsate --text "Rebooting the network service." --auto-close
		clear
	system=$(zenity --width=100 --height=200 --list --text "Which works with your distro package manager ?"           --radiolist --column "" --column "" FALSE "1-YUM" FALSE "2-DNF")
		if [ "$system" == "1-YUM" ];
	then
		yum -y update | zenity --width=400 --height=100 --progress --pulsate --text "Updating your system. When finished, this window will close automatically." --auto-close
		elif [ "$system" == "2-DNF" ];
	then
		dnf -y update | zenity --width=400 --height=100 --progress --pulsate --text "Updating your system. When finished, this window will close automatically." --auto-close
		fi
		clear
		echo Set the FQDN.
		FQDN=$(zenity --width=400 --height=200 --entry --text "" --entry-text "" --title "Name to be used as FQDN ?") 
		echo "$IP      $FQDN" > /etc/hosts
		clear 
		if [ "$system" == "1-YUM" ];
	then
		yum -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm | zenity --width=400 --height=100 --progress --pulsate --text "Download and install the RPM file containing the addresses of oVirt repository." --auto-close
		elif [ "$system" == "2-DNF" ];
	then
		dnf -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm | zenity --width=400 --height=100 --progress --pulsate --text "Download and install the RPM file containing the addresses of oVirt repository." --auto-close
		fi
		clear  
		if [ "$system" == "1-YUM" ];
	then
		yum -y install ovirt-engine | zenity --width=400 --height=100 --progress --pulsate --text "Download and install the oVirt-Engine" --auto-close
		elif [ "$system" == "2-DNF" ];
	then
		dnf -y install ovirt-engine | zenity --width=400 --height=100 --progress --pulsate --text "Download and install the oVirt-Engine" --auto-close
		fi
		clear
		zenity --info --text "Setting the oVirt-Engine."
		engine-setup
		clear 
		if [ "$system" == "1-YUM" ];
	then
		yum -y install spice-xpi* | zenity --width=400 --height=100 --progress --pulsate --text "Downloading SPICE" --auto-close
		elif [ "$system" == "2-DNF" ];
	then
		dnf -y install spice-xpi* | zenity --width=400 --height=100 --progress --pulsate --text "Downloading SPICE" --auto-close
		fi
		clear
		firefox https://$FQDN:443/ovirt-engine
		zenity --info --text "Made installation Successfully"
		exit
}

eth()
{
	IP=$(zenity --width=600 --height=200 --entry --text "Enter the IP to be used" --entry-text "" --title "Configuring the network card ethX!!!")
		netmask=$(zenity --width=600 --height=200 --entry --text "Enter the network mask used" --entry-text "" --title "")
		IP_GATEWAY=$(zenity --width=600 --height=200 --entry --text "Enter the Gateway IP" --entry-text "" --title "") 
		IP_DNS=$(zenity --width=600 --height=200 --entry --text "Enter the Primary DNS Server IP" --entry-text "" --title "")
		IP_DNS2=$(zenity --width=600 --height=200 --entry --text "Enter the Secondary DNS Server IP" --entry-text "" --title "")		
		sed -i '/BOOTPROTO=DHCP/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		sed -i '/BOOTPROTO=dhcp/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "IPADDR=$IP" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "NetMask=$netmask" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "GATEWAY=$IP_GATEWAY" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS1=$IP_DNS" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS2=$IP_DNS2" >> /etc/sysconfig/network-scripts/ifcfg-$nic
}
enp()
{ 
	IP=$(zenity --width=600 --height=200 --entry --text "Enter the IP to be used" --entry-text "" --title "Configuring the network card enpXs0 !!!")
		netmask=$(zenity --width=600 --height=200 --entry --text "Enter the network mask used" --entry-text "" --title "")
		IP_GATEWAY=$(zenity --width=600 --height=200 --entry --text "Enter the Gateway IP" --entry-text "" --title "") 
		IP_DNS=$(zenity --width=600 --height=200 --entry --text "Enter the Primary DNS Server IP" --entry-text "" --title "")
		IP_DNS2=$(zenity --width=600 --height=200 --entry --text "Enter the Secondary DNS Server IP" --entry-text "" --title "")
		sed -i '/BOOTPROTO=DHCP/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		sed -i '/BOOTPROTO=dhcp/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "IPADDR=$IP" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "NetMask=$netmask" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "GATEWAY=$IP_GATEWAY" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS1=$IP_DNS" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS2=$IP_DNS2" >> /etc/sysconfig/network-scripts/ifcfg-$nic
}
ens()
{
	IP=$(zenity --width=600 --height=200 --entry --text "Enter the IP to be used" --entry-text "" --title "Configuring the network card ensX!!!")
		netmask=$(zenity --width=600 --height=200 --entry --text "Enter the network mask used" --entry-text "" --title "")
		IP_GATEWAY=$(zenity --width=600 --height=200 --entry --text "Enter the Gateway IP" --entry-text "" --title "") 
		IP_DNS=$(zenity --width=600 --height=200 --entry --text "Enter the Primary DNS Server IP" --entry-text "" --title "")
		IP_DNS2=$(zenity --width=600 --height=200 --entry --text "Enter the Secondary DNS Server IP" --entry-text "" --title "")		
		sed -i '/BOOTPROTO=DHCP/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		sed -i '/BOOTPROTO=dhcp/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "IPADDR=$IP" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "NetMask=$netmask" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "GATEWAY=$IP_GATEWAY" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS1=$IP_DNS" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS2=$IP_DNS2" >> /etc/sysconfig/network-scripts/ifcfg-$nic
}
menu
