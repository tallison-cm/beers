resource "aws_kinesis_stream" "beers-stream" {
  name             = "beers-stream"
  shard_count      = 1
  retention_period = 24
  encryption_type  = "NONE"

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "beers-stream"
  }
}