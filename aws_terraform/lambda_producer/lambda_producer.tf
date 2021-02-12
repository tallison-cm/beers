resource "aws_iam_role" "iam-role-lambda-producer" {
  name               = "iam-role-lambda-producer"
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

resource "aws_iam_role_policy" "iam-role-policy-lambda-producer" {
  name   = "iam-role-policy-lambda-producer"
  role   = aws_iam_role.iam-role-lambda-producer.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
       {
     "Effect": "Allow",
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": [
       "arn:aws:logs:*:*:*"
     ]
   }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda-producer" {
  filename         = "lambda_producer.zip"
  function_name    = "lambda-producer"
  role             = aws_iam_role.iam-role-lambda-producer.arn
  handler          = "producer.lambda_handler"
  source_code_hash = filebase64sha256("lambda_producer.zip")
  runtime          = "python3.8"
}