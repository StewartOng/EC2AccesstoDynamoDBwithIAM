### Create IAM policy
resource "aws_iam_policy" "dynamodb_read_policy" {
  name        = "stewart2-6-tf-DynamoDBReadSpecificPolicy"
  description = "IAM policy for reading from a specific DynamoDB table"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeImport",
                "dynamodb:ListTables",
                "dynamodb:DescribeContributorInsights",
                "dynamodb:ListTagsOfResource",
                "dynamodb:GetAbacStatus",
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:PartiQLSelect",
                "dynamodb:DescribeTable",
                "dynamodb:GetItem",
                "dynamodb:DescribeContinuousBackups",
                "dynamodb:DescribeExport",
                "dynamodb:ListImports",
                "dynamodb:GetResourcePolicy",
                "dynamodb:DescribeKinesisStreamingDestination",
                "dynamodb:ListExports",
                "dynamodb:DescribeLimits",
                "dynamodb:BatchGetItem",
                "dynamodb:ConditionCheckItem",
                "dynamodb:ListBackups",
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:ListStreams",
                "dynamodb:ListContributorInsights",
                "dynamodb:DescribeGlobalTableSettings",
                "dynamodb:ListGlobalTables",
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeGlobalTable",
                "dynamodb:DescribeReservedCapacity",
                "dynamodb:DescribeBackup",
                "dynamodb:DescribeEndpoints",
                "dynamodb:GetRecords",
                "dynamodb:DescribeTableReplicaAutoScaling"
            ],
            "Resource": [
                "*",
                "arn:aws:dynamodb:us-east-1:255945442255:table/stewart2-6-tf-bookinventory"
            ]
        }
    ]
}
EOF
}


### Create IAM role
resource "aws_iam_role" "dynamodB_role" {
  name = "stewart2-6-tf_dynamodbreadonlyrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "dynamodBrole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}



### Attach IAM policy to IAM role
resource "aws_iam_policy_attachment" "dynamedB_read_policy_attach" {
  name       = "stewart2-6-tf-DynamoDBReadSpecificPolicy_attach"
  roles      = [aws_iam_role.dynamodb_role.name]
  policy_arn = aws_iam_policy.dynamodb_read_policy.arn
}



### Create instance profile using role
resource "aws_iam_instance_profile" "dynamodb_instance_profile" {
  name = "stewart2-6-DynamoDBInstanceProfile"
  role = aws_iam_role.dynamodB_role.name
}



### Create EC2 instance and attach IAM role
resource "aws_instance" "stewart2-6_EC2_instance" {
  instance_type        = "t2.micro"
  ami                  = "ami-05b10e08d247fb927"
  iam_instance_profile = aws_iam_instance_profile.example_profile.name
}




resource "aws_iam_policy" "dynamodb_policy" {
  name        = "EC2-DynamoDB-Policy"
  description = "Policy to allow EC2 access to DynamoDB"
  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "dynamodb:Query"
        Effect    = "Allow"
        Resource  = "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${module.dynamodb.table_name}"
      }
    ]
  })
}






