import os
import uuid
import json

import boto3
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
sns = boto3.client("sns")


def lambda_handler(event, context):
    record_id = str(uuid.uuid4())

    body = json.loads(event["body"])
    voice = body.get("voice")
    text = body.get("text")

    if not voice or not text:
        return {
            "statusCode": 400,
            "headers": {"Access-Control-Allow-Origin": "*"},
            "body": json.dumps({
                "message": "You must provide a valid 'voice' and 'text'"
            }),
        }

    print(
        f"creating new DynamoDB record with ID: {record_id}, text: {text}, voice: {voice}"
    )

    try:
        # TODO: use resource api
        createdAt = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        table = dynamodb.Table(os.environ["DB_TABLE_NAME"])  # type: ignore
        table.put_item(
            Item={
                "id": record_id,
                "text": text,
                "voice": voice,
                "status": "PROCESSING",
                "createdAt": createdAt,
            },
        )

        sns.publish(TopicArn=os.environ["SNS_TOPIC_ARN"], Message=record_id)

        return {
            "statusCode": 201,
            "headers": {"Access-Control-Allow-Origin": "*"},
            "body": json.dumps({
                "message": "Successfully created a new post",
                "id": record_id,
            }),
        }
    except Exception as e:
        print(e)
        return {
            "statusCode": 500,
            "headers": {"Access-Control-Allow-Origin": "*"},
            "body": json.dumps({"message": "InternalServerError"}),
        }
