prerequisites:
  pkg.installed:
    - pkgs:
      - openvpn
      - easy-rsa

/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/server.conf

    - require:
      - pkg: prerequisites

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
