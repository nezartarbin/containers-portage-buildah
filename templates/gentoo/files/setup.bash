WORK_DIR=$1
mkdir -p /etc/portage/repos.conf
mv "$WORK_DIR"/gentoo-mirror.conf /etc/portage/repos.conf/gentoo.conf
mv "$WORK_DIR"/make.conf /etc/portage/make.conf
emerge --jobs {{build.max_parallel_jobs}} --oneshot sys-apps/portage
emerge --jobs {{build.max_parallel_jobs}} vuDN @world
emerge --depclean
rm -rf $WORK_DIR
