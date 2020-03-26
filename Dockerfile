FROM node:lts-alpine
ENV VERSION=v12.16.1 NPM_VERSION=6 

# Default to UTF-8 encoding
ENV LANG C.UTF-8

# Configuration variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-11-openjdk/jre/bin:/usr/lib/jvm/java-11-openjdk/bin

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
RUN apk add --update \
    python3 \
    python3-dev \
    py-pip \
    build-base \
    libxml2-dev \
    libxslt-dev

# Installi Java
RUN set -x \
	  && apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

RUN echo 'ls -alh --color=auto $@' > /bin/l && chmod +x /bin/l \
    && rm -rf /var/cache/apk/*

WORKDIR /usr/workspace
COPY requirements.txt /usr/workspace
RUN python3 -m pip install -i https://mirrors.aliyun.com/pypi/simple/ --upgrade pip
RUN pip3 install -i https://mirrors.aliyun.com/pypi/simple/ -r /usr/workspace/requirements.txt