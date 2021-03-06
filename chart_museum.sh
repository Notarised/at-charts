#!/usr/bin/env bash

CHART_LIST=(hl-composer hlf-ca hlf-couchdb hlf-ord hlf-peer)

for CHART in ${CHART_LIST[*]}
do
    CHART_VERSION=$(cat ./${CHART}/Chart.yaml | grep version | awk '{print $2}')
        echo "Chart version is $CHART_VERSION"
    CHART_MISSING=$(curl https://${CHARTMUSEUM_URL}/api/charts/${CHART}/${CHART_VERSION} --user ${CHARTMUSEUM_USER}:${CHARTMUSEUM_PASS} | grep error)
    if [[ -z "$CHART_MISSING" ]]
    then
        echo "Chart already saved to Chart Museum"
    else
        helm package ./${CHART}
        curl --data-binary "@$CHART-$CHART_VERSION.tgz" https://${CHARTMUSEUM_URL}/api/charts --user ${CHARTMUSEUM_USER}:${CHARTMUSEUM_PASS}
    fi
done
