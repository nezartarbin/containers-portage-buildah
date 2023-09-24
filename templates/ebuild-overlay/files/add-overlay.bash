eselect repository add {{ custom_ebuild_repository.name }} git {{ custom_ebuild_repository.url }}
emerge --sync {{ custom_ebuild_repository.name }}
