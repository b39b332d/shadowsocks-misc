#!/bin/bash
apt update
apt install shadowsocks-libev resolvconf ipset -y
echo '{
    "server":"$1",
    "mode":"tcp_and_udp",
    "server_port":8388,
    "local_port":1080,
    "password":"$2",
    "timeout":5,
    "method":"rc4-md5"
}' > /etc/shadowsocks-libev/client.json
systemctl stop shadowsocks-libev.service
systemctl disable shadowsocks-libev.service
mkdir '/etc/systemd/system/shadowsocks-libev-redir@client.service.d'

echo '''[Unit]
Requires=resolvconf.service 
After=network-online.target
[Service]
CapabilityBoundingSet=CAP_NET_RAW
AmbientCapabilities=CAP_NET_RAW
ExecStartPre=+/usr/bin/sh -c "/usr/bin/echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4\noptions timeout:2 attempts:2 rotate single-request-reopen' | /usr/sbin/resolvconf -a tun.ss"
ExecStartPost=/usr/bin/ss-nat -s $1 -l 1080 -I enp0s3 -u -o
ExecStartPost=/usr/sbin/iptables -t mangle -I PREROUTING -p udp -m udp --dport 53 -j TPROXY --on-port 1080 --on-ip 0.0.0.0 --tproxy-mark 0x1/0x1
ExecStartPost=/usr/sbin/iptables -t mangle -N SS_SPEC_LOCAL ; /usr/sbin/iptables -t mangle -A SS_SPEC_LOCAL -p udp ! --dport 53 -m set --match-set ss_spec_wan_ac dst -j RETURN ; /usr/sbin/iptables -t mangle -A SS_SPEC_LOCAL -p udp -j MARK --set-xmark 0x1/0xffffffff ; /usr/sbin/iptables -t mangle -A OUTPUT -p udp -j SS_SPEC_LOCAL  
ExecStopPost=-/usr/sbin/iptables -t mangle -D PREROUTING -p udp -m udp --dport 53 -j TPROXY --on-port 1080 --on-ip 0.0.0.0 --tproxy-mark 0x1/0x1
ExecStopPost=-/usr/bin/ss-nat -f
ExecStopPost=+/usr/sbin/resolvconf -d enp0s3''' > /etc/systemd/system/shadowsocks-libev-redir@IN.service.d/override.conf

echo xt_TPROXY >> /etc/modules
modprobe xt_TPROXY
systemctl enable shadowsocks-libev-redir@client.service
systemctl start shadowsocks-libev-redir@client.service
