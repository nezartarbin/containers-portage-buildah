eselect repository add {{ custom_ebuild_repository.name }} {{custom_ebuild_repository.sync_type}} {{ custom_ebuild_repository.url }}
emerge --sync {{ custom_ebuild_repository.name }}
