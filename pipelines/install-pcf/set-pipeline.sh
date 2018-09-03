#! /bin/bash

# usage
# ./set-pipeline.sh pcf-dev|pcf-prod

# parameters
pcf_env=$1

if [ -z "$pcf_env" ] || [[ ! ($pcf_env = "pcf-dev" || $pcf_env = "pcf-prod") ]]; then
  echo "usage ./set-pipeline.sh pcf-dev|pcf-prod"
  exit 1
fi

if [ $pcf_env = "pcf-dev" ]; then
  fly -t c21-$pcf_env set-pipeline \
      -p install-pcf \
      -c <(cat ../vendor/pcf-pipelines/install-pcf/gcp/pipeline.yml | \
	   yaml-patch -o ../ops-files/pcf-pipelines-version.yml \
		      -o ops-files/upload-ert-disable-trigger.yml \
		      -o ops-files/upload-ert-small-footprint-pas.yaml) \
      -l params-$pcf_env.yml
else
  fly -t c21-$pcf_env set-pipeline \
      -p install-pcf \
      -c <(cat ../vendor/pcf-pipelines/install-pcf/gcp/pipeline.yml | \
           yaml-patch -o ../ops-files/pcf-pipelines-version.yml) \
      -l params-$pcf_env.yml
fi

