sudo:
  group:
    - name: {{ pillar['core']['sudo_group'] }}
    - present

/etc/sudoers:
  file.managed:
    - user: root
    - group: root
    - mode: 440

    - source: salt://sudo/sudoers
    - template: jinja
    - context:
        group: {{ pillar['core']['sudo_group'] }}

    - require:
      - group: sudo
