FROM hypriot/rpi-python
MAINTAINER Yuri Teixeira <oyuriteixeira at gmail dot com>

ENV DATADIR /seafile
ENV BASEPATH /opt/haiwen

RUN sudo apt-get update && apt-get install -y \
    python-ldap python-urllib3 python-imaging sqlite3 curl locales \
    --no-install-recommends \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -d ${DATADIR} -M -s /bin/bash -c "Seafile User" seafile \
    && mkdir -p ${DATADIR} ${BASEPATH} 

RUN curl -skL https://github.com/$(curl -skL https://github.com/haiwen/seafile-rpi/releases \
    | grep -oE 'haiwen/seafile-rpi/releases/download/v.*/seafile-server_.*_stable_pi.tar.gz'|sort -r|head -1) \
    | tar -C ${BASEPATH} -xz 

RUN chown -R seafile:seafile ${DATADIR} ${BASEPATH}

COPY ["entrypoint.sh", "/usr/local/bin/"]
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

EXPOSE 8000 8082

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"] 
