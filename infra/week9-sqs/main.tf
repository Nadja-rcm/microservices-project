provider "aws" {
  region = var.aws_region
}

resource "aws_sqs_queue" "dlq" {
  name = "${var.prefix}-product-events-dlq"
}

resource "aws_sqs_queue" "main" {
  name                       = "${var.prefix}-product-events-tf"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}

output "product_events_queue_url" {
  value = aws_sqs_queue.main.url
}