#!/bin/sh


/usr/bin/vpn --stop
#关闭vnt的防火墙
iptables -D INPUT -i hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -o hxsdwan -j ACCEPT 2>/dev/null
iptables -D FORWARD -i hxsdwan -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o hxsdwan -j MASQUERADE 2>/dev/null
killall vpn
killall -9 vpn
sleep 4
#清除vnt的虚拟网卡
ifconfig hxsdwan down && ip tuntap del hxsdwan mode tun
#启动命令 更多命令去官方查看
wireguard_key=$(nvram get wireguard_key) 
echo $wireguard_key
wireguard_naen=$(nvram get wireguard_naen) 
echo $wireguard_naen
wireguard_inip=$(nvram get wireguard_inip) 
echo $wireguard_inip
wireguard_outip=$(nvram get wireguard_outip) 
echo $wireguard_outip
wireguard_ttre=$(nvram get wireguard_ttre) 
echo $wireguard_ttre
lan_ipaddr=$(nvram get lan_ipaddr) 
echo $lan_ipaddr

/usr/bin/vpn -k $wireguard_key $wireguard_ttre -d $wireguard_naen --nic hxsdwan -i $wireguard_inip -o $lan_ipaddr/24 --ip $wireguard_outip &

sleep 4
if [ ! -z "`pidof vpn`" ] ; then
logger -t "异地组网" "启动成功"
#放行vpn防火墙
iptables -I INPUT -i hxsdwan -j ACCEPT
iptables -I FORWARD -i hxsdwan -o hxsdwan -j ACCEPT
iptables -I FORWARD -i hxsdwan -j ACCEPT
iptables -t nat -I POSTROUTING -o hxsdwan -j MASQUERADE
#开启arp
ifconfig hxsdwan arp
else
logger -t "异地组网" "启动失败"
fi
