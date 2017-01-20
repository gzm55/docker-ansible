#!/usr/bin/env bash

test ":$DEBUG" = :true && set -x
set -e

VOLUME_OPTS=
# volumes for timezone
for v in /etc/localtime /etc/sysconfig/clock /usr/share/zoneinfo; do
  if [[ -r "$v" ]]; then
    VOLUME_OPTS+=" --volume=$v:$v:ro"
  fi
done

# volumes for user and group
for v in /etc/group /etc/passwd $SSH_AUTH_SOCK; do
  VOLUME_OPTS+=" --volume=$v:$v:ro"
done

# volumes for home dir and ssh config
VOLUME_OPTS+=" --volume=$HOME/.ssh:/home/$USER/.ssh"

ENV_OPTS=
[[ ! $SSH_AUTH_SOCK ]] || ENV_OPTS+=" --env SSH_AUTH_SOCK=$SSH_AUTH_SOCK"

exec docker run --rm -it \
  --network host \
  $VOLUME_OPTS \
  $ENV_OPTS \
  -w ~ \
  gzm55/ansible:latest \
  sh -c "chown $USER:$USER $HOME; exec su -s /bin/sh ${*:+-c \"$*\"} $USER"
