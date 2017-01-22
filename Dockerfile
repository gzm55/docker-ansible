FROM alpine:3.5

RUN set -eux \
    && apk add --no-cache --no-progress --virtual .build-deps py2-pip \
    && apk add --no-cache --no-progress ansible=2.2.0.0-r0 \
                                        openssh-client \
                                        ca-certificates \
                                        git \
    && pip install passlib \

    ## cleanup
    && apk del --no-cache .build-deps \
    && find /usr/ -depth \
            \( \( ! -path '*/ansible/*' -a \( -type d -a -name test -o -name tests \) \) \
               -o \
               \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
            \) -print -exec rm -rf '{}' +
