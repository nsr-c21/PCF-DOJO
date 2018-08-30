#!

source ../common/global-variables.sh

export BOSH_CLIENT=admin && export BOSH_CLIENT_SECRET=`bosh int ${GIT_ROOT_FOLDER}/bosh/creds.yml --path /admin_password`	

