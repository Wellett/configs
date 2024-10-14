# a place to keep local aliases

alias lsd='ls -t ~/Downloads | head'
alias find-gateway-ip='ssh ubuntu@collab-vpn.sensorfact.tools "sudo cat /var/log/openvpn/status.log"'

alias wakeupYorick='wakeonlan -i $(dig +short williamellett.tplinkdns.com) -p 60900 14:85:7f:45:8c:ab'
