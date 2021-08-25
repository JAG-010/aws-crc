import boto3
dynamo_client = boto3.resource('dynamodb')

def update_table(table, pk, column):
    table = dynamo_client.Table(table)
    response = table.update_item(
        Key={pk: 1},
        UpdateExpression='ADD ' + column + ' :incr',
        ExpressionAttributeValues={':incr': 1}
    )
    # new_counter = table.get_item(
    #     Key={pk: 1}
    # )


    # print(new_counter['Item'][column])
    print(response)
#lol
# if name == 'main':
#     update_table('test_Visitors', 'VisitorCount', 'vc')

def get_count(table, pk, column):
    dynamodb = boto3.resource('dynamodb')
    table = dynamo_client.Table(table)
    response = table.get_item(
            Key={pk: 1}
        )
    count = response['Item'][column]
    return(count)

def lambda_handler(event, context):
    update_table('crc-table', 'ID', 'visitor_count')
    get_count('crc-table', 'ID', 'visitor_count')



    return {
    'statusCode': 200,
    'headers': { "Access-Control-Allow-Origin": "*" },
    'body': get_count('crc-table', 'visitor_num', 'visitor_num')

    }