import json
import os

import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")


def lambda_handler(event, context):
    params = event["queryStringParameters"]
    record_id = params.get("recordId") if params else None

    print(f"retrieving items for recordId: {record_id}")

    table = dynamodb.Table(os.environ["DB_TABLE_NAME"])  # type: ignore

    if not record_id:
        items = table.scan()
    else:
        items = table.query(KeyConditionExpression=Key("id").eq(record_id))

    return {
        "statusCode": 200,
        "headers": {"Access-Control-Allow-Origin": "*"},
        "body": json.dumps({
            "message": "Successfully retrieved items",
            "recordId": record_id,
            "items": items["Items"],
        }),
    }
