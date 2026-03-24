#/bin/bash
ip address add 10.1.0.10/24 dev eth1
ip route add 10.2.0.0/24 via 10.1.0.1 dev eth1