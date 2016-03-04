#!/bin/sh
set -eu

APP_NAME=swifton-example-
UPPER_ENV_NAME=$(echo $ENV_NAME | awk '{print toupper($0)}')
CLUSTER="${APP_NAME}${ENV_NAME}"
TASK_FAMILY="${APP_NAME}${ENV_NAME}"
SERVICE_NAME="${APP_NAME}service-${ENV_NAME}"
LOADBALANCER_NAME="${APP_NAME}${ENV_NAME}"
CONTAINER_PORT=8000

CONTAINER_NAME=$CONTAINER_NAME CONTAINER_PORT=$CONTAINER_PORT APP_NAME=$APP_NAME \
erb ecs-task-definitions/service.json.erb > .ecs-task-definition.json
TASK_DEFINITION_JSON=$(aws ecs register-task-definition --family $TASK_FAMILY --cli-input-json "file://$(pwd)/.ecs-task-definition.json")
TASK_REVISION=$(echo $TASK_DEFINITION_JSON | jq .taskDefinition.revision)
SERVICE_JSON=$(aws ecs describe-services --services $SERVICE_NAME --cluster $CLUSTER)
if [ $(echo $SERVICE_JSON | jq '.services | length') = "0" ]; then
  SERVICE_JSON=$(aws ecs create-service --cluster ${CLUSTER} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count 1 --load-balancers loadBalancerName=${LOADBALANCER_NAME},containerName=${CONTAINER_NAME},containerPort=${CONTAINER_PORT} --role ecs-operation)
else
  DESIRED_COUNT=$(echo $SERVICE_JSON | jq '.services[0].desiredCount')
  if [ ${DESIRED_COUNT} = "0" ]; then
      DESIRED_COUNT="1"
  fi
  SERVICE_JSON=$(aws ecs update-service --cluster ${CLUSTER} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count ${DESIRED_COUNT})
fi
echo $SERVICE_JSON | jq .
