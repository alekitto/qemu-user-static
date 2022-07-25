#!/bin/bash
set -xe

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.
PLATFORM=linux/amd64,linux/arm64,linux/arm/v7,linux/ppc64le,linux/s390x
PUSH="--load"

while getopts "t:d:x:p" opt; do
    case "$opt" in
        t)  TAG_VER=$OPTARG
        ;;
        d)  DOCKER_REPO=$OPTARG
        ;;
        x)  PLATFORM=$OPTARG
        ;;
        p)  PUSH="--push"
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

out_dir="containers"

# Generate register files.
cp -p "${out_dir}/latest/register.sh" "${out_dir}/register/"
cp -p "${out_dir}/latest/Dockerfile" "${out_dir}/register/"
# Comment out the line to copy qemu-*-static not to provide those.
sed -i '/^COPY --from=download_qemu/ s/^/#/' "${out_dir}/register/Dockerfile"

docker buildx build -t ${DOCKER_REPO}:latest --platform ${PLATFORM} ${out_dir}/latest $PUSH
docker buildx build -t ${DOCKER_REPO}:register --platform ${PLATFORM} ${out_dir}/register $PUSH
