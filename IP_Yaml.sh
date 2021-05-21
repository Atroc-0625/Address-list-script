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

wget -N --no-check-certificate -O ./US_Cidr.yaml http://www.iwik.org/ipcountry/US.cidr

wget -N --no-check-certificate -O ./JP_Cidr.yaml http://www.iwik.org/ipcountry/JP.cidr

wget -N --no-check-certificate -O ./TW_Cidr.yaml http://www.iwik.org/ipcountry/TW.cidr

US_filename="US_Cidr.yaml"

JP_filename="JP_Cidr.yaml"

TW_filename="TW_Cidr.yaml"

#开始处理 cn_filename 内容
#方法1
sed -i '/^#.*/d' ${US_filename}
sed -i 's/\(.*\)/  - '\1'/g' ${US_filename}

sed -i '/^#.*/d' ${JP_filename}
sed -i 's/\(.*\)/  - '\1'/g' ${JP_filename}

sed -i '/^#.*/d' ${TW_filename}
sed -i 's/\(.*\)/  - '\1'/g' ${TW_filename}
#方法2
#1、每行行首增加字符串"add address="
#sed -i 's/^/add address=&/g' ${cn_filename}

#2、每行行尾增加字符串" list=CN"
#sed -i 's/$/& list=CN/g' ${cn_filename}

#3、在文件第1行前插入新行"/log info "Loading CN ipv4 address list""
sed -i '1 ipayload:' ${US_filename}

sed -i '1 ipayload:' ${JP_filename}

sed -i '1 ipayload:' ${TW_filename}

#4、在文件第2行前插入新行"/ip firewall address-list remove [/ip firewall address-list find list=CN]"
#sed -i '2 i/ip firewall address-list remove [/ip firewall address-list find list=Scaners]' ${cn_filename}

#5、在文件第3行前插入新行"/ip firewall address-list"
#sed -i '3 i/ip firewall address-list' ${cn_filename}
