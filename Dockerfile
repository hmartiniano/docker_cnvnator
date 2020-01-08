FROM ubuntu:16.04
#FROM ubuntu:18.04
# Adapted from https://github.com/abyzovlab/CNVnator/blob/master/Dockerfile
# to run on ubuntu 16.04 

RUN apt update && apt install -y --no-install-recommends \
  ca-certificates \
  g++ \
  libbz2-dev \
  libcurl3-dev \
  libfreetype6-dev \
  liblzma-dev \
  libncurses5-dev \
  libreadline-dev \
  libpython2.7 \
  libz-dev \
  make \
  python-matplotlib \
  python-scipy \
  python-tk \
  curl \
  bzip2 \
  unzip \
 && rm -rf /var/lib/apt/lists/*

RUN curl https://root.cern/download/root_v6.18.04.Linux-ubuntu16-x86_64-gcc5.4.tar.gz | \
 tar -C /opt -xzf -

ENV PYTHONPATH=/opt/root/lib

RUN echo '/opt/root/lib' > /etc/ld.so.conf.d/root.conf \
 && ldconfig

RUN curl -L https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 | \
 tar -C /tmp -xjf - \
 && cd /tmp/samtools-* \
 && make \
 && (cd htslib-* && make mostlyclean) \
 && make mostlyclean \
 && find /tmp -name test -type d -exec rm -rf {} +


RUN cd /tmp \
 && curl https://github.com/abyzovlab/CNVnator/releases/download/v0.4.1/CNVnator_v0.4.1.zip \
 && unzip CNVnator_v0.4.1.zip \
 && cd /tmp/CNVnator_v0.4.1 \
 && ln -s /tmp/samtools-* samtools \
 && ROOTSYS=/opt/root make \
 && mv cnvnator *.py *.pl /usr/local/bin \
 && mv pytools /usr/local/lib/python*/dist-packages \
 && cd - \
 && rm -rf /tmp/*
