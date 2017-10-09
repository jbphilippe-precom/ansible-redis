# {{ ansible_managed }}
bind 0.0.0.0
daemonize yes
pidfile /var/run/redis/redis-sentinel-{{ redis_sentinel_port }}.pid
loglevel {{ redis_loglevel }}
logfile "/var/log/redis/redis-sentinel-{{ redis_sentinel_port }}.log"

port {{ redis_sentinel_port }}
dir {{ redis_sentinel_tmpdir }}
sentinel monitor mymaster {{ redis_master_ip }} {{ redis_port }} {{ redis_sentinel_quorum }}

{% if redis_master_password is defined %}
{% if redis_master_password != "" %}
sentinel auth-pass mymaster {{ redis_master_password }}
{% endif %}
{% endif %}

{% if redis_protected_mode %}
protected-mode yes
{% else %}
protected-mode no
{% endif %}

# sentinel down-after-milliseconds <master-name> <milliseconds>
#
# Number of milliseconds the master (or any attached slave or sentinel) should
# be unreachable (as in, not acceptable reply to PING, continuously, for the
# specified period) in order to consider it in S_DOWN state (Subjectively
# Down).
#
# Default is 30 seconds.
sentinel down-after-milliseconds mymaster {{ redis_sentinel_down_after }}

# sentinel parallel-syncs <master-name> <numslaves>
#
# How many slaves we can reconfigure to point to the new slave simultaneously
# during the failover. Use a low number if you use the slaves to serve query
# to avoid that all the slaves will be unreachable at about the same
# time while performing the synchronization with the master.
sentinel parallel-syncs mymaster {{ redis_sentinel_parallel_syncs }}

# sentinel failover-timeout <master-name> <milliseconds>
#
# Specifies the failover timeout in milliseconds. It is used in many ways:
#
# - The time needed to re-start a failover after a previous failover was
#   already tried against the same master by a given Sentinel, is two
#   times the failover timeout.
#
# - The time needed for a slave replicating to a wrong master according
#   to a Sentinel current configuration, to be forced to replicate
#   with the right master, is exactly the failover timeout (counting since
#   the moment a Sentinel detected the misconfiguration).
#
# - The time needed to cancel a failover that is already in progress but
#   did not produced any configuration change (SLAVEOF NO ONE yet not
#   acknowledged by the promoted slave).
#
# - The maximum time a failover in progress waits for all the slaves to be
#   reconfigured as slaves of the new master. However even after this time
#   the slaves will be reconfigured by the Sentinels anyway, but not with
#   the exact parallel-syncs progression as specified.
#
# Default is 3 minutes.
sentinel failover-timeout mymaster {{ redis_sentinel_failover_timeout }}
