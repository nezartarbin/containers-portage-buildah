CONTAINER_TAG="oxa/ebuild-overlay"
BASE_CONTAINER="oxa/gentoo"

CURRENT_SCRIPT=$(readlink -f -- $0 )
# one level up
CURRENT_DIR=${CURRENT_SCRIPT%/*}
FILES_DIR="${CURRENT_DIR}/files"
CONTAINER_WORK_DIR=/tmp/work-dir-ebuild-overlay


working_container=$(buildah from $BASE_CONTAINER)

buildah copy $working_container "$FILES_DIR/*" $CONTAINER_WORK_DIR
buildah copy $working_container {{ custom_ebuild_repository.cert_path }} $CONTAINER_WORK_DIR
buildah run $working_container -- /bin/env bash $CONTAINER_WORK_DIR/setup.bash $WORK_DIR
buildah commit $working_container $CONTAINER_TAG
