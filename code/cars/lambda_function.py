import boto3
import os
import json

# Setup DynamoDB connection
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(str(os.environ['DYNAMODB_TABLE']))
responseHeaders = {
  'Content-Type': 'application/json'
}

'''
Function to manage tables in dynamodb
@createdBy Ronny Yepez
'''
def lambda_handler(event, context):
  http_method = event['httpMethod']
  path = event['path'] if 'path' in event else '/'
  print('Method: ', http_method, 'Path', path)

  if path == '/cars':
    if http_method == 'GET':
      params = event['queryStringParameters']
      carId = params.get('carId')
      return read_item(carId, responseHeaders)
    elif http_method == 'POST':
      item = json.loads(event['body'])
      return create_item(item, responseHeaders)

'''
Function to return cars by carId
@createdBy Ronny Yepez
'''
def read_item(carId, responseHeaders):
  try:
    if carId:
      response = table.query(
        KeyConditionExpression='carId = :id',
        ExpressionAttributeValues={
            ':id': carId
        }
      )         
      return {
        'statusCode': 200,
        'headers': responseHeaders,
        'body': json.dumps(response['Items'])
      }
    if not carId:
      return {
        'statusCode': 400,
        'headers': responseHeaders,
        'body': json.dumps({'message': 'Missing car id'})
      }
  except Exception as e:
    return {
      'statusCode': 500,
      'headers': responseHeaders,
      'body': json.dumps(f'Error reading data: {str(e)}')
    }
  
'''
Function to create cars
@createdBy Ronny Yepez
'''
def create_item(item, responseHeaders):
  try:
    table.put_item(Item=item)
    return {
      'statusCode': 200,
      'headers': responseHeaders,
      'body': json.dumps({'message': 'Car created'})
    }
  except Exception as e:
    return {
      'statusCode': 500,
      'headers': responseHeaders,
      'body': json.dumps(f'Error creating item: {str(e)}')
    }