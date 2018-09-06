fly -t c21-pcf-prod set-pipeline \
  -p upgrade-opsmanager \
  -c <(cat ../vendor/pcf-pipelines/upgrade-ops-manager/gcp/pipeline.yml | \
  yaml-patch -o ops-files/schedule-time-prod.yml ) \
  -l params-prod.yml \
  -v iaas_type=google
