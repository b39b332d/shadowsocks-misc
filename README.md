# shadowsocks-misc
    Usage: ss-nat [-opc] [options]
           ss-nat -f

    Valid options are:

        -s <server_ip>          hostname (requires dig) or ip address of shadowsocks remote server
        -l <local_port>         port number of shadowsocks local server
        -S <server_ip>          hostname (requires dig) or ip address of shadowsocks remote UDP server
        -L <local_port>         port number of shadowsocks local UDP server
        -i <ip_list_file>       a file content is bypassed ip list
        -I <interface>          lan interface of nat, default: eth0
        -a <lan_ips>            lan ip of access control, need a prefix to
        define access control mode
        -b <wan_ips>            wan ip of will be bypassed
        -w <wan_ips>            wan ip of will be forwarded
        -c <filename>		read configuration from /etc/shadowsocks-libev/filename.json
        other options will overload this config file
        -e <extra_options>      extra options for iptables
        -o                      apply the rules to the OUTPUT chain
        -p                      apply the rules to the PREROUTING chain 
        -u                      enable udprelay mode, TPROXY is required
        -U                      enable udprelay mode, using different IP
        and ports for TCP and UDP
        -r                      change default dns server: 8.8.8.8 and 8.8.4.4
                                (requires resolvconf.service)
        -f                      flush the rules
        -h                      show this help message and exit
 
## e.g 
        ss-nat -f -I eth0 -r
        ss-nat -s $serverip -l $serverport -I eth0 -u -o -r
