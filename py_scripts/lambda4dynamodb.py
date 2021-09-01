import boto3
from boto3.dynamodb.conditions import Key
dynamo_client = boto3.resource('dynamodb')


def update_table(table, pk, column):
    table = dynamo_client.Table(table)
    response = table.update_item(
        Key={pk: 1},
        UpdateExpression='ADD ' + column + ' :incr',
        ExpressionAttributeValues={':incr': 1}
    )

    print(response)


def get_count(table, pk, column):
    table = dynamo_client.Table(table)
    response = table.query(
            KeyConditionExpression=Key(pk).eq(1)
        )
    count = response['Items'][0][column]
    return(count)

def lambda_handler(event, context):
    update_table('crc-table', 'ID', 'visitor_count')
    get_count('crc-table', 'ID', 'visitor_count')



    return {
    'statusCode': 200,
    'headers': { "Access-Control-Allow-Origin": "*" },
    'body': get_count('crc-table', 'ID', 'visitor_count')

    }