ENV_NAME=$1
TILE_NAME=$2

if [ -z "$ENV_NAME" ] || [[ ! ($ENV_NAME = "dev" || $ENV_NAME = "prod") ]]; then
  echo "usage ./set-pipeline-upgrade-tiles.sh dev|prod mysqlv2|rmq|scs|srt|pas"
  exit 1
fi

if [ -z "$TILE_NAME" ] || [[ ! ($TILE_NAME = "mysqlv2" || $TILE_NAME = "rmq" || $TILE_NAME = "scs"  || $TILE_NAME = "srt" || $TILE_NAME = "pas") ]]; then
  echo "usage ./set-pipeline-upgrade-tiles.sh dev|prod mysqlv2|rmq|scs|srt|pas"
  exit 1
fi

echo "Initiating fly for $ENV_NAME Environment"

#fly -t c21-pcf-$ENV_NAME set-pipeline \
#  -p upgrade-tile-$TILE_NAME \
#  -c ../vendor/pcf-pipelines/upgrade-tile/pipeline.yml \
#  -l params-$ENV_NAME-$TILE_NAME.yml

fly -t c21-pcf-$ENV_NAME set-pipeline \
  -p upgrade-tile-$TILE_NAME \
  -c <(cat ../vendor/pcf-pipelines/upgrade-tile/pipeline.yml | \
  yaml-patch -o ../ops-files/pcf-pipelines-version.yml \
             -o ops-files/schedule-time-$TILE_NAME.yml) \
  -l params-$ENV_NAME-$TILE_NAME.yml
