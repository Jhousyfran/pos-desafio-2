resource "aws_ecr_repository" "ecr_repo" {

  for_each = toset(var.repos)

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  tags = merge(
    var.tags,
    {
      Name = "${each.value}"
    }
  )
  force_delete = true
}
