import boto3
import os
from time import time


def handler(event, context):
    client = boto3.client('cloudfront')
    cloudfront_id = os.environ.get('cloudfront_id')
    records = event.get("Records", [])
    keys = get_keys(records)
    response = client.create_invalidation(
        DistributionId=cloudfront_id,
        InvalidationBatch={
            'Paths': {
                'Quantity': len(keys),
                'Items': keys,
            },
            'CallerReference': str(time()).replace(".", "")
        }
    )
    print(response)


def get_keys(records):
    keys = []
    for record in records:
        try:
            key = record['s3']['object']['key']
            keys.append('/{}'.format(key))
        except KeyError:
            pass
    return keys
