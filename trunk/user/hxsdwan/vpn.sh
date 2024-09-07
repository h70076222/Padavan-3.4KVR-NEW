#!/bin/sh

##编写：hong

sz="$@"
/usr/bin/vpn --stop
#关闭vnt的防火墙
iptables -D INPUT -i vnt-tun -j ACCEPT 2>/dev/null
iptables -D FORWARD -i vnt-tun -o vnt-tun -j ACCEPT 2>/dev/null
iptables -D FORWARD -i vnt-tun -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o vnt-tun -j MASQUERADE 2>/dev/null
killall vpn
killall -9 vpn
sleep 3
#清除vpn的虚拟网卡
ifconfig vnt-tun down && ip tuntap del vnt-tun mode tun

vpn="/usr/bin/vpn"

test ! -x "${vpn}" && chmod +x "${vpn}"
##判断文件有无执行权限，无赋予运行权限

 [ ! -d "/tmp/log/" ] &&  mkdir "/tmp/log/"

vpn_dirname=$(dirname "${vpn}") # 返回执行文件所在的目录



###############################


test -n "`pidof vpn`" && killall vpn

if [ -f "/etc/storage/post_wan_script.sh" ] ; then
boot="/etc/storage/post_wan_script.sh"

if [ -z "`cat $boot | grep -o '\串码'`" ] ; then
cat <<'EOF10'>> "$boot"
sleep 20 && /usr/bin/vpn.sh &
:<<'________'
VPN异地组网配置区
串码 abcde #组网串码 所有同一组网必须同一名 如：abcd
#以下改IP参数，虚似ip最后一位也要对应改，另一台也要改对网路由ip，虚拟ip
#如改本地192.168.20.1,路由名就改20 本虚拟ip改10.26.0.20
#远端改(在另一个路由改)ip 192.168.21.0/24,10.26.0.21
路由的名 20     #路由名字，不能和组网同名 如：20
对网路由IP 192.168.21.0/24,10.26.0.21   # 对端路由ip,对端路由的虚拟ip 192.168.21.0/24,10.26.0.21
本机IP 192.168.20.0/24  #本路由ip 如：192.168.1.0/24
本机虚拟IP 10.26.0.20  #本路由的虚拟ip 如： 10.26.0.11
________
EOF10

fi

fi
  
 [ -n "`cat $boot | grep -o '\串码'`" ] && port=$(cat $boot | grep '\串码' | awk -F '\串码' '{print $2}'|awk -F '#' '{print $1}' ) 
 [ -n "`cat $boot | grep -o '\-s'`" ] && white=$(cat $boot | grep '\-s' | awk -F '#' '{print $1}' )
 [ -n "`cat $boot | grep -o '\路由的名'`" ] && white_token=$(cat $boot | grep '\路由的名' | awk -F '\路由的名' '{print $2}'|awk -F '#' '{print $1}' )
 [ -n "`cat $boot | grep -o '\对网路由IP'`" ] && gateway=$(cat $boot | grep '\对网路由IP' | awk -F '\对网路由IP' '{print $2}'|awk -F '#' '{print $1}' )
 [ -n "`cat $boot | grep -o '\本机IP'`" ] && netmask=$(cat $boot | grep '\本机IP' | awk -F '\本机IP' '{print $2}'|awk -F '#' '{print $1}' )
 [ -n "`cat $boot | grep -o '\本机虚拟IP'`" ] && finger=$(cat $boot | grep '\本机虚拟IP' | awk -F '\本机虚拟IP' '{print $2}'|awk -F '#' '{print $1}' )

 
echo "./vpn -k $port $white -d $white_token -i $gateway -o $netmask --ip $finger &"

vpn_dirname=$(dirname ${vpn})

cd $vpn_dirname && ./vpn -k $port $white -d $white_token -i $gateway -o $netmask --ip $finger  &

sleep 3

if [ ! -z "`pidof vpn`" ] ; then
logger -t "异地组网" "启动成功"
#放行vnt防火墙
iptables -I INPUT -i vnt-tun -j ACCEPT
iptables -I FORWARD -i vnt-tun -o vnt-tun -j ACCEPT
iptables -I FORWARD -i vnt-tun -j ACCEPT
iptables -t nat -I POSTROUTING -o vnt-tun -j MASQUERADE
#开启arp
ifconfig vnt-tun arp
else
logger -t "异地组网" "启动失败"
fi
