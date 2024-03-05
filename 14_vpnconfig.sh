#!/bin/sh
printf "===========================================\n"
printf "환영합니다. openswan VPN 설정 도우미입니다.\n"
printf "===========================================\n"
printf "[1단계] MyCGW 고객 게이트웨이 주소(탄력적 IP 주소)를 입력하세요: "
read IP_ADDRESS_1
printf "[2단계] MyVGW Tunnel1 외부 IP 주소를 입력하세요: "
read IP_ADDRESS_2

cat <<EOF> /etc/ipsec.d/aws.conf
conn Tunnel1
  authby=secret
  auto=start
  left=%defaultroute
  leftid="$IP_ADDRESS_1"
  right="$IP_ADDRESS_2"
  type=tunnel
  ikelifetime=8h
  keylife=1h
  phase2alg=aes_gcm
  ike=aes256-sha2_256;dh14
  keyingtries=%forever
  keyexchange=ike
  leftsubnet=10.0.0.0/16
  rightsubnet=20.0.0.0/16
  dpddelay=10
  dpdtimeout=30
  dpdaction=restart_by_peer
EOF

cat <<EOF> /etc/ipsec.d/aws.secrets
$IP_ADDRESS_1 $IP_ADDRESS_2 : PSK "aws12345"
EOF

printf "======================================\n"
printf "====== VPN 서비스를 시작합니다. ======\n"
printf "======================================\n"

systemctl enable --now ipsec.service
systemctl restart ipsec.service
systemctl restart network

printf "cat /etc/ipsec.d/aws.conf 를 실시하여 설정된 내용을 확인하세요.\n"
printf "cat /etc/ipsec.d/aws.secrets 를 실시하여 Pre-Shared 키를 확인하세요.\n"
