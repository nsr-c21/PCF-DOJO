/workspace/bosh/connect-credhub.sh
concourse_to_credhub_secret="`credhub get -n /control-plane-bosh/concourse/concourse_to_credhub_secret`"
concourse_to_credhub_secret="`bosh int <(credhub get -n /control-plane-bosh/concourse/concourse_to_credhub_secret) --path /value`"
credhub login \
	--client-name=concourse_to_credhub \
	--client-secret=${concourse_to_credhub_secret} \
	--server=10.0.1.10:8844 \
	--skip-tls-validation
