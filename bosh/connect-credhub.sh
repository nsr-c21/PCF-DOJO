#!

source ../common/global-variables.sh

credhub login \
	--client-name=credhub-admin \
	--client-secret=`bosh int ${GIT_ROOT_FOLDER}/bosh/creds.yml --path /credhub_admin_client_secret` \
	--server=10.0.1.6:8844 \
	--skip-tls-validation
