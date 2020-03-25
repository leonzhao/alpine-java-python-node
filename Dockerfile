FROM hirokimatsumoto/alpine-openjdk-11
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk add --update \
    python3 \
    python3-dev \
    py-pip \
    build-base \
    nodejs \
    npm \
    libxml2-dev \
    libxslt-dev
RUN echo 'ls -alh --color=auto $@' > /bin/l && chmod +x /bin/l \
    && rm -rf /var/cache/apk/*
RUN mkdir ~/.pip
WORKDIR /usr/workspace
COPY requirements.txt /usr/workspace
RUN python3 -m pip install -i https://mirrors.aliyun.com/pypi/simple/ --upgrade pip
RUN pip3 install -i https://mirrors.aliyun.com/pypi/simple/ -r /usr/workspace/requirements.txt


