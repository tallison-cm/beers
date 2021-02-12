resource "aws_kinesis_firehose_delivery_stream" "firehose-stream-to-lambda-data-cleaner" {
  name        = "firehose-stream-to-lambda-data-cleaner"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.beers-stream.arn
    role_arn           = aws_iam_role.firehose-clean-stream-role.arn
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose-clean-stream-role.arn
    bucket_arn         = aws_s3_bucket.tallison-beers-clean-data.arn
    buffer_size        = 2
    buffer_interval    = 60
    compression_format = "UNCOMPRESSED"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = aws_lambda_function.lambda-data-cleaner.arn
        }
      }
    }

  }
}

resource "aws_s3_bucket" "tallison-beers-clean-data" {
  bucket = "tallison-beers-clean-data"
  acl    = "private"
}

resource "aws_glue_catalog_database" "beers-database" {
  name = "beers-database"
}

resource "aws_glue_crawler" "beers-crawler" {
  database_name = aws_glue_catalog_database.beers-database.name
  name          = "beers"
  role          = aws_iam_role.iam-role-crawler.arn
  schedule      = "cron(0/5 * * * ? *)"

  s3_target {
    path = "s3://${aws_s3_bucket.tallison-beers-clean-data.bucket}"
  }
}