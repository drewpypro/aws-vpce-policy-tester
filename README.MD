# AWS-VPCE-Policy-Tester

# Summary
    - Creates vpc, vpc-endpoints, vpc-endpoint policy (based on an option selected), iam policy and an ec2 that runs aws commands to determine vpc-endpoint policy. 
    - 


1. IAM policy applied to host is unrestricted to ensure that denies are explicitly vpc-endpoint related. 
2. Commands are in some cases invalid, as evident by vpc-endpoint policy deny, we can tell that the commands are first denied in option5, but then allowed in other options. 
    - This doesn't necessarily mean each specific aws command will work through the endpoint. 
    - Further cross-account testing is required. 
3. 

TO DO:
-Add account variables to aws_commands.json
-create csv report output based on time/date.
-auto-run after 15 minutes of startup
-investigate weird tpl interpolation of policy. 
-ReadMe
-create s3 private endpoint testing
-generate report output in s3
-create resources to complete commands
-wait between commands

## Issues with these commands working in deny tests
    ```
    monitoring
        "aws cloudwatch list-tags-for-resource --resource-arn bogus-resource-arn", // Requires building cloudwatch resources?
        // "aws cloudwatch get-metric-data --metric-data-queries bogus-query" // Requires building cloudwatch resources?
    logs
        // "aws logs list-tags-for-resource --resource-arn bogus-log-arn", // Requires building cloudtrail resources?
    rds
        // "aws rds list-tags-for-resource --resource-name bogus-db-instance", 
    s3
        // "aws s3 rb s3://bogus-bucket", remove_bucket failed: s3://test An error occurred (AccessDenied) when calling the DeleteBucket operation: Access Denied
        // "aws s3api get-object --bucket bogus-bucket --key bogus-key /tmp/bogus-file",
        // "aws s3api put-object --bucket bogus-bucket --key bogus-key --body /tmp/bogus-file"
    ```

## These commands are working, but the delete commands aren't. 
    ```
    "aws autoscaling create-auto-scaling-group --auto-scaling-group-name bogus-asg --launch-configuration-name invalid-config --min-size 1 --max-size 1"
    "aws autoscaling create-auto-scaling-group --auto-scaling-group-name bogus-asg --launch-configuration-name --invalid-config foo ",
    "aws dms create-endpoint --endpoint-identifier bogus-endpoint --invalid-config foo", 
    "aws secretsmanager create-secret --name bogus-secret --secret-string bogus-string --invalid-config foo",
    ```