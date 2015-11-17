root:
  user:
    - present
    {% if pillar['remote_access']['enable_root_with_key'] %}
    - groups:
      - ssh

    - require:
      - group: ssh
    {% endif %}

proxy_user:
  user.present:
    - name: {{ pillar['users']['proxy'] }}
    - createhome: False
    - groups:
      - ssh

    - require:
      - group: ssh
