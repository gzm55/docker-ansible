# docker-ansible

Docker image of an ansible managing gateway based on alpine.

## Usage

```Bash

docker run --rm -it \
           --network host \
           --volume=/etc/group:/etc/group:ro \
           --volume=/etc/passwd:/etc/passwd:ro \
           --volume=$SSH_AUTH_SOCK:$SSH_AUTH_SOCK:ro \
           --volume=$HOME/.ssh:/home/$USER/.ssh \
           --env SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
           -w /home/$USER gzm55/ansible:latest su -s /bin/sh $USER

```
