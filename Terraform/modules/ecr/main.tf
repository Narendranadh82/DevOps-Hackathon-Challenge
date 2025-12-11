resource "aws_ecr_repository" "repo" {
  name = "${var.env}-${var.name}"

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge({ Environment = var.env }, var.tags)
}

output "repository_url" {
  value = aws_ecr_repository.repo.repository_url
}
