FROM centos:latest
MAINTAINER wangbo <wangbo@yiqijiao.cn>

ENV CONSUL_VERSION=1.4.3
ENV HASHICORP_RELEASES=https://releases.hashicorp.com

#创建用户
RUN groupadd consul && useradd -g consul consul

#安装consul 并 放置到/usr/local/bin
RUN yum upgrade -y && \
    yum install -y net-tools && \
    yum install -y firewalld firewalld-config && \
    yum install -y wget && \
    yum install -y unzip && \
    wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul_${CONSUL_VERSION}_linux_amd64.zip && \
    rm -rf consul_${CONSUL_VERSION}_linux_amd64.zip && \
    mv consul /usr/local/bin

#创建consul数据目录和配置目录
RUN mkdir -p /consul/data && \
    mkdir -p /consul/config && \
    chown -R consul:consul /consul

#设置匿名卷 此目录数据不会保存到容器存储层
VOLUME /consul/data

#开放端口
EXPOSE 8300
EXPOSE 8301 8301/udp 8302 8302/udp
EXPOSE 8500 8600 8600/udp
EXPOSE 80
