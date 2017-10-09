# {{ ansible_managed }}
bind 0.0.0.0
dir /var/lib/redis
port {{ redis_master_port }}
cluster-enabled yes
cluster-config-file nodes-master-{{ redis_master_port }}.conf
cluster-node-timeout {{ redis_cluster_node_timeout }}
appendonly {{ redis_appendonly }}
appendfsync {{ redis_appendfsync}}
daemonize yes
pidfile /var/run/redis/redis-server-{{ redis_master_port }}.pid
loglevel {{ redis_loglevel }}
logfile "/var/log/redis/redis-server-{{ redis_master_port }}.log"
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
dbfilename dump-{{ redis_master_port }}.rdb
appendfilename "appendonly-{{ redis_master_port }}.aof"

{% if redis_protected_mode %}
protected-mode yes
{% else %}
protected-mode no
{% endif %}
