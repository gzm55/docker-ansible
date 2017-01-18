FROM alpine:3.5

RUN set -eux \
    && apk add --no-cache ansible=2.2.0.0-r0 \
                          openssh-client \
                          ca-certificates \
                          git \

    ## cleanup
    && find /usr/ -depth \
            \( \( -type d -a -name test -o -name tests \) \
               -o \
               \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
            \) -delete
