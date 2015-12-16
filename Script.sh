#!/bin/bash
zenity --width=320 --height=200 --info --text "Script para instalação do oVirt-Engine ou oVirt-Hosted-Engine / Script to install the oVirt-Engine or oVirt-Hosted-Engine.
Versão 2.0			                              
Desenvolvido por: Wesley Morais de Oliveira"                  

menu()
{
	escolha=$(zenity --width=100 --height=200 --list --text "Selecione a opção desejada / Select the desired option:" --radiolist --column "" --column ""  FALSE "1-Instalar o oVirt-Engine" FALSE "2- Install the oVirt-Engine" FALSE "3- Instalar oVirt-Hosted-Engine")
		if [ "$escolha" == "1-Instalar o oVirt-Engine" ];
	then
		InstalaroVirtEngine
		elif [ "$escolha" == "2- Install the oVirt-Engine" ];
	then
		InstalaroVirtEngineEnglish
		elif [ "$escolha" == "3- Instalar oVirt-Hosted-Engine" ];
	then
		oVirtHostedEngine
		fi
} 
InstalaroVirtEngine()
{
	distro=$(zenity --width=100 --height=200 --list --text "Sua distro trabalha com qual gerenciador de pacotes?" --radiolist --column "" --column "" FALSE "1-YUM" FALSE "2-DNF")	
		if [ "$distro" == "1-YUM" ];
	then
		yum -y update | zenity --width=400 --height=100 --progress --pulsate --text "Atualizando o seu sistema. Ao terminar, esta janela será automaticamente fechada" --auto-close
		elif [ "$distro" == "2-DNF" ];
	then
		dnf -y update | zenity --width=400 --height=100 --progress --pulsate --text "Atualizando o seu sistema. Ao terminar, esta janela será automaticamente fechada" --auto-close
		fi  
		clear
		zenity --info --text "Definindo um IP fixo."
		placa=$(cd /etc/sysconfig/network-scripts/ && ls -1 | egrep "ifcfg-")  
		nic=$(zenity --width=600 --height=200 --entry --text "$placa" --entry-text "" --title "Escolha uma placa de rede? (informe apenas o nome da placa sem o comando ifcfg-)")
		if [ "$nic" == "eth0" ] || [ "$nic" == "eth1" ] || [ "$nic" == "eth2" ] || [ "$nic" == "eth3" ];
	then 
		eth
		elif [ "$nic" == "enp0s0" ] || [ "$nic" == "enp0s1" ] || [ "$nic" == "enp0s2" ] || [ "$nic" == "enp0s3" ];
	then
		enp
		elif [ "$nic" == "ens1" ] || [ "$nic" == "ens2" ] || [ "$nic" == "ens3" ] || [ "$nic" == "ens4" ];
	then
		ens
		fi
		FQDN=$(zenity --width=400 --height=200 --entry --text "" --entry-text "" --title "Dê um nome para associar ao IP deste computador?")
		echo "$IP  $FQDN" > /etc/hosts
		service network restart | zenity --width=400 --height=100 --progress --pulsate --text "Reiniciando o serviço de rede." --auto-close
		clear 
		if [ "$distro" == "1-YUM" ];
	then
		yum -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm | zenity --width=400 --height=100 --progress --pulsate --text "Baixando e instalando arquivo RPM contendo os endereços do repositório oVirt." --auto-close
		elif [ "$distro" == "2-DNF" ];
	then
		dnf -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm | zenity --width=400 --height=100 --progress --pulsate --text "Baixando e instalando arquivo RPM contendo os endereços do repositório oVirt." --auto-close
		fi
		clear
		if [ "$distro" == "1-YUM" ];
	then
		yum -y install ovirt-engine | zenity --width=400 --height=100 --progress --pulsate --text "Baixando oVirt-Engine" --auto-close
		elif [ "$distro" == "2-DNF" ];
	then
		dnf -y install ovirt-engine | zenity --width=400 --height=100 --progress --pulsate --text "Baixando oVirt-Engine" --auto-close
		fi
		clear
		zenity --info --text "Configurar o oVirt-Engine."
		engine-setup
		echo "Pressione <Enter> para continuar"
		read
		clear
		if [ "$distro" == "1-YUM" ];
	then
		yum -y install spice-xpi* | zenity --width=400 --height=100 --progress --pulsate --text "Baixando SPICE" --auto-close
		elif [ "$distro" == "2-DNF" ];
	then
		dnf -y install spice-xpi* | zenity --width=400 --height=100 --progress --pulsate --text "Baixando SPICE" --auto-close
		fi 
		clear
		browser=$(zenity --width=100 --height=200 --list --text "Escolha um browser:" --radiolist --column "" --column "" FALSE "1- Firefox" FALSE "2- Google-Chrome")
		if [ "$browser" == "1- Firefox" ];
	then
		firefox https://$FQDN:443/ovirt-engine
		elif [ "$browser" == "2- Google-Chrome" ];
	then
		google-chrome --user-data-dir https://$FQDN:443/ovirt-engine
		fi
		clear
		zenity --info --text "Instalação e configuração efetuada com Sucesso"
		exit
}
eth()
{
	IP=$(zenity --width=600 --height=200 --entry --text "Informe o IP a ser usado / Enter the IP to be used" --entry-text "" --title "Configuração da placa de rede ethX!!!")
		mascara_de_rede=$(zenity --width=600 --height=200 --entry --text "Informe a mascara de rede usada / Enter the network mask used" --entry-text "" --title "")
		IP_GATEWAY=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Gateway / Enter the Gateway IP" --entry-text "" --title "") 
		IP_DNS=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Servidor DNS Primário / Enter the Primary DNS Server IP" --entry-text "" --title "")
		IP_DNS2=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Servidor DNS Secundário / Enter the Secondary DNS Server IP" --entry-text "" --title "")		
		sed -i '/BOOTPROTO=dhcp/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "IPADDR=$IP" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "Mascara_de_Rede=$mascara_de_rede" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "GATEWAY=$IP_GATEWAY" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS1=$IP_DNS" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS2=$IP_DNS2" >> /etc/sysconfig/network-scripts/ifcfg-$nic
}
enp()
{ 
	IP=$(zenity --width=600 --height=200 --entry --text "Informe o IP a ser usado / Enter the IP to be used" --entry-text "" --title "Configuração da placa de rede enpXs0 !!!")
		mascara_de_rede=$(zenity --width=600 --height=200 --entry --text "Informe a mascara de rede usada / Enter the network mask used" --entry-text "" --title "")
		IP_GATEWAY=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Gateway / Enter the Gateway IP" --entry-text "" --title "") 
		IP_DNS=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Servidor DNS Primário / Enter the Primary DNS Server IP" --entry-text "" --title "")
		IP_DNS2=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Servidor DNS Secundário / Enter the Secondary DNS Server IP" --entry-text "" --title "")
		sed -i '/BOOTPROTO=dhcp/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "IPADDR=$IP" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "Mascara_de_Rede=$mascara_de_rede" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "GATEWAY=$IP_GATEWAY" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS1=$IP_DNS" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS2=$IP_DNS2" >> /etc/sysconfig/network-scripts/ifcfg-$nic
}
ens()
{
	IP=$(zenity --width=600 --height=200 --entry --text "Informe o IP a ser usado / Enter the IP to be used" --entry-text "" --title "Configuração da placa de rede ensX!!!")
		mascara_de_rede=$(zenity --width=600 --height=200 --entry --text "Informe a mascara de rede usada / Enter the network mask used" --entry-text "" --title "")
		IP_GATEWAY=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Gateway / Enter the Gateway IP" --entry-text "" --title "") 
		IP_DNS=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Servidor DNS Primário / Enter the Primary DNS Server IP" --entry-text "" --title "")
		IP_DNS2=$(zenity --width=600 --height=200 --entry --text "Informe o IP do Servidor DNS Secundário / Enter the Secondary DNS Server IP" --entry-text "" --title "")		
		sed -i '/BOOTPROTO="dhcp"/d' /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "IPADDR=$IP" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "Mascara_de_Rede=$mascara_de_rede" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "GATEWAY=$IP_GATEWAY" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS1=$IP_DNS" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
		echo "DNS2=$IP_DNS2" >> /etc/sysconfig/network-scripts/ifcfg-$nic
}
InstalaroVirtEngineEnglish()
{
	system=$(zenity --width=100 --height=200 --list --text "Which works with your distro package manager ?"           --radiolist --column "" --column "" FALSE "1-YUM" FALSE "2-DNF")
		if [ "$system" == "1-YUM" ];
	then
		yum -y update | zenity --width=400 --height=100 --progress --pulsate --text "Updating your system. When finished, this window will close automatically." --auto-close
		elif [ "$system" == "2-DNF" ];
	then
		dnf -y update | zenity --width=400 --height=100 --progress --pulsate --text "Updating your system. When finished, this window will close automatically." --auto-close
		fi
		clear
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
		fi 
		service network restart | zenity --width=400 --height=100 --progress --pulsate --text "Rebooting the network service." --auto-close
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
		browser=$(zenity --width=100 --height=200 --list --text "Escolha um browser:" --radiolist --column "" --column "" FALSE "1-Firefox" FALSE "2-Google-Chrome")
		if [ "$browser" == "1-Firefox" ];
	then
		firefox https://$FQDN:443/ovirt-engine
		elif [ "$browser" == "2-Google-Chrome" ];
	then
		google-chrome --user-data-dir https://$FQDN:443/ovirt-engine
		fi
		zenity --info --text "Made installation Successfully"
		exit
}
oVirtHostedEngine()
{
	Sistema=$(zenity --width=100 --height=200 --list --text "Sua distro trabalha com qual gerenciador de pacotes?" --radiolist --column "" --column "" FALSE "1-YUM" FALSE "2-DNF")
		if [ "$Sistema" == "1-YUM" ];
	then
		yum -y update | zenity --width=400 --height=100 --progress --pulsate --text "Atualizando o seu sistema. Ao terminar, esta janela será automaticamente fechada" --auto-close
		elif [ "$Sistema" == "2-DNF" ];
	then
		dnf -y update | zenity --width=400 --height=100 --progress --pulsate --text "Atualizando o seu sistema. Ao terminar, esta janela será automaticamente fechada" --auto-close
		fi 
		clear	
		zenity --info --text "Definindo um IP fixo."
		placa=$(cd /etc/sysconfig/network-scripts/ && ls -1 | egrep "ifcfg-")  
		nic=$(zenity --width=600 --height=200 --entry --text "$placa" --entry-text "" --title "Escolha uma placa de rede? (informe apenas o nome da placa sem o comando ifcfg-)")
		if [ "$nic" == "eth0" ] || [ "$nic" == "eth1" ] || [ "$nic" == "eth2" ]|| [ "$nic" == "eth3" ];
	then 
		eth
		elif [ "$nic" == "enp1s0" ] || [ "$nic" == "enp2s0" ] || [ "$nic" == "enp3s0" ] || [ "$nic" == "enp4s0" ];
	then
		enp
		elif [ "$nic" == "ens1" ] || [ "$nic" == "ens2" ] || [ "$nic" == "ens3" ] || [ "$nic" == "ens4" ];
	then
		ens
		fi
		clear
		service network restart | zenity --width=400 --height=100 --progress --pulsate --text "Reiniciando o serviço de rede." --auto-close
		clear
		FQDN_hosted_Engine=$(zenity --width=600 --height=200 --entry --text "" --entry-text "" --title "Informe um nome para associar ao IP da máquina onde está o oVirt-Hosted-Engine")
		IP_oVirt_Engine=$(zenity --width=500 --height=200 --entry --text "" --entry-text "" --title "Informe um IP a ser usado pela VM que conterá o oVirt-Engine")
		FQDN_Engine=$(zenity --width=600 --height=200 --entry --text "" --entry-text "" --title "Informe um nome para associar ao IP da VM onde estará o oVirt-Hosted-Engine")
		echo "$IP  $FQDN_hosted_Engine" >> /etc/hosts
		echo "$IP_oVirt_Engine  $FQDN_Engine" >> /etc/hosts
		clear
		echo "Os FQDNs são:"
		cat /etc/hosts 
		echo "Tecle <Enter> para continuar"
		read
		clear 
		zenity --info --text "Baixando e instalando arquivo RPM contendo os endereços do repositório oVirt."
		if [ "$Sistema" == "1-YUM" ];
	then
		yum -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm | zenity --width=400 --height=100 --progress --pulsate --text "Baixando e instalando arquivo RPM contendo os endereços do repositório oVirt." --auto-close
		elif [ "$Sistema" == "2-DNF" ];
	then
		dnf -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm | zenity --width=400 --height=100 --progress --pulsate --text "Baixando e instalando arquivo RPM contendo os endereços do repositório oVirt." --auto-close
		fi
		clear
		zenity --info --text "Baixando e instalando oVirt-Hosted-Engine"
		if [ "$Sistema" == "1-YUM" ];
	then
		yum -y install ovirt-hosted-engine-setup | zenity --width=400 --height=100 --progress --pulsate --text "Baixando e instalando oVirt-Hosted-Engine" --auto-close
		elif [ "$Sistema" == "2-DNF" ];
	then
		dnf -y install ovirt-hosted-engine-setup | zenity --width=400 --height=100 --progress --pulsate --text "Baixando e instalando oVirt-Hosted-Engine" --auto-close
		fi
		clear
		zenity --width=600 --height=200 --info --text "Levando em consideração de que já existe um servidor NFS ativo. Verifique se a pasta compartilhada está disponivel.
		Exemplo de comando para visualizar as pastas compatilhadas: showmount -e IP_do_Servidor
		Monte uma pasta compartilhada, esta será utilizada para obter o arquivo ISO. 
		Exemplo de comando para montar uma pasta compartilhada:
		mount -t nfs 10.0.0.56:/home/usuario  /mnt"
		echo "Tecle <Enter> para continuar"
		read
		caminho=$(zenity --width=700 --height=200 --entry --text "" --entry-text "" --title "Informe o caminho da pasta compartilhada?<IP_do_Servidor:/diretório_onde_a_pasta_está_localizada>") 
		pastalocal=$(zenity --width=500 --height=200 --entry --text "" --entry-text "" --title "Informe a pasta local onde o compartilhamento será montado?")
		mount -t nfs $caminho $pastalocal
		zenity --info --text "Arquivos compartilhados:" $pastalocal
		ls
		echo "Tecle <Enter> para continuar"
		read
		zenity --info --text "Alterando permissões do arquivo iso."
		permissao=$(zenity --width=500 --height=200 --entry --text "" --entry-text "" --title "Informe o nome do arquivo ISO para alterar suas permissões:")
		chmod 0755 $permissao.iso
		chown 36:36 $permissao.iso
		clear
		zenity --info --text "Configurar o oVirt-Hosted-Engine."
		echo "Tecle <Enter> para continuar"
		read
		hosted-engine --deploy
		echo "Tecle <Enter> para continuar"
		read
		zenity --info --text "Instalação e configuração efetuada com Sucesso"
		exit
}
menu
