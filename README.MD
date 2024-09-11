TO DO:
-Add account variables to aws_commands.json
-create csv report output based on time/date.
-auto-run after 15 minutes of startup
-investigate weird tpl interpolation of policy. 
-ReadMe
-create s3 private endpoint testing
-generate report output in s3
-create resources to complete commands


## Issues

    ```
    monitoring
        // "aws cloudwatch list-tags-for-resource --resource-arn bogus-resource-arn",
        // "aws cloudwatch get-metric-data --metric-data-queries bogus-query"
    logs
        // "aws logs list-tags-for-resource --resource-arn bogus-log-arn",
    rds
        // "aws rds list-tags-for-resource --resource-name bogus-db-instance",
    s3
        // "aws s3 rb s3://bogus-bucket", remove_bucket failed: s3://test An error occurred (AccessDenied) when calling the DeleteBucket operation: Access Denied
        // "aws s3api get-object --bucket bogus-bucket --key bogus-key /tmp/bogus-file",
        // "aws s3api put-object --bucket bogus-bucket --key bogus-key --body /tmp/bogus-file"
    sns
        // "aws sns delete-topic --topic-arn arn:aws:sns:us-east-1:898082745236:ExampleTopic", // Need to populate account variable
        // "aws sns publish --topic-arn arn:aws:sns:us-east-1:898082745236:ExampleTopic --message 'Bogus message'"  // Need to populate account variable
    sts

        // "aws sts assume-role --role-arn arn:aws:iam::602484972838:role/ExampleRole --role-session-name bogus-session",
    ```