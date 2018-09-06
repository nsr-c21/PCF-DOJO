#! /bin/bash

bosh create-env bosh-deployment/bosh.yml \
  --state=state.json \
  --vars-store=creds.yml \
  -o bosh-deployment/gcp/cpi.yml \
  -o bosh-deployment/uaa.yml \
  -o bosh-deployment/jumpbox-user.yml \
  -o bosh-deployment/credhub.yml \
  -o bosh-deployment/openstack/trusted-certs.yml \
  -v director_name=control-plane-bosh \
  -v internal_cidr=10.0.1.0/24 \
  -v internal_gw=10.0.1.1 \
  -v internal_ip=10.0.1.6 \
  --var-file gcp_credentials_json=gcp-service-account-bosh.json \
  -v project_id=cinemaxxi-pcf-control-plane \
  -v zone=asia-southeast1-a \
  -v tags=[bosh] \
  -v network=vpc-pcf-control-plane \
  -v subnetwork=control-plane \
  --var-file=openstack_ca_cert=./ca.crt
