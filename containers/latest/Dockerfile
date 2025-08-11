# syntax=docker/dockerfile:1.17
FROM debian:sid-20250721 AS download_qemu

RUN mkdir -p /app

WORKDIR /app

# Non-amd64 builds will search for tar executable in /usr/local/sbin. Create a symlink.
RUN ln -sv /usr/bin/tar /usr/local/sbin/tar

RUN apt-get update && \
    apt-get download qemu-user-static && \
    apt-get download qemu-user && \
    dpkg-deb -R qemu-user_*.deb /app/releases && \
    rm -rf /app/releases/DEBIAN && \
    dpkg-deb -R qemu-user-static_*.deb /app/releases

FROM debian:stable-slim

ENV QEMU_BIN_DIR=/usr/bin PROC_PREFIX=""
ADD --link ./register.sh /register
ADD --link https://raw.githubusercontent.com/qemu/qemu/v10.0.2/scripts/qemu-binfmt-conf.sh /qemu-binfmt-conf.sh

RUN sed -i 's/\/proc\/sys\/fs\/binfmt_misc/$PROC_PREFIX\/proc\/sys\/fs\/binfmt_misc/' /qemu-binfmt-conf.sh && \
    chmod +x /qemu-binfmt-conf.sh

COPY --from=download_qemu /app/releases/usr/bin/qemu-* /usr/bin/

ENTRYPOINT ["/register"]
