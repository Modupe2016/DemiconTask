import boto3
import os


S3_BUCKET = os.environ.get('BUCKET_NAME')

s3_client = boto3.client("s3")

def lambda_handler(event, context):
  object_key = "terraform.tfstate"
  file_content = s3_client.get_object(
      Bucket=S3_BUCKET, Key=object_key)["Body"].read().decode()
  print(file_content)
  
  
  
  
  
  
  
  
  
  
