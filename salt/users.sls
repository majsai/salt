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
    - name: {{ pillar['remote_access']['proxy_user'] }}
    - createhome: False
    - require:
      - group: ssh

root:
  user:
    - present
    {% if pillar['remote_access']['enable_root_with_key'] %}
    - require:
      - group: ssh
    {% endif %}
