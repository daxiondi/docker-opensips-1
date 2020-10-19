FROM debian:jessie
MAINTAINER "Kyle Bai <kyle.b@inwinstack.com>"
MAINTAINER "Lorenzo Mangani <lorenzo.mangani@gmail.com>"

USER root

RUN apt-get update && apt-get install -y sudo git make bison flex curl libssl-dev

RUN curl ipinfo.io/ip > /etc/public_ip.txt

RUN git clone https://github.com/OpenSIPS/opensips.git -b 3.1 ~/opensips_3_1 && \
    cd ~/opensips_3_1 && \
    make all && make prefix=/usr/local install && \
    cd .. && rm -rf ~/opensips_3_1

RUN apt-get purge -y bison build-essential ca-certificates flex git m4 pkg-config curl && \
    apt-get autoremove -y && \
    apt-get install -y libmicrohttpd10 rsyslog && \
    apt-get clean

COPY conf/opensipsctlrc /usr/local/etc/opensips/opensipsctlrc
COPY conf/opensips.cfg /usr/local/etc/opensips/opensips.cfg

COPY boot_run.sh /etc/boot_run.sh
RUN chown root.root /etc/boot_run.sh && chmod 700 /etc/boot_run.sh

EXPOSE 5060/udp

ENTRYPOINT ["/etc/boot_run.sh"]
