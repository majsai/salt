include:
  - sudo

pleb:
  user.present:
    - shell: /bin/bash
    - home: /home/pleb

dev:
  user.present:
    - shell: /bin/bash
    - home: /home/dev
    - require:
      - group: sudo

proxy_user:
  user.present:
    - name: {{ pillar['core']['proxy_user'] }}
    - shell: /bin/sh
    - createhome: False
    - require:
      - group: ssh
