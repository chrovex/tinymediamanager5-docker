#
# TinyMediaManager Dockerfile
#
FROM jlesage/baseimage-gui:alpine-3.21-v4

# Define software versions.
ARG TMM_VERSION=5.1.1

# Define software download URLs.
ARG TMM_URL=https://archive.tinymediamanager.org/v${TMM_VERSION}/tinyMediaManager-${TMM_VERSION}-linux-amd64.tar.xz
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jre/bin

# Define working directory.
WORKDIR /tmp

# Download TinyMediaManager
RUN \
    mkdir -p /defaults && \
    wget ${TMM_URL} -O /defaults/tmm.tar.xz

# Install dependencies.
RUN \
    apk add --update \
        libmediainfo \
        ttf-dejavu \
        bash \
	    zenity \
        tar \
      	zstd \
      fontconfig \
      ttf-dejavu

# Maximize only the main/initial window.
# It seems this is not needed for TMM 3.X version.
#RUN \
#    sed-patch 's/<application type="normal">/<application type="normal" title="tinyMediaManager \/ 3.0.2">/' \
#        /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://gitlab.com/tinyMediaManager/tinyMediaManager/raw/45f9c702615a55725a508523b0524166b188ff75/AppBundler/tmm.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY VERSION /

# Set environment variables.
ENV APP_NAME="TinyMediaManager" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/media"]

# Metadata.
LABEL \
      org.label-schema.name="tinymediamanager" \
      org.label-schema.description="Docker container for TinyMediaManager" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/dzhuang/tinymediamanager5-docker" \
      org.label-schema.schema-version="1.0"
