# Deploy AWS services

AWS services are used for usage monitoring.

AWS management user is operator@futel.net

## Topic and queue:
- create SNS topic "asterisk-prod-events" for asterisk manager events
- (note ARN)
- create SQS queue "asterisk-prod-events" for asterisk manager events
- add permisison to queue: "allow everybody sendMessage condition arnEquals key aws:sourceArn value <SNS topic ARN>"
- subscribe SQS queue to SNS topic

## User and policy:
- create AWS user "asteriskmanager" in IAM ("Identity and Access Management")
- create access key for AWS user
- (note ID)
- create AWS policy which allows writing to SNS topic (or use AmazonSNSFullAccess)
- (note ID)
- attach AWS policy to AWS user
- create AWS policy which allows reading from SQS queues (or use AmazonSQSFullAccess)
- (note ID)
- attach AWS policy to AWS user

- add credentials to eventlistenerconf.py in asteriskserver conf:

- aws_arn: <SNS topic ARN>
- (SNS topic region aws_region_name is "us-west-2", defined in eventlistener.py)
- aws_access_key_id: <ID of AWS user access key>
- aws_secret_access_key: <value of AWS user access key>

## Test AWS services

view asterisk-prod-events SNS topic
- assert that there is an SNS subscription
-  subscribe with email using "Create Subscription" and confirm that messages are received

view asterisk-prod-events SQS queue
- assert that NumberOfMessagesReceived increases after message-causing event happens
- assert that ApproximateNumberOfMessagesVisible is small
- assert that ApproximateAgeOfOldestMessage is small

view "View/Delete Messages" under "Queue Actions" dropdown and confirm that messages are received (note that this prevents legitimate recipients)
