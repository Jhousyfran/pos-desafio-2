resource "aws_dynamodb_table" "default" {
  name           = var.dynamodb_table.name
  billing_mode   = var.dynamodb_table.billing_mode
  read_capacity  = var.dynamodb_table.read_capacity
  write_capacity = var.dynamodb_table.write_capacity
  hash_key       = var.dynamodb_table.attribute_definitions[0].name

  dynamic "attribute" {
    for_each = var.dynamodb_table.attribute_definitions
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }


  tags = merge(
    var.tags,
    {
      Name = "${var.dynamodb_table.name}-dynamodb-table"
    }
  )
}
