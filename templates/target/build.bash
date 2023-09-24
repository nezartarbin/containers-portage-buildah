CONTAINER_TAG="{{ target.container_tag }}"
BASE_CONTAINER="oxa/ebuild-overlay"

BUILDER_WORK_DIR=/tmp/work-dir-target

builder_container=$(buildah from $BASE_CONTAINER)
buildah run $builder_container -- emerge --root ${BUILDER_WORK_DIR} {{ target.package_atom }}

output_container=$(buildah from scratch)
buildah copy --from $builder_container $output_container $BUILDER_WORK_DIR /
buildah commit $output_container $CONTAINER_TAG
