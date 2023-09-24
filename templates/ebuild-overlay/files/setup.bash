WORK_DIR=$1
cd $WORK_DIR
bash install-deps.bash
bash trust-cert.bash $WORK_DIR
bash add-overlay.bash
bash cleanup.bash $WORK_DIR
