import boto3
from datetime import datetime
import json
import os

s3 = boto3.client('s3')

def handler(event, context):
    response = s3.put_object(
        Body=json.dumps(event.get('body', {})),
        Bucket=os.environ["S3_BUCKET_NAME"],
        Key=f"{datetime.now().strftime('%Y-%m-%d-%H-%M-%S-%f')}.json"
    )

    return {
        'statusCode' : 200,
        'body': json.dumps(response)
    }
