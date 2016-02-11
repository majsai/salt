url="https://www.duckdns.org/update?domains={{ domain }}&token={{ token }}&ip=" 
result=$(echo url="$url" | curl -k -s -K -)

logger -t "duckdns" "{{ domain }}: $result"
