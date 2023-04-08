FROM registry.fedoraproject.org/fedora-minimal:38

RUN \
	microdnf upgrade --best --nodocs --noplugins --setopt=install_weak_deps=0 --assumeyes && \
	microdnf install tini --nodocs --noplugins --setopt=install_weak_deps=0 --assumeyes && \
	microdnf clean all

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/bash"]
