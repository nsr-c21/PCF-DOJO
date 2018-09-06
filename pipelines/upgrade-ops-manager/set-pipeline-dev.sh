fly -t c21-pcf-dev set-pipeline \
  -p upgrade-opsmanager \
  -c <(cat ../vendor/pcf-pipelines/upgrade-ops-manager/gcp/pipeline.yml | \
  yaml-patch -o ops-files/schedule-time-dev.yml) \
  -l params-dev.yml \
  -v iaas_type=google
