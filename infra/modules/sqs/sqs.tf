resource "aws_sqs_queue" "default" {
  for_each                  = { for queue in var.queues : queue.name => queue }
  name                      = "${each.value.name}-sqs-queue"
  delay_seconds             = each.value.delay_seconds
  max_message_size          = each.value.max_message_size
  message_retention_seconds = each.value.message_retention_seconds


  tags = merge(
    var.tags,
    {
      Name = "${each.value.name}-sqs-queue"
    }
  )
}
