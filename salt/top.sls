base:
  '*':
    - core
    - vim

    {% if pillar['duckdns'] is defined %}
    - duckdns
    {% endif %}
