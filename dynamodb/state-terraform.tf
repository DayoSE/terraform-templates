resource "aws_dynamodb_table" "terraform-state-lock" {
  name           = "state-terraform"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    yor_trace = "6bc738c3-0472-4efc-8a0e-76ea70ee4db1"
  }
}