#!/bin/bash

redis-server /usr/local/share/doc/openvas-scanner/redis_config_examples/redis_4_0.conf
openvassd
gvmd
gsad -f --http-only 
