#! /usr/bin/bash

#Test Arguments
API_URL=https://clover-partner-qa.lendingfront.com/applications?status=DECLINED&view_type=team
PORTAL=pp
TEST_NAME=test
TEST_ENV=qa
USERS=1
API_TIMEOUT=10000
TEST_SUITE=$1
LOGS=$2
TOKEN=eyJhbGciOiJIUzI1NiIsImV4cCI6ODc5OTEyMTYxMDMsImlhdCI6MTU5MTMwMjUwM30.eyJmaXJzdF9uYW1lIjoiZWwgcGFydG5lciIsInVzZXJfaWQiOjI5MjAsImNsaWVudF9pZCI6MjAsImNoYW5nZV9wYXNzd29yZF9mbGFnIjpmYWxzZSwiZXhwaXJhdGlvbl9kYXRlIjoiMDUvMDEvNDc1OCIsImlzb19pZCI6MjE3LCJlbWFpbCI6ImVscGFydG5lcitmZC1xYUBtYWlsaW5hdG9yLmNvbSIsImlzb19jb250YWN0X2lkIjoxNTg1fQ.m5AHEW8b_-PDU2dU4WZgYZRNgaAcNKyBVC8wk-6kyaI

echo "Running as user from portal: ${PORTAL}"

#Output format
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Testing API: ${API_URL}"
LP_TEST_LOOPS=${LP_TEST_LOOPS:-1}
CONT_NAME="$TEST_ENV-$TEST_NAME"


#Test Execution
docker rm -f "$CONT_NAME"
docker run --name "$CONT_NAME" -i \
  -v $(pwd)/..:/home \
  -w /home \
  lendingfront/jmeter:5.0 \
    -n \
    -t $TEST_SUITE \
    -l "logs/$TEST_NAME.jtl" \
    -Jthreads=$USERS \
    -JapiTimeout=$API_TIMEOUT \
    -JapiURL=$API_URL \
    -JauthToken=$TOKEN \
    -Jloops=$LP_TEST_LOOPS 

docker wait $CONT_NAME

CONTAINER_OUTPUT=$(docker logs $CONT_NAME)
docker rm -f $CONT_NAME

ls -l logs/
