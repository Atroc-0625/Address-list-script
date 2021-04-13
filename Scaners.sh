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

rm -rf ./Scaners.rsc

wget -N --no-check-certificate -O ./Scaners.txt https://cache-1.oss-cn-beijing.aliyuncs.com/file/scaners.rsc

cat Scaners.txt |awk  '{print $2}'|awk -F '=' '{print $2}'|grep -v '^$' >>Scaners.rsc

rm -rf ./Scaners.txt

cn_filename="Scaners.rsc"

#开始处理 cn_filename 内容
#方法1
sed -i '/^#.*/d' ${cn_filename}
sed -i 's/\(.*\)/add address=\1 list=Scaners/g' ${cn_filename}
#方法2
#1、每行行首增加字符串"add address="
#sed -i 's/^/add address=&/g' ${cn_filename}

#2、每行行尾增加字符串" list=CN"
#sed -i 's/$/& list=CN/g' ${cn_filename}

#3、在文件第1行前插入新行"/log info "Loading CN ipv4 address list""
sed -i '1 i/log info "Loading Scaners ipv4 address list"' ${cn_filename}

#4、在文件第2行前插入新行"/ip firewall address-list remove [/ip firewall address-list find list=CN]"
sed -i '2 i/ip firewall address-list remove [/ip firewall address-list find list=Scaners]' ${cn_filename}

#5、在文件第3行前插入新行"/ip firewall address-list"
sed -i '3 i/ip firewall address-list' ${cn_filename}
