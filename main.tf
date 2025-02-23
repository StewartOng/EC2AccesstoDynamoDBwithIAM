
module "dynamoDB" {
 source = "./module/dynamoDB"
 }


### Step 1 Create IAM role
resource "aws_iam_role" "stewart2-6-tf_dynamodbreadonlyrole" {
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


### Step 2 Create instance profile using role
resource "aws_iam_instance_profile" "stewart2-6-DynamoDBInstanceProfile" {
  name = "stewart2-6-DynamoDBInstanceProfile"
  role = "${aws_iam_role.stewart2-6-tf_dynamodbreadonlyrole.name}"
}

### Step 3 Create IAM policy to give full access to DynamoDB
resource "aws_iam_policy" "stewart2-6-tf-DynamoDBReadSpecificPolicy" {
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



### Step 4 : Create EC2 instance and attach IAM role
resource "aws_instance" "stewart2_6_ec2_instance" {
  ami                  = "ami-05b10e08d247fb927"  # Replace with your desired AMI ID
  instance_type        = "t2.micro"               # Replace with your preferred instance type
  iam_instance_profile = aws_iam_instance_profile.stewart2-6-DynamoDBInstanceProfile.name
  security_groups      = [aws_security_group.stewart2_6_sg.name]  # Security group to control access to the EC2 instance

  # Optionally, specify a subnet ID if you're using a specific VPC and subnet
  subnet_id            = "subnet-xxxxxx"  # Replace with your subnet ID

  # Optional: Assign public IP if needed
  associate_public_ip_address = true

  # Tags for the EC2 instance
  tags = {
    Name = "stewart2-6-EC2-instance"
  }
}

# Create a Security Group for EC2 Instance
resource "aws_security_group" "stewart2_6_sg" {
  name        = "stewart2-6-sg"
  description = "Allow SSH access to EC2 instance"

  # Inbound rule to allow SSH (port 22) from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP
  }

  # Outbound rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}