FROM registry.fedoraproject.org/fedora-minimal:37

RUN \
	microdnf upgrade --best --nodocs --noplugins --setopt=install_weak_deps=0 --assumeyes && \
	microdnf install tini transmission-daemon-3.00-13.fc37 transmission-cli-3.00-13.fc37 transmission-common-3.00-13.fc37 --nodocs --noplugins --setopt=install_weak_deps=0 --assumeyes && \
	microdnf clean all && \
	grep 'transmission:x:998:998:transmission daemon account:/var/lib/transmission:/sbin/nologin' /etc/passwd && \
	grep 'transmission:x:998' /etc/group && \
	grep 'ExecStart=/usr/bin/transmission-daemon -f --log-error' /usr/lib/systemd/system/transmission-daemon.service

USER transmission
WORKDIR /var/lib/transmission
ENV TRANSMISSION_WEB_HOME=/usr/share/transmission/web
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/transmission-daemon", "-f", "--log-error"]
