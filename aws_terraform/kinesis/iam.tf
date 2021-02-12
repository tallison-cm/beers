resource "aws_iam_role" "firehose-raw-stream-role" {
  name = "firehose-raw-stream-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "firehose.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "firehose-raw-stream-policy" {
  name = "firehose-raw-stream-policy"
  role = aws_iam_role.firehose-raw-stream-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
       {
            "Effect": "Allow",
            "Action": "kinesis:*",
            "Resource": "*"
        },

	    {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
              "arn:aws:s3:::tallison-beers-raw-data",
              "arn:aws:s3:::tallison-beers-raw-data/*"
            ]
      }
    ]
}
EOF
}

resource "aws_iam_role" "firehose-clean-stream-role" {
  name = "firehose-clean-stream-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "firehose.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_role_policy" "firehose-clean-stream-policy" {
  name = "firehose-clean-stream-policy"
  role = aws_iam_role.firehose-clean-stream-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
          "Effect": "Allow",
          "Action": "kinesis:*",
          "Resource": "*"
      },
      {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
              "arn:aws:s3:::tallison-beers-clean-data",
              "arn:aws:s3:::tallison-beers-clean-data/*"
            ]
      },
      {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:GetFunctionConfiguration"
            ],
            "Resource": "${aws_lambda_function.lambda-data-cleaner.arn}"
        }
    ]
}
EOF
}


resource "aws_iam_role" "iam-role-crawler" {
  name               = "iam-role-crawler"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "glue.amazonaws.com"
     },
     "Effect": "Allow"
   }
]
}
EOF
}

resource "aws_iam_role_policy" "iam-role-policy-crawler" {
  name = "iam-role-policy-crawler"
  role = aws_iam_role.iam-role-crawler.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": "*"
      },
      {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
              "arn:aws:s3:::tallison-beers-clean-data",
              "arn:aws:s3:::tallison-beers-clean-data/*"
            ]
      },
      {
            "Effect": "Allow",
            "Action": [
                "glue:*",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:GetBucketAcl",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeRouteTables",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "iam:ListRolePolicies",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "cloudwatch:PutMetricData"
            ],
            "Resource": [
              "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:/aws-glue/*"
            ]
        }
    ]
}
EOF
}