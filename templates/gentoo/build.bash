CONTAINER_TAG="oxa/gentoo"
BASE_CONTAINER="gentoo/stage3:amd64-openrc"

CURRENT_SCRIPT=$(readlink -f -- $0 )
# one level up
CURRENT_DIR=${CURRENT_SCRIPT%/*}
FILES_DIR="${CURRENT_DIR}/files"
CONTAINER_WORK_DIR=/tmp/work-dir-gentoo

working_container=$(buildah from $BASE_CONTAINER)

buildah copy $working_container \
    "$FILES_DIR/gentoo-mirror.conf" \
    "$FILES_DIR/make.conf" \
    "$FILES_DIR/setup.bash" \
    $CONTAINER_WORK_DIR

buildah run $working_container -- /bin/env bash $CONTAINER_WORK_DIR/setup.bash $WORK_DIR
buildah commit --squash $working_container $CONTAINER_TAG
