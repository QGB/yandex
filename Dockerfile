FROM ubuntu:18.04

LABEL maintainer="qgbcs"

ENV VNC_SCREEN_SIZE 1366x768

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && apt-get update \
	&& apt-get install -y --no-install-recommends \
	gdebi \
	gnupg2 \
	fonts-takao \
	pulseaudio \
	supervisor \
	x11vnc \
	fluxbox \
	eterm \
 fonts-arphic-ukai \
 fonts-arphic-uming 
 

COPY yandex.deb	/tmp/yandex.deb

RUN gdebi --non-interactive /tmp/yandex.deb

RUN apt-get install -y xvfb tmux htop vim lsof

COPY copyables /

RUN apt-get clean \
	&& rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/* \
#	&& useradd -m -G chrome-remote-desktop,pulse-access chrome \
&& useradd -m -G pulse-access chrome \
	&& usermod -s /bin/bash chrome \
	&& ln -s /crdonly /usr/local/sbin/crdonly \
	&& ln -s /update /usr/local/sbin/update \
&& mkdir -p /home/chrome/.config \
	&& mkdir -p /home/chrome/.config/chrome-remote-desktop \
	&& mkdir -p /home/chrome/.fluxbox \
	&& echo ' \n\
		session.screen0.toolbar.visible:        true\n\
		session.screen0.fullMaximization:       false\n\
		session.screen0.maxDisableResize:       false\n\
		session.screen0.maxDisableMove: false\n\
		session.screen0.defaultDeco:    NONE\n\
	' >> /home/chrome/.fluxbox/init \
	&& chown -R chrome:chrome /home/chrome/.config /home/chrome/.fluxbox

VOLUME ["/home/chrome"]

EXPOSE 5900

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
