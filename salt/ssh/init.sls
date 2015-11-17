ssh:
  pkg:
    - installed
  group:
    - present
    - name: ssh

/etc/ssh/sshd_config:
  file.managed:
    - user: root
    - group: root
    - mode: 644

    - source: salt://ssh/sshd_config
    - template: jinja
    - context:
        port: {{ pillar['remote_access']['ssh_port'] }}

    - require:
      - pkg: ssh
      - group: ssh

