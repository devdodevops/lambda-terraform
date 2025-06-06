import json
import boto3
import os
from datetime import datetime, timedelta
import time

client = boto3.client('logs')

def lambda_handler(event, context):
    destination_bucket = os.environ['DESTINATION_BUCKET']
    prefix = os.environ['PREFIX']
    
    # Access the environment variable
    group_name_list_str = os.environ.get('GROUP_NAME', '')
    
    # Split the string into a list
    group_name_list = group_name_list_str.split(',')
    
    # Calculate the date 29 days ago from today
    date_29_days_ago = datetime.now() - timedelta(days=29)

    # Get the start of that day (midnight)
    start_of_day = date_29_days_ago.replace(hour=0, minute=0, second=0, microsecond=0)
    
    # Get the end of that day (last moment of the day)
    end_of_day = date_29_days_ago.replace(hour=23, minute=59, second=59, microsecond=999999)

    """
    Convert the from & to Dates to milliseconds
    """
    from_date = int(start_of_day.timestamp() * 1000)
    to_date = int(end_of_day.timestamp() * 1000)
    
    for group_name in group_name_list:
        print("LogGroupName is: ", group_name)
        print("destination is: ", destination_bucket)
        """
        The following will create the subfolders' structure based on year, month, day
        Ex: BucketNAME/LogGroupName/LogStreamName/Year/Month/Day
        """
        bucket_prefix = os.path.join(prefix,group_name, start_of_day.strftime('%Y{0}%m{0}%d').format(os.path.sep))
        response = client.create_export_task(
            taskName='export-logs-to-s3-{from_date}-{group_name}',
            logGroupName=group_name,
            fromTime=from_date,
            to=to_date,
            destination=destination_bucket,
            destinationPrefix=bucket_prefix)
         # Print response for debugging purposes
        time.sleep(120)
        print(response)
    
    
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('CloudWatch logs exported to S3 successfully!')
    }
