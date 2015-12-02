#! /bin/bash
echo Script para instalação do oVirt-Engine ou oVirt-Hosted-Engine / Script to install the oVirt-Engine or oVirt-Hosted-Engine.
echo Versão 1.3                               
echo Desenvolvido por: Wesley Morais de Oliveira                   
date
menu()
{
escolha="-1"
while [ $escolha -ne 0 ];
do
echo "========================================================="
echo "Selecione a opção desejada / Select the desired option:"  
echo "1- Instalar o oVirt-Engine"
echo "2- Install the oVirt-Engine"
echo "3- Instalar oVirt-Hosted-Engine"
echo "========================================================="
echo -n "Opção/option: "
read escolha
if [ "$escolha" -eq "1" ];
then
InstalaroVirtEngine
elif [ "$escolha" -eq "2" ];
then
InstalaroVirtEngineEnglish
elif [ "$escolha" -eq "3" ];
then
oVirtHostedEngine
fi
done
} 
InstalaroVirtEngine()
{
echo ATUALIZAR O SISTEMA:
echo Sua distro trabalha com qual gerenciador de pacotes?
echo 1- YUM
echo 2- DNF
echo ==================================
read sistema
if [ "$sistema" -eq "1" ];
then
su -c "yum -y update"
elif [ "$sistema" -eq "2" ];
then
su -c "dnf -y update"
fi 
clear
echo Definindo um IP fixo.
echo "escolha uma placa de rede: ( Coloque apenas o nome da placa, sem o ifcfg- )"
cd /etc/sysconfig/network-scripts/ 
ls -1 | egrep "ifcfg"
echo =============================
read nic
if [ "$nic" == "eth0" ];
then 
eth
elif [ "$nic" == "enp4s0" ];
then
enp
fi
echo Dê um nome para associar ao IP deste computador?
read FQDN
echo "$IP  $FQDN" > /etc/hosts
cat /etc/hosts
echo "Tecle <Enter> para continuar"
read
echo Reiniciando o serviço de rede.
su -c "service network restart"
clear
echo Baixar e instalar o arquivo RPM contendo os endereços "do" repositório oVirt.
echo "Tecle <Enter> para continuar"
read
if [ "$sistema" -eq "1" ];
then
su -c "yum -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm"
elif [ "$sistema" -eq "2" ];
then
su -c "dnf -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm"
fi
clear
echo Baixar e instalar o oVirt-Engine
echo "Tecle <Enter> para continuar"
read
if [ "$sistema" -eq "1" ];
then
su -c "yum -y install ovirt-engine"
elif [ "$sistema" -eq "2" ];
then
su -c "dnf -y install ovirt-engine"
fi
clear
echo Configurar o oVirt-Engine.
echo "Tecle <Enter> para continuar"
read
su -c "engine-setup"
echo "tecle <Enter> para continuar"
read 
clear
echo Baixando SPICE
if [ "$sistema" -eq "1" ];
then
su -c "yum -y install spice-xpi*"
elif [ "$sistema" -eq "2" ];
then
su -c "dnf -y install spice-xpi*"
fi 
clear
echo Escolha um browser:
echo 1- firefox
echo 2- google-chrome
echo =====================
read browser
if [ "$browser" -eq "1" ];
then
firefox https://$FQDN:443/ovirt-engine
elif [ "$browser" -eq "2" ];
then
google-chrome --user-data-dir https://$FQDN:443/ovirt-engine
fi
clear
echo Instalação e configuração efetuada com Sucesso
exit
}
eth()
{
echo Configuração da placa de rede eth!!!
echo Informe o IP a ser usado / Enter the IP to be used
read IP
echo Informe a mascara de rede usada / Enter the network mask used
read mascara_de_rede
echo Informe o IP do Gateway / Enter the Gateway IP 
read IP_GATEWAY
echo Informe o IP do Servidor DNS Primário / Enter the Primary DNS Server IP
read IP_DNS
echo Informe o IP do Servidor DNS Secundário / Enter the Secondary DNS Server IP
read IP_DNS2
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
echo Configuração da placa de rede enp!!!
echo Informe o IP a ser usado / Enter the IP to be used
read IP
echo Informe a mascara de rede usada / Enter the network mask used
read mascara_de_rede
echo Informe o IP do Gateway / Enter the Gateway IP 
read IP_GATEWAY
echo Informe o IP do Servidor DNS Primário / Enter the Primary DNS Server IP
read IP_DNS
echo Informe o IP do Servidor DNS Secundário / Enter the Secondary DNS Server IP
read IP_DNS2
sed -i '/BOOTPROTO=dhcp/d' /etc/sysconfig/network-scripts/ifcfg-$nic
echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-$nic
echo "IPADDR=$IP" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
echo "Mascara_de_Rede=$mascara_de_rede" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
echo "GATEWAY=$IP_GATEWAY" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
echo "DNS1=$IP_DNS" >>  /etc/sysconfig/network-scripts/ifcfg-$nic
echo "DNS2=$IP_DNS2" >> /etc/sysconfig/network-scripts/ifcfg-$nic
}
InstalaroVirtEngineEnglish()
{
echo UPDATE THE SYSTEM ":"
echo Your system works with which package manager YUM or DNF?
echo 1- YUM
echo 2- DNF
echo ==================================
read system
if [ "$system" -eq "1" ];
then
su -c "yum -y update"
elif [ "$system" -eq "2" ];
then
su -c "dnf -y update"
fi
clear
echo Setting a fixed IP.
echo Choose a network card: "( put only the NIC name, without the command ifcfg-)"
cd /etc/sysconfig/network-scripts/
ls -1 | egrep "ifcfg"
echo =============================
read nic
if [ "$nic" == "eth0" ];
then 
eth
elif [ "$nic" == "enp4s0" ];
then
enp
fi
echo Rebooting the network service.
su -c "service network restart"
clear
echo Set the FQDN.
echo name to be used as FQDN ?
read FQDN
echo "$IP      $FQDN" > /etc/hosts
clear
echo Download and install the RPM "file" containing the addresses of oVirt repository.
if [ "$system" -eq "1" ];
then
su -c "yum -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm"
elif [ "$system" -eq "2" ];
then
su -c "dnf -y install http://plain.resources.ovirt.org/pub/yum-repo/ovirt-release36.rpm"
fi
clear
echo Download and install the oVirt-Engine
if [ "$system" -eq "1" ];
then
su -c "yum -y install ovirt-engine"
elif [ "$system" -eq "2" ];
then
su -c "dnf -y install ovirt-engine"
fi
clear
echo Setting the oVirt-Engine.
su -c "engine-setup"
clear
echo Downloading SPICE
if [ "$system" -eq "1" ];
then
su -c "yum -y install spice-xpi*"
elif [ "$system" -eq "2" ];
then
su -c "dnf -y install spice-xpi*"
fi
clear
echo choice a browser:
echo 1- Firefox
echo 2- google-chrome
echo ==================
read browser
if [ "$browser" -eq "1" ];
then
firefox https://$FQDN:443/ovirt-engine
elif [ "$browser" -eq "2" ];
then
google-chrome --user-data-dir https://$FQDN:443/ovirt-engine
fi
echo Made installation Successfully
exit
}
menu
