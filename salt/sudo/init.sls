sudo:
  group:
    - present

/etc/sudoers:
  file.managed:
    - user: root
    - group: root
    - mode: 440

    - require:
      - group: sudo
