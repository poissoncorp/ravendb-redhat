ARG BASE_REGISTRY=registry.dso.mil
ARG BASE_IMAGE=ironbank/redhat/ubi/ubi8
ARG BASE_TAG=latest

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

# RavenDB environment
ENV RAVEN_ARGS='' RAVEN_SETTINGS='' RAVEN_Setup_Mode='Initial' RAVEN_DataDir='RavenData' RAVEN_ServerUrl_Tcp='38888' RAVEN_AUTO_INSTALL_CA='true' RAVEN_IN_DOCKER='true'

# Expose http, tcp and monitoring ports
EXPOSE 8080 38888 161

# Dockerfile version
ARG RELEASE=1.0.0

COPY config/RavenDB.tar.bz2 /opt/RavenDB.tar.bz2
COPY LICENSE /licenses/ravendb

# Ensure that all packages are updated at time of build
RUN dnf update -y --nodocs && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN groupadd ravendb && \
    useradd -u 1000 -g ravendb ravendb

RUN cd /opt \
    # Unzip the archive
    && dnf install -y tar bzip2 \
    && tar xjvf /opt/RavenDB.tar.bz2 \
    && rm /opt/RavenDB.tar.bz2 \
    && dnf remove -y tar bzip2 \
    # Remove packages which aren't part of other dependencies
    && dnf autoremove -y \ 
    # Remove any cached packages from the system
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Copy the scripts and RavenDB config
COPY --chown=ravendb:ravendb scripts /opt/RavenDB/scripts
COPY config/settings.json /opt/RavenDB/Server

# Set workdir to the Server directory
WORKDIR  /opt/RavenDB/Server
RUN chmod -R 770 /opt/RavenDB/Server && \
    chown -R ravendb:ravendb /opt/RavenDB/ 

RUN dnf install -y libicu

# Switch to user from the root
USER ravendb:ravendb

CMD [ "/bin/bash", "/opt/RavenDB/scripts/run-raven.sh" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 CMD /opt/RavenDB/scripts/healthcheck.sh