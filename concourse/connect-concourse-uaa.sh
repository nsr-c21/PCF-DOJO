/workspace/bosh/connect-credhub.sh
uaa_admin_pwd="`bosh int <(credhub get -n /control-plane-bosh/concourse/uaa_admin) --path /value`"
uaac target https://10.0.1.10:8443 --skip-ssl-validation
uaac token client get admin -s ${uaa_admin_pwd}
