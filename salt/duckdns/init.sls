{% set duckdns_script = '/usr/local/bin/duckdns.sh' %}

include:
  - users.task_runner

duckdns:
  pkg.installed:
    - pkgs:
      - curl

  file.managed:
    - name: {{ duckdns_script }}
    - user: root
    - group: root
    - mode: 755

    - source: salt://duckdns/duckdns.sh
    - template: jinja
    - context:
        token: {{ pillar['duckdns']['token'] }}
        domain: {{ pillar['duckdns']['domain'] }}

  cron.present:
    - name: /bin/bash {{ duckdns_script }}
    - user: {{ pillar['users']['task_runner'] }}
    
    - minute: '*/5'
