openvpn:
  pkg:
    - installed
      
/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/server.conf

    - require:
      - pkg: openvpn

portforward:
  cmd.run:
    - name: echo 1 > /proc/sys/net/ipv4/ip_forward
    - unless: cat /proc/sys/net/ipv4/ip_forward | grep "1"

    - require_in:
      - pkg: firewall.install

/etc/sysctl.conf:
  file.managed:
    - source: salt://openvpn/sysctl.conf

firewall.install:
  pkg.installed:
    - pkgs:
      - ufw

firewall.config.ssh:
  cmd.run:
    - name: ufw allow ssh
    - unless: ufw status | grep -P "^22[ ]+ALLOW[ ]+Anywhere$"

    - require:
      - pkg: firewall.install

firewall.config.openvpn:
  cmd.run:
    - name: ufw allow 1194/udp
    - unless: ufw status | grep -P "^1194/udp[ ]+ALLOW[ ]+Anywhere$"

    - require:
      - pkg: firewall.install

firewall.enable:
  cmd.run:
    - name: ufw enable
    - unless: ufw status | grep -Pv "Status. inactive"

    - require:
      - cmd: firewall.config.ssh
      - cmd: firewall.config.openvpn

#FAJLOK LETOLTESE ES BEMASOLASA

/etc/openvpn/dh2048.pem:
  file.managed:
    - source: {{ pillar['openvpn']['cert']['pem'] }}
    - source_hash: {{ pillar['openvpn']['cert']['pem'] }}.hash
    
    - require:
      - pkg: openvpn
     
/etc/openvpn/server.key:
  file.managed:
    - source: {{ pillar['openvpn']['cert']['key'] }}
    - source_hash: {{ pillar['openvpn']['cert']['key'] }}.hash
    
    - require:
      - pkg: openvpn

/etc/openvpn/server.crt:
  file.managed:
    - source: {{ pillar['openvpn']['cert']['crt'] }}
    - source_hash: {{ pillar['openvpn']['cert']['crt'] }}.hash
    
    - require:
      - pkg: openvpn

/etc/openvpn/ca.crt:
  file.managed:
    - source: {{ pillar['openvpn']['cert']['ca'] }}
    - source_hash: {{ pillar['openvpn']['cert']['ca'] }}.hash
    
    - require:
      - pkg: openvpn

vpn.start:
  cmd.run:
    - name: systemctl openvpn start
    - unless:  systemctl is-active openvpn | grep -P "active"

    - require:
      - file: /etc/openvpn/server.crt
      - file: /etc/openvpn/server.key
      - file: /etc/openvpn/dh2048.pem
      - file: /etc/openvpn/ca.crt
