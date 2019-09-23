FROM debian:latest

EXPOSE 80
EXPOSE 443

RUN apt-get update -y 

RUN apt-get install -y git cmake clang-format pkg-config libglib2.0-dev \
    libgnutls28-dev uuid-dev libssh-dev libhiredis-dev libradcli-dev \
    libgpgme-dev libgcrypt20-dev libldap2-dev doxygen graphviz \
    heimdal-dev heimdal-multidev libpopt-dev gcc-mingw-w64 xmltoman \
    nodejs yarnpkg python-polib gettext libmicrohttpd-dev libxml2-dev \
    libical-dev xsltproc libpcap-dev libksba-dev \
    bison libsnmp-dev redis-server gnutls-bin  postgresql postgresql-contrib \
    postgresql-client postgresql-server-dev-all sudo libsqlite3-dev \
    libxml2-dev

RUN cd ~ && \
    git clone --branch gvm-libs-10.0 https://github.com/greenbone/gvm-libs.git && \
    git clone https://github.com/greenbone/openvas-smb.git && \
    git clone --branch gsa-8.0 https://github.com/greenbone/gsa.git && \
    git clone --branch gvmd-8.0 https://github.com/greenbone/gvmd.git && \
    git clone --branch openvas-scanner-6.0 https://github.com/greenbone/openvas.git

RUN export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib64/pkgconfig && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

RUN cd ~/gvm-libs && cmake . && make install && \
    cd ~/openvas-smb && cmake . && make install && \
    cd ~/gsa && cmake . && make install && \
    cd ~/gvmd && cmake . && make install && \
    cd ~/openvas && cmake . && make install

RUN ldconfig
RUN greenbone-nvt-sync
RUN gvm-manage-certs -a
COPY run.sh ~/run.sh
ENTRYPOINT ~/run.sh
