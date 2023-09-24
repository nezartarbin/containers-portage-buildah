#! /bin/bash
WORK_DIR=$1

mkdir -p /usr/local/share/ca-certificates
mv $WORK_DIR/{{custom_ebuild_repository.certificate_file_name}} /usr/local/share/ca-certificates/{{custom_ebuild_repository.certificate_file_name}}
chmod 733 /usr/local/share/ca-certificates/{{custom_ebuild_repository.certificate_file_name}}

update-ca-certificates
