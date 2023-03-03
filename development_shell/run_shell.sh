#!/bin/bash

if [ -z "$1" ]
then
  echo "you must provide VERSION variable, latest works"
  exit 1
fi

docker run -it --rm --name awsv2-tf_1_3_0 \
    --volume ~/SourceCode/Personal_Projs/aws-bootstrap-backend/terraform:/terraform \
    ubu20_04-tf1_3_0-awscli_v2:$1