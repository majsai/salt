ssh:
  pkg:
    - installed
  group:
    - present
    - name: {{ pillar['core']['ssh_group'] }}

/etc/ssh/sshd_config:
  file.managed:
    - user: root
    - group: root
    - mode: 644

    - source: salt://ssh/sshd_config
    - template: jinja
    - context:
        port: {{ pillar['core']['ssh_port'] }}
        group: {{ pillar['core']['ssh_group'] }}

    - require:
      - pkg: ssh
      - group: ssh

