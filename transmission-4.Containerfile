FROM registry.fedoraproject.org/fedora-minimal:40

RUN \
	microdnf upgrade --best --nodocs --noplugins --setopt=install_weak_deps=0 --assumeyes && \
	microdnf install tini transmission-daemon transmission-cli transmission-common --nodocs --noplugins --setopt=install_weak_deps=0 --assumeyes && \
	microdnf clean all && \
	grep 'transmission:x:999:999:transmission daemon account:/var/lib/transmission:/sbin/nologin' /etc/passwd && \
	grep 'transmission:x:999:' /etc/group && \
	grep 'ExecStart=/usr/bin/transmission-daemon -f --log-level=error' /usr/lib/systemd/system/transmission-daemon.service

USER transmission
WORKDIR /var/lib/transmission
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/transmission-daemon", "-f", "--log-level=error"]
