# *** INPUT DETAILS ***
# PRODUCT_SLUG - part of Pivnet URL for the product https://network.pivotal.io/products/pivotal-mysql/
# PRODUCT_VERSION: Release number available in Pivnet
# PRODUCT_FILE_NAME: Click "i" icon to view product file name

PRODUCT_SLUG=$1
PRODUCT_VERSION=$2
PRODUCT_FILE_NAME=$3

if [ -z "$PRODUCT_SLUG" ] || [ -z "$PRODUCT_VERSION" ]  || [ -z "$PRODUCT_FILE_NAME" ]; then
  echo "Usage ./download-tiles.sh <Product slug> <Product version> <Product file name as in PIVNET>"
  echo "sample ./download-tiles.sh pivotal-mysql \"2.3.0\" \"MySQL for PCF v2\""  
  exit 1
fi

./connect-concourse-credhub.sh

PIVNET_TOKEN=$(bosh int <(credhub get -n /concourse/pcf-dev/pivnet_token) --path /value)

if [ -z "$PIVNET_TOKEN" ]; then
  echo "Pivnet Token is not found, please check the credhub credential or authentication status"
  exit 1
fi

pivnet login --api-token=$PIVNET_TOKEN

RELEASE_NUMBER=$(bosh int <(pivnet r -p $PRODUCT_SLUG -r $PRODUCT_VERSION --format=yaml) --path /id)

if [ -z "$RELEASE_NUMBER" ]; then
  echo "The product release is not found"
  exit 1
fi

echo "Requesting Product details $PRODUCT_SLUG v.$PRODUCT_VERSION"

##Create temp file
tmppipe=$(mktemp -u)

#PRODUCT_YML=$(pivnet curl /products/$PRODUCT_SLUG/releases/$RELEASE_NUMBER --format=yaml)

pivnet curl /products/$PRODUCT_SLUG/releases/$RELEASE_NUMBER --format=yaml > $tmppipe

PRODUCT_URL=$(bosh int $tmppipe --path /product_files/name="$PRODUCT_FILE_NAME"/_links/download/href)

##cleanup
rm $tmppipe

echo "Downloading from  $PRODUCT_URL"
sudo wget -O downloaded-files/$PRODUCT_SLUG-$PRODUCT_VERSION --post-data="" --header="Authorization: Token $PIVNET_TOKEN" $PRODUCT_URL

sudo mv downloaded-files/$PRODUCT_SLUG-$PRODUCT_VERSION downloaded-files/$PRODUCT_SLUG-$PRODUCT_VERSION.pivotal

echo "Download Complete"

#OPSMGR_HOST=opsman.pcf-dev.int.21cineplex.com
#OPSMGR_USER=admin
#OPSMGR_PASS=$(bosh int <(credhub get -n /concourse/pcf-dev/opsman_admin) --path /value/password)

#echo "Authenticating to Opsman"
#OPSMGR_TOKEN=$(bosh int <(curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d 'username=${OPSMGR_USER}' -d 'password=${OPSMGR_PASS}' -u 'opsman:' https://${OPSMGR_HOST}/uaa/oauth/token) --path /access_token)

#if [ -z "$OPSMGR_TOKEN" ]; then
#  echo "Authentication failed"
#  exit 1
#fi

#echo "Uploading $PRODUCT_FILE_NAME to $OPSMGR_HOST"
#curl -vv -H 'Authorization: bearer $OPSMGR_TOKEN' -k -X POST https://${OPSMGR_HOST}/api/v0/available_products -F 'product[file]=@downloaded-files/$PRODUCT_SLUG-$PRODUCT_VERSION.pivotal' -o /dev/null
#curl "https://${OPSMGR_HOST}/api/products" -F "product[file]=@downloaded-files/$PRODUCT_SLUG-$PRODUCT_VERSION.pivotal" -X POST -u ${OPSMGR_USER}:${OPSMGR_PASS} -k -# -o /dev/null

#echo "$PRODUCT_FILE_NAME finished uploading to Ops Manager"
