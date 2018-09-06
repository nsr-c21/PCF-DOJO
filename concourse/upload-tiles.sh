ENV_NAME=$1
PRODUCT_FILE_NAME=$2

if [ -z "$ENV_NAME" ] || [ -z "$PRODUCT_FILE_NAME" ]; then
  echo "Usage ./upload-tiles.sh <Environment Name:dev|prod> <Filename>"
  echo "sample ./upload-tiles.sh dev pivotal-rabbitmq-3.7.7.pivotal"  
  exit 1
fi

./connect-concourse-credhub.sh


if [ $ENV_NAME = "dev" ]; then
  OPSMGR_HOST=opsman.pcf-dev.int.21cineplex.com
  OPSMGR_PASS=$(bosh int <(credhub get -n /concourse/pcf-dev/opsman_admin) --path /value/password)
fi

if [ $ENV_NAME = "prod" ]; then
  OPSMGR_HOST=opsman.pcf.int.21cineplex.com
  OPSMGR_PASS=$(bosh int <(credhub get -n /concourse/pcf-prod/opsman_admin) --path /value/password)
fi

if [ -z "$OPSMGR_HOST" ]; then
  echo "Usage ./upload-tiles.sh <Environment Name:dev|prod> <Filename>"
  exit 0
fi

#OPSMGR_TOKEN=$(bosh int <(cat (curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=${OPSMGR_USER}' -d 'password=${OPSMGR_PASS}' -u 'opsman:' https://${OPSMGR_HOST}/uaa/oauth/token)) --path /access_token)

#curl -s -k -H "Accept: application/json;charset=utf-8" -d "grant_type=password" -d "username=admin" -d "password=${OPSMGR_PASS}" -u "opsman:" https://${OPSMGR_HOST}/uaa/oauth/token

echo "Authenticating to OpsMan $OPSMGR_HOST"

OPSMGR_TOKEN=$(bosh int <(curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=admin' -d password=${OPSMGR_PASS} -u 'opsman:' https://${OPSMGR_HOST}/uaa/oauth/token) --path /access_token)

if [ -z "$OPSMGR_TOKEN" ]; then
  echo "Authentication failed"
  exit 1
fi

echo "Uploading $PRODUCT_FILE_NAME to $OPSMGR_HOST"
curl -vv -H 'Authorization: bearer $OPSMGR_TOKEN' -k -X POST https://${OPSMGR_HOST}/api/v0/available_products -F product[file]=@downloaded-files/$PRODUCT_FILE_NAME -o /dev/null

echo "$PRODUCT_FILE_NAME finished uploading to Ops Manager"
