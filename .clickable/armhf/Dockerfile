FROM clickable/amd64-16.04-armhf:16.04.5

RUN echo set debconf/frontend Noninteractive | debconf-communicate && echo set debconf/priority critical | debconf-communicate
RUN apt-get update && apt-get install -y --force-yes --no-install-recommends qtdeclarative5-ubuntu-history0.1:armhf history-service:armhf qtdeclarative5-ubuntu-contacts0.1:armhf qtdeclarative5-ubuntu-addressbook0.1:armhf libpam0g-dev:armhf libgsettings-qt-dev:armhf qtdeclarative5-gsettings1.0:armhf && apt-get clean