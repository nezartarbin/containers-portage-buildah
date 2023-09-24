WORK_DIR=$1
cd $WORK_DIR
bash install-deps.bash
{% if custom_ebuild_repository.cert_required -%}
bash trust-cert.bash $WORK_DIR
{% endif %}
bash add-overlay.bash
bash cleanup.bash $WORK_DIR
