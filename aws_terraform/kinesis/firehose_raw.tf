resource "aws_kinesis_firehose_delivery_stream" "firehose-stream-to-s3" {
  name        = "firehose-stream-to-s3"
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.beers-stream.arn
    role_arn           = aws_iam_role.firehose-raw-stream-role.arn
  }

  s3_configuration {
    role_arn           = aws_iam_role.firehose-raw-stream-role.arn
    bucket_arn         = aws_s3_bucket.tallison-beers-raw-data.arn
    buffer_size        = 2
    buffer_interval    = 60
    compression_format = "UNCOMPRESSED"
  }
}

resource "aws_s3_bucket" "tallison-beers-raw-data" {
  bucket = "tallison-beers-raw-data"
  acl    = "private"
}