FROM alpine:3.12

#ADD content-dev /

RUN set -eux \
    && apk add --no-cache --no-progress --repository http://dl-cdn.alpinelinux.org/alpine/edge/main ansible=2.9.11-r0 \
    && apk add --no-cache --no-progress --repository http://dl-cdn.alpinelinux.org/alpine/edge/community ansible-lint \
    && apk add --no-cache --no-progress openssh-client \
                                        sshpass \
                                        ca-certificates \
                                        git \
                                        py3-pip \
    ## add python packages for runtime deps
    && pip3 install passlib pexpect jmespath 'python-gitlab<=1.12.1' keyring sagecipher \
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
    && echo "|1|SsNpF6474W7GtoyqkT38Ndvj4og=|PXRZyqqgiYKBJ8m8CnVFx599g6U= ssh-dss AAAAB3NzaC1kc3MAAACBANGFW2P9xlGU3zWrymJgI/lKo//ZW2WfVtmbsUZJ5uyKArtlQOT2+WRhcg4979aFxgKdcsqAYW3/LS1T2km3jYW/vr4Uzn+dXWODVk5VlUiZ1HFOHf6s6ITcZvjvdbp6ZbpM+DuJT7Bw+h5Fx8Qt8I16oCZYmAPJRtu46o9C2zk1AAAAFQC4gdFGcSbp5Gr0Wd5Ay/jtcldMewAAAIATTgn4sY4Nem/FQE+XJlyUQptPWMem5fwOcWtSXiTKaaN0lkk2p2snz+EJvAGXGq9dTSWHyLJSM2W6ZdQDqWJ1k+cL8CARAqL+UMwF84CR0m3hj+wtVGD/J4G5kW2DBAf4/bqzP4469lT+dF2FRQ2L9JKXrCWcnhMtJUvua8dvnwAAAIB6C4nQfAA7x8oLta6tT+oCk2WQcydNsyugE8vLrHlogoWEicla6cWPk7oXSspbzUcfkjN3Qa6e74PhRkc7JdSdAlFzU3m7LMkXo1MHgkqNX8glxWNVqBSc0YRdbFdTkL0C6gtpklilhvuHQCdbgB3LBAikcRkDp+FCVkUgPC/7Rw==" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|rtyYQDhRn4mbh/GR3VyAsm7jCWw=|ASTGCL4N/kLSU7UHaQFUawqcF24= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> /etc/ssh/ssh_known_hosts \
    ##
    ## add ssh host keys for bitbucket.com
    && ssh-keygen -R bitbucket.com -f /etc/ssh/ssh_known_hosts \
    && echo "|1|skEpSxMOjVyRuXTVrGfAWkSXcwk=|h8Ij9Hrlf0WJ0/w1QVlTAzxDVOk= ssh-dss AAAAB3NzaC1kc3MAAACBAO53E7Kcxeak0luot3Z5ulOQJoLRBcnBQb0gpUfNL5rZW63fBubfXLbpZc2/GnHxRiFa2okTPvBULJZnjwXltyoRfjPICRLfH/ep3mZj6CVUyQgxES27CS1bEjMw8+S6hLlJF4dKqOIWH5+Ed+lo8ezzXbzcEj7R5h9xGgfY55HfAAAAFQDE/aqj+0sxv/ZRS3ArGxMHGYFebwAAAIEA6lZ68WgDMrR28iXIicJ7AnXPnZKzQK7xK68feKlYo9LcEkKTF3AZIE5nEvtn+ZYwZ5cKE3XKeU42aesAEAUxX9cUEzhi87q6PQagD6ZPcU89CCVlWsG8cKYCZ6VtMfcLU06grNfvl450KCHltWTaoBHdi9f8eFo3Gydg6JhyNJ8AAACAThcLJmru5QtpHo9wctg5jHKxv1BLPndKs3dVwAQwcd2sugoymGeH7IjBSFLqHsyl7XpDik4mH/YdkVwb1jAwA+JOu2gHpsSXLY22At+LKn6NHdL/qqbIf7ellnKXfEo+wz6DfGihaczY931WrjkEEsq1453/4BwQpAXrz2zbRSI=" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|zkFRzIdVmd4o06QeAIt23+5OAHE=|GxVtiw/GiORGaL85YxaNxgYsW0w= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==" >> /etc/ssh/ssh_known_hosts \
    ##
    ## add ssh host keys for bitbucket.org
    && ssh-keygen -R bitbucket.org -f /etc/ssh/ssh_known_hosts \
    && echo "|1|DBSC4KZEqOQLJw4OzRj1Z/osajA=|IeECICYJr/s6OWHEIFuVtZ87lqY= ssh-dss AAAAB3NzaC1kc3MAAACBAO53E7Kcxeak0luot3Z5ulOQJoLRBcnBQb0gpUfNL5rZW63fBubfXLbpZc2/GnHxRiFa2okTPvBULJZnjwXltyoRfjPICRLfH/ep3mZj6CVUyQgxES27CS1bEjMw8+S6hLlJF4dKqOIWH5+Ed+lo8ezzXbzcEj7R5h9xGgfY55HfAAAAFQDE/aqj+0sxv/ZRS3ArGxMHGYFebwAAAIEA6lZ68WgDMrR28iXIicJ7AnXPnZKzQK7xK68feKlYo9LcEkKTF3AZIE5nEvtn+ZYwZ5cKE3XKeU42aesAEAUxX9cUEzhi87q6PQagD6ZPcU89CCVlWsG8cKYCZ6VtMfcLU06grNfvl450KCHltWTaoBHdi9f8eFo3Gydg6JhyNJ8AAACAThcLJmru5QtpHo9wctg5jHKxv1BLPndKs3dVwAQwcd2sugoymGeH7IjBSFLqHsyl7XpDik4mH/YdkVwb1jAwA+JOu2gHpsSXLY22At+LKn6NHdL/qqbIf7ellnKXfEo+wz6DfGihaczY931WrjkEEsq1453/4BwQpAXrz2zbRSI=" >> /etc/ssh/ssh_known_hosts \
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
    && echo "|1|IKeEnLTeV2nLXmOaa5yKGmCAuos=|ofrcaOgwO/nUi6WMLrqDB5Fgsm4= ssh-dss AAAAB3NzaC1kc3MAAACBAPcVQoevF5HL/lACcED4UE1tG8C1azvBHOys0K2qOHZsBQgFB1O1TPrbPAloUE7/IonmDRj7lXHTA4E966yPzylJYSH1AFbpMyfcTj+mxzI53bxgqXJP2vF8cpbZEESHScEblj0cTrBAPt6sdL1Ri9HhKmTf/ROURQt2oKhP47k1AAAAFQCnPKju25JH+CgE0dzJ6mr8JDc/nwAAAIEA6VCjv+Zgn5/e9QEdjI0+BbHHHscg+Hl739SZ92JsgCbsE62o2MEBsZy2tirpFsWfQVa8acvy3HTqSWmOnooYa4ElmArPvsfwP0D1VIjrpxbBH6k9q/Xk4PqmEQKV+xV/bERsqo+hddYuAVk7iLq9L0MX05FWGCrepZ8PHFLOY6MAAACBAIgECy1Hh0I/cfK4zURY4HH95tQydg5/CQcuM83g9F/fqwBD7F5cRBSTXvnJocmFEgzi04hms2N3IQ7idkGU0IeKmuLNTzs6vO1sHIPFgkyk52YM78Y86YlpUeGwxha7ErxC4nRGon32DMNwLGfQRlVIDoWjwYyQ+DjacJ6fIv71" >> /etc/ssh/ssh_known_hosts \
    && echo "|1|xOnX2VH7py+y8D9o+DjDLGaXmmk=|JGRvbDmasXoUuznPvMftopjlD8I= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAoMesJ60dow5VqNsIqIQMBNmSYz6txSC5YSUXzPNWV4VIWTWdqbQoQuIu+oYGhBMoeaSWWCiVIDTwFDzQXrq8CwmyxWp+2TTuscKiOw830N2ycIVmm3ha0x6VpRGm37yo+z+bkQS3m/sE7bkfTU72GbeKufFHSv1VLnVy9nmJKFOraeKSHP/kjmatj9aC7Q2n8QzFWWjzMxVGg79TUs7sjm5KrtytbxfbLbKtrkn8OXsRy1ib9hKgOwg+8cRjwKbSXVrNw/HM+MJJWp9fHv2yzWmL8B6fKoskslA0EjNxa6d76gvIxwti89/8Y6xlhR0u65u1AiHTX9Q4BVsXcBZUDw==" >> /etc/ssh/ssh_known_hosts \
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
