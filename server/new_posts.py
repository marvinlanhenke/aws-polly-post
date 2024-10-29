import os
import uuid

import boto3

dynamodb = boto3.client("dynamodb")
sns = boto3.client("sns")


def lambda_handler(event, context):
    record_id = str(uuid.uuid4())
    voice = event.get("voice")
    text = event.get("text")

    if not voice or not text:
        return {
            "statusCode": 400,
            "error": "You must provide a valid 'voice' and 'text'",
        }

    print(
        f"creating new DynamoDB record with ID: {record_id}, text: {text}, voice: {voice}"
    )

    try:
        dynamodb.put_item(
            TableName=os.environ["DB_TABLE_NAME"],
            Item={
                "id": {"S": record_id},
                "text": {"S": text},
                "voice": {"S": voice},
                "status": {"S": "PROCESSING"},
            },
        )

        sns.publish(TopicArn=os.environ["SNS_TOPIC_ARN"], Message=record_id)

        return {
            "statusCode": 200,
            "body": {"message": "Successfully created a new post", "id": record_id},
        }
    except Exception as e:
        print(e)
        return {"statusCode": 500, "error": "InternalServerError"}
