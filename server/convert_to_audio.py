import os
from contextlib import closing

import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")

polly = boto3.client("polly")

s3 = boto3.client("s3")


def create_chunks(text):
    rest = text
    chunks = []
    while len(rest) > 2600:
        begin = 0
        end = rest.find(".", 2500)

        if end == -1:
            end = rest.find(" ", 2500)

        chunk = rest[begin:end]
        rest = rest[end:]
        chunks.append(chunk)
    chunks.append(rest)

    return chunks


def lambda_handler(event, context):
    try:
        record_id = event["Records"][0]["Sns"]["Message"]

        print(f"handling text-to-speech for recordId: {record_id}")

        table_name = os.environ["DB_TABLE_NAME"]
        table = dynamodb.Table(table_name)  # type:ignore

        item = table.query(KeyConditionExpression=Key("id").eq(record_id))

        text = item["Items"][0]["text"]
        voice = item["Items"][0]["voice"]

        for chunk in create_chunks(text):
            response = polly.synthesize_speech(
                OutputFormat="mp3",
                Text=chunk,
                VoiceId=voice,
            )

            if "AudioStream" in response:
                with closing(response["AudioStream"]) as stream:
                    output = os.path.join("/tmp/", record_id)
                    mode = "ab" if os.path.isfile(output) else "wb"
                    with open(output, mode) as f:
                        f.write(stream.read())

        bucket_name = os.environ["BUCKET_NAME"]
        s3.upload_file(f"/tmp/{record_id}", bucket_name, f"{record_id}.mp3")

        url = f"https://{bucket_name}.s3.eu-central-1.amazonaws.com/{record_id}.mp3"

        table.update_item(
            TableName=table_name,
            Key={"id": record_id},
            UpdateExpression="SET #statusAttr = :statusValue, #urlAttr = :urlValue",
            ExpressionAttributeValues={":statusValue": "UPDATED", ":urlValue": url},
            ExpressionAttributeNames={"#statusAttr": "status", "#urlAttr": "url"},
        )

        return {
            "statusCode": 200,
            "body": {
                "message": "Successfully converted text-to-speech",
                "recordId": record_id,
                "url": url,
            },
        }
    except Exception as e:
        print(e)
        return {"statusCode": 500, "error": "InternalServerError"}
