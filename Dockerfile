FROM alpine:3.20

#ADD content-dev /

RUN set -eux \
    && apk add --no-cache --no-progress --repository http://dl-cdn.alpinelinux.org/alpine/edge/community ansible=10.1.0-r0 'ansible-lint>=24.6.1-r0' \
    && apk add --no-cache --no-progress openssh-client \
                                        sshpass \
                                        ca-certificates \
                                        git \
                                        py3-pip \
                                        rsync \
    ## add python packages for runtime deps
    && apk add --no-cache --no-progress --virtual .build-deps gcc musl-dev \
    && rm /usr/lib/python3.12/EXTERNALLY-MANAGED \
    && pip3 install passlib pexpect jmespath 'python-gitlab>=4.0.0' keyring sagecipher \
    && apk del .build-deps \
    && touch /usr/lib/python3.12/EXTERNALLY-MANAGED \
    ##
    ## add default ansible config
    && mkdir -p /etc/ansible \
    && echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts \
    ##
    && touch /etc/ssh/ssh_known_hosts \
    && chmod 644 /etc/ssh/ssh_known_hosts \
    ##
    ## add ssh host keys for github.com
    && ssh-keygen -R github.com -f /etc/ssh/ssh_known_hosts \
    && echo "|1|+FZrZ/LmHddcPDXCHwAKBi1kEUo=|+gPMyb6Unuoqx/o8HjEfTtWhlc8= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|fYDqPBFeIp0pkIhSArAQWe1g3W0=|2rbogkXp34rVhtuesTXrwjuNS7o= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|1bzS9tPUkOHRkeFCGjQEZr+F5+I=|SC1Mdx5iRGeAIXRFZ7gLGa6fhXg= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl" >> /etc/ssh/ssh_known_hosts \
    ##
    ## add ssh host keys for bitbucket.org
    && ssh-keygen -R bitbucket.org -f /etc/ssh/ssh_known_hosts \
    && echo "|1|uIfR7M6ga5fJbGtHHmkdQj9dbF4=|RcXNSro8Uz0cU995C/IoM1jcmFQ= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIazEu89wgQZ4bqs3d63QSMzYVa0MuJ2e2gKTKqu+UUO" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|vevYAeuccSwLctqf3CCip+nAGTk=|gclOYOHUpnyJwNQ7MColkxnfinY= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==" >> /etc/ssh/ssh_known_hosts \
    ##
    ## add ssh host keys for gitlab.com
    && ssh-keygen -R gitlab.com -f /etc/ssh/ssh_known_hosts \
    && echo "|1|dJssYC3g9JmFOtaWRYAv8d8ZJOs=|9IE6XS60hhQhTPW0tZdMZOYGa0E= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|gY3a+C2qQ0RSx5BXDZLV7zbhwnY=|Qu5BhPfYQiSW/a2OvDET+Iwkjag= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|ehmxjY6jMzglv6OPBeMb/4H6GfU=|5ZgG6dRit3V5sY3i7/7Cs3bHJgI= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf" >> /etc/ssh/ssh_known_hosts \
    ##
    ## add ssh host keys for git.code.sf.net
    && ssh-keygen -R git.code.sf.net -f /etc/ssh/ssh_known_hosts \
    && echo "|1|L07TyOGr+ybKtOx1CLDAzj3Ypf0=|+BkAAJ5msLYv0y45UhY+c+vnfbo= ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGObtXLh/mZom0pXjE5Mu211O+JvtzolqdNKVA+XJ466" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|xOnX2VH7py+y8D9o+DjDLGaXmmk=|JGRvbDmasXoUuznPvMftopjlD8I= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAoMesJ60dow5VqNsIqIQMBNmSYz6txSC5YSUXzPNWV4VIWTWdqbQoQuIu+oYGhBMoeaSWWCiVIDTwFDzQXrq8CwmyxWp+2TTuscKiOw830N2ycIVmm3ha0x6VpRGm37yo+z+bkQS3m/sE7bkfTU72GbeKufFHSv1VLnVy9nmJKFOraeKSHP/kjmatj9aC7Q2n8QzFWWjzMxVGg79TUs7sjm5KrtytbxfbLbKtrkn8OXsRy1ib9hKgOwg+8cRjwKbSXVrNw/HM+MJJWp9fHv2yzWmL8B6fKoskslA0EjNxa6d76gvIxwti89/8Y6xlhR0u65u1AiHTX9Q4BVsXcBZUDw==" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|KNQd4X3l5QAuwpIiVPgnAk90ftY=|UTbvBLFjYnX5eXWDXA60KIVQdls= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPAa5MFfMaXyT3Trf/Av/laAvIhUzZJUnvPZAd9AC6bKWAhVl+A3s2+M6SlhF/Tn/W0akN03GyNviBtqJKtx0RU=" >> /etc/ssh/ssh_known_hosts \
    ##
    ## create ~/.ssh dir with correct permission
    && mkdir ~/.ssh \
    && chmod 700 ~/.ssh \
    ##
    ## cleanup
    && rm -rf ~/.cache /etc/ssh/ssh_known_hosts.old \
    && find /usr/ -depth \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
            -delete \
    && find /usr/ -depth \
            \( ! -path '*/ansible/*' \
               -a \
               \( -type d -a -name test -o -name tests \) \
            \) \
            -print \
            -exec rm -rf '{}' +
