[![build status](https://gitrep.services.local/ansible-middlewares/ansible-redis/badges/develop/build.svg)](https://gitrep.services.local/ansible-middlewares/ansible-redis/commits/develop)
Role Name
=========

	Ansible-Redis :
		For Redis 3.2 for Ubuntu Trusty and Xenial
		Works on :
			- Standalone (Standalone)
			- Cluster with 3 hosts (2 nodes per host) (CLUSTER)
			- Master - Slave(s) (MS with Sentinel on each hosts)

Requirements
------------

	Ansible 2.x

Role Variables
--------------

	## APT ##
	redis_apt_key: "http://mirror.services.local/pubkey/redis.gpg.pub"
	redis_apt_repo: "deb http://mirror.services.local/redis/ubuntu {{ ansible_distribution_release }} main"

	## LV ##
	redis_lv_create: yes
	redis_lv_name: "lv_redis"
	redis_vg_root: "vg_vroot"
	redis_lvsize: "5G"
	redis_maxmemory: "3gb"

  ## protected-mode ##
  redis_protected_mode: True

	## Memory ##
	redis_appendonly: "no"
	redis_appendfsync: "everysec"
	redis_cluster_node_timeout: "15000"
	redis_loglevel: "notice"
	redis_port: "6379"

	## Clustering ##
	redis_cluster: no
	redis_master_port: "6379"
	redis_slave_port: "6380"
	redis_master_password: ""

	## Master slave ##
	redis_ms: no
	redis_sentinel_config_tpl: "redis_sentinel.conf.tpl"
	redis_sentinel_port: 26379
	redis_sentinel_tmpdir: /tmp/
	redis_sentinel_quorum: 2
	redis_sentinel_down_after: 30000
	redis_sentinel_parallel_syncs: 1
	redis_sentinel_failover_timeout: 180000
	redis_min_slaves_to_write: 1
	redis_min_slaves_max_lag: 10

	############# MANDATORY FOR CLUSTERING #######################
    ## 3 master declared with this format : ip1:port_master ip2:port_master ip3:port_master ##
    redis_master_list: "ip1:master_port ip2:master_port ip3:master_port"
    ## here 3 line needed to add 1 slave to one master but not on the same host ##
    ## format ipx:port_slave ipy:port_master (3 times)
    redis_slave_config:
      - "ip2:slave_port ip1:master_port"
      - "ip3:slave_port ip2:master_port"
      - "ip1:slave_port ip3:master_port"

    ## Templates Vars ##
    redis_save_config:
    	- "save 900 1"
      	- "save 300 10"
      	- "save 60 10000"
    ## TEMPLATE FILES ##
    redis_init_script_master: "redis_init_script_master"
    redis_init_script_slave: "redis_init_script_slave"
    redis_init_script_std: "redis_init_script_std"
    redis_init_script_sentinel: "redis_init_script_sentinel"
    redis_systemd_script_std: "systemd.redis-server_std.service"
    redis_systemd_script_master: "systemd.redis-server_master.service"
    redis_systemd_script_slave: "systemd.redis-server_slave.service"
    redis_systemd_script_sentinel: "systemd.redis-server_sentinel.service"


Dependencies
------------

	No

Example Standalone Playbook
----------------------------

	- hosts: trusty
  	roles:
	     - { role: ansible-redis }
  	vars:
    	redis_version: "latest"
    	redis_lv_create: yes
    	redis_lvsize: "5G"
    	redis_maxmemory: "1gb"
    	redis_maxmemory_policy: "allkeys-lru"
    	redis_cluster: no
    	redis_cluster_node_timeout: "5000"
    	redis_loglevel: "notice"
    	redis_appendonly: "yes"
    	redis_port: "6379"

Example Master-Slave with Sentinel Playbook
----------------------------

	- hosts: trusty
  	roles:
	     - { role: ansible-redis }
  	vars:
    	redis_version: "latest"
    	redis_lv_create: yes
    	redis_lvsize: "5G"
    	redis_maxmemory: "1gb"
    	redis_maxmemory_policy: "allkeys-lru"
    	redis_loglevel: "notice"
    	redis_appendonly: "yes"
    	redis_port: "6379"
    	redis_save_config:
	      - "save 900 1"
	      - "save 300 10"
	      - "save 42 10000"
    	redis_ms: yes
    	redis_master_password: "42"
    	redis_master_ip: "192.168.229.47"
    	redis_sentinel_port: 26379
    	redis_sentinel_tmpdir: /tmp/
    	redis_sentinel_quorum: 2

Example Cluster Playbook
-------------------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

	- hosts: trusty
  	  roles:
     	- { role: ansible-redis }
  	  vars:
	    redis_version: "3:3.0.6-1chl1~trusty1"
	    redis_lv_create: yes
	    redis_lvsize: "5G"
    	redis_maxmemory: "1gb"
    	redis_maxmemory_policy: "allkeys-lru"
    	redis_cluster: yes
    	redis_cluster_node_timeout: "5000"
    	redis_loglevel: "notice"
    	redis_appendonly: "no"
    	redis_master_port: "6379"
    	redis_slave_port: "6380"
    	redis_save_config:
    		- "save 900 1"
      		- "save 300 10"
      		- "save 60 10000"
    	redis_master_password: "5d108a001eb9933ef539a154cc0c17f394a0a5a028ab981cfd48b713dad4542a"
    	## 3 master declared with this format : ip1:port_master ip2:port_master ip3:port_master ##
    	redis_master_list: "192.168.229.47:6379 192.168.229.48:6379 192.168.229.55:6379"
    	## here 3 line needed to add 1 slave to one master but not on the same host ##
    	## format ipx:port_slave ipy:port_master (3 times)
    	redis_slave_config:
      	- "192.168.229.48:6380 192.168.229.47:6379"
      	- "192.168.229.55:6380 192.168.229.48:6379"
      	- "192.168.229.47:6380 192.168.229.55:6379"

Install example
-------------------------

	ansible-playbook -k --ask-become-pass -i inventory.ini --tags installation redis.yml

Testing example
-------------------------

	ansible-playbook -k --ask-become-pass -i inventory.ini --tags testing redis.yml

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
