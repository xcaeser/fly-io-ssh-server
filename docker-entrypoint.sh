#!/bin/bash

/usr/sbin/sshd

echo $AUTHORIZED_KEYS >/root/.ssh/authorized_keys

exec "$@"
