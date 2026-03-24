
resource "aws_db_subnet_group" "default" {
  name       = "${var.prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-db-subnet-group"
    }
  )
}

resource "aws_db_instance" "default" {
  for_each = { for db in var.dbs_config : db.name => db }

  identifier                  = "${each.value.name}-db"
  allocated_storage           = each.value.storage
  db_name                     = "${each.value.name}db"
  engine                      = each.value.engine
  engine_version              = each.value.version
  instance_class              = each.value.instance_class
  manage_master_user_password = true
  username                    = each.value.username
  skip_final_snapshot         = true

  db_subnet_group_name = aws_db_subnet_group.default.name

  tags = merge(
    var.tags,
    {
      Name = "${each.value.name}-db"
    }
  )
}
