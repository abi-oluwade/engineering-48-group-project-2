#!/bin/bash
mongo --eval "cfg = rs.conf()"
mongo --eval "cfg.members[2].priority = 2"
