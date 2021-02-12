resource "aws_iam_role" "iam-role-lambda-data-cleaner" {
  name               = "iam-role-lambda-data-cleaner"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow"
   }
]
}
EOF
}

resource "aws_iam_role_policy" "iam-role-policy-lambda-data-cleaner" {
  name = "iam-role-policy-lambda-data-cleaner"
  role = aws_iam_role.iam-role-lambda-data-cleaner.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
     "Effect": "Allow",
     "Action": "s3:*",
     "Resource": "arn:aws:s3:::*"
   },
   {
     "Effect": "Allow",
     "Action": [
        "sts:AssumeRole",
        "firehose:Describe*",
        "firehose:List*"
      ],
      "Resource": "arn:aws:firehose:::*"
   }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda-data-cleaner" {
  filename         = "lambda_data_cleaner.zip"
  function_name    = "lambda-data-cleaner"
  role             = aws_iam_role.iam-role-lambda-data-cleaner.arn
  handler          = "data_cleaner.lambda_handler"
  source_code_hash = filebase64sha256("lambda_data_cleaner.zip")
  runtime          = "python3.8"
}