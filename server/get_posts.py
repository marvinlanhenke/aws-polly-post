import os

import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")


def lambda_handler(event, context):
    record_id = event.get("recordId")

    print(f"retrieving items for recordId: {record_id}")

    if not record_id:
        return {"statusCode": 400, "error": "You must provide a valid 'record_id'"}

    table = dynamodb.Table(os.environ["DB_TABLE_NAME"])  # type: ignore

    if record_id == "*":
        items = table.scan()
    else:
        items = table.query(KeyConditionExpression=Key("id").eq(record_id))

    return {
        "statusCode": 200,
        "body": {
            "message": "Successfully retrieved items",
            "recordId": record_id,
            "items": items["Items"],
        },
    }
