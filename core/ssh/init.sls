# pillar variables
# --
# ssh:
#   port: 22

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

    - source: salt://core/ssh/sshd_config
    - template: jinja
    - context:
        port: {{ pillar['ssh']['port'] }}

    - require:
      - pkg: ssh
      - group: ssh

