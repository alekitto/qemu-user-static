FROM ubuntu AS download_qemu

RUN mkdir -p /app

WORKDIR /app

RUN apt-get update && \
    apt-get download qemu-user-static && \
    dpkg-deb -R qemu-user-static_*.deb /app/releases

FROM busybox
ENV QEMU_BIN_DIR=/usr/bin
ADD ./register.sh /register
ADD https://raw.githubusercontent.com/qemu/qemu/e75941331e4cdc05878119e08635ace437aae721/scripts/qemu-binfmt-conf.sh /qemu-binfmt-conf.sh

RUN chmod +x /qemu-binfmt-conf.sh
COPY --from=download_qemu /app/releases/usr/bin/qemu-*-static /usr/bin/

ENTRYPOINT ["/register"]
