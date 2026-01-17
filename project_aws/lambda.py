import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name='ap-northeast-2')
    instance_id = os.environ['INSTANCE_ID']
    action = event.get('action')

    if action == 'start':
        ec2.start_instances(InstanceIds=[instance_id])
    elif action == 'stop':
        ec2.stop_instances(InstanceIds=[instance_id])
    else:
        return {'status': 'Invalid action'}

    return {'status': f'{action} executed'}
