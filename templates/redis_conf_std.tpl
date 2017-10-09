# {{ ansible_managed }}
dir /var/lib/redis
port {{ redis_port }}
appendonly {{ redis_appendonly }}
appendfsync {{ redis_appendfsync}}
daemonize yes
pidfile /var/run/redis/redis-server-{{ redis_port }}.pid
loglevel {{ redis_loglevel }}
logfile "/var/log/redis/redis-server-{{ redis_port }}.log"
{% if redis_maxmemory is defined %}
maxmemory {{ redis_maxmemory }}
{% endif %}
{% if redis_maxmemory_policy is defined %}
maxmemory-policy {{ redis_maxmemory_policy }}
{% endif %}
{% if redis_save_config is defined %}
{% for save_line in redis_save_config -%}
save {{ save_line }}
{% endfor -%}
{% endif %}
dbfilename dump-{{ redis_port }}.rdb
appendfilename "appendonly-{{ redis_port }}.aof"
{% if redis_ms %}
min-slaves-to-write {{ redis_min_slaves_to_write }}
min-slaves-max-lag {{ redis_min_slaves_max_lag }}
{% endif %}
