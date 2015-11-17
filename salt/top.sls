base:
  '*':
    - core

    {% if pillar['duckdns'] is defined %}
    - duckdns
    {% endif %}
