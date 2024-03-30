import boto3
import os
import json
import re


'''
Function to manage table parameters in dynamodb
@createdBy Ronny Yepez
'''
def lambda_handler(event, context):
  print('Method: ', event['httpMethod'])