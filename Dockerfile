FROM quay.io/thoth-station/s2i-minimal-py38-notebook:v0.0.14

ENV ENABLE_MICROPIPENV="1"
USER root

# Install java + code-server
RUN yum -y install java-$JAVA_VERSION-openjdk maven && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    rm -rf $HOME/.cache/code-server && \
    yum clean all

# install rclone
RUN mkdir -p /tmp/rclone
WORKDIR /tmp/rclone
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone


# Copying in override assemble/run scripts
COPY .s2i/bin /tmp/scripts
# Copying in source code
COPY . /tmp/src

COPY start-singleuser.sh /opt/app-root/bin/start-singleuser.sh

WORKDIR /opt/app-root/src
# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/scripts /tmp/src /opt/app-root/bin/start-singleuser.sh && \
    chmod +x /tmp/scripts/run /tmp/scripts/assemble /opt/app-root/bin/start-singleuser.sh

USER 1001

RUN /tmp/scripts/assemble
CMD [ "/tmp/scripts/run" ]
