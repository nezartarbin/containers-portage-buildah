emerge --sync
emerge --jobs {{build.max_parallel_jobs}} \
	dev-util/pkgdev \
	app-eselect/eselect-repository
