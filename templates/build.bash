CURRENT_SCRIPT=$(readlink -f -- $0 )
# one level up
CURRENT_DIR=${CURRENT_SCRIPT%/*}

BUILD_GENTOO="$CURRENT_DIR/gentoo/build.bash"
BUILD_EBUILD_OVERLAY="$CURRENT_DIR/ebuild-overlay/build.bash"
BUILD_TARGET="$CURRENT_DIR/target/build.bash"

bash $BUILD_GENTOO
{% if custom_ebuild_repository != False -%}
bash $BUILD_EBUILD_OVERLAY
{% endif %}
bash $BUILD_TARGET
