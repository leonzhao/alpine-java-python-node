FROM hirokimatsumoto/alpine-openjdk-11
ENV VERSION=v12.16.1 NPM_VERSION=6 
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
RUN apk add --update \
    python3 \
    python3-dev \
    py-pip \
    build-base \
    libxml2-dev \
    libxslt-dev

RUN apk upgrade --no-cache -U && \
  apk add --no-cache curl make gcc g++ linux-headers binutils-gold gnupg libstdc++
  
RUN curl -sfSLO https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.xz && \
  curl -sfSL https://nodejs.org/dist/${VERSION}/SHASUMS256.txt.asc | gpg -d -o SHASUMS256.txt && \
  grep " node-${VERSION}.tar.xz\$" SHASUMS256.txt | sha256sum -c | grep ': OK$' && \
  tar -xf node-${VERSION}.tar.xz && \
  cd node-${VERSION} && \
  ./configure --prefix=/usr ${CONFIG_FLAGS} && \
  make -j$(getconf _NPROCESSORS_ONLN) && \
  make install

RUN if [ -z "$CONFIG_FLAGS" ]; then \
    if [ -n "$NPM_VERSION" ]; then \
      npm install -g npm@${NPM_VERSION}; \
    fi; \
    find /usr/lib/node_modules/npm -type d \( -name test -o -name .bin \) | xargs rm -rf; \
  fi

RUN apk del curl make gcc g++ linux-headers binutils-gold gnupg ${DEL_PKGS} && \
  rm -rf ${RM_DIRS} /node-${VERSION}* /SHASUMS256.txt /tmp/* \
    /usr/share/man/* /usr/share/doc /root/.npm /root/.node-gyp /root/.config \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/docs \
    /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts && \
  { rm -rf /root/.gnupg || true; }

RUN echo 'ls -alh --color=auto $@' > /bin/l && chmod +x /bin/l \
    && rm -rf /var/cache/apk/*
RUN mkdir ~/.pip
WORKDIR /usr/workspace
COPY requirements.txt /usr/workspace
RUN python3 -m pip install -i https://mirrors.aliyun.com/pypi/simple/ --upgrade pip
RUN pip3 install -i https://mirrors.aliyun.com/pypi/simple/ -r /usr/workspace/requirements.txt