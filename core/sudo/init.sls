sudo:
  group:
    - present

/etc/sudoers:
  file.managed:
    - user: root
    - group: root
    - mode: 440

    - source: salt://core/sudo/sudoers

    - require:
      - group: sudo
