#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  sudoCmd="sudo"
else
  sudoCmd=""
fi


if [[ -f /etc/redhat-release ]]; then
  release="centos"
  systemPackage="yum"
elif cat /etc/issue | grep -Eqi "debian"; then
  release="debian"
  systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
  release="ubuntu"
  systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
  systemPackage="yum"
elif cat /proc/version | grep -Eqi "debian"; then
  release="debian"
  systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "ubuntu"; then
  release="ubuntu"
  systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
  systemPackage="yum"
fi

if [ ${systemPackage} == "yum" ]; then
    ${sudoCmd} ${systemPackage} install wget -y -q
else
    ${sudoCmd} ${systemPackage} install wget -y -qq
fi

curl -s https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf >./accelerated-domains.china.conf

curl -s https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf >./apple.china.conf

curl -s https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf >./google.china.conf

curl -s https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf >./bogus-nxdomain.china.conf

cat accelerated-domains.china.conf apple.china.conf google.china.conf  >> combine-domains.china.conf
