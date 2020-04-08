#!/bin/bash
apt update
apt install shadowsocks-libev -y
mv /etc/shadowsocks-libev/config.json /etc/shadowsocks-libev/config.json.orig
echo '{
    "server":"0.0.0.0",
    "server_port":8388,
    "password":"$1",
    "mode": "tcp_and_udp",
    "nameserver":"8.8.8.8",
    "timeout":60,
    "method":"rc4-md5",
    "fast_open":true
}' > /etc/shadowsocks-libev/config.json
systemctl restart shadowsocks-libev.service

