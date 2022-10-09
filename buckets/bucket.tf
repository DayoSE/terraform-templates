resource "aws_s3_bucket" "state_terraform_s3" {
  bucket = "state-terraform-s3"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    yor_trace = "e58a1700-3d62-44cd-9663-f9f36603b093"
  }
}

resource "aws_s3_bucket_public_access_block" "state_terraform_s3" {
  bucket                  = aws_s3_bucket.state_terraform_s3.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# allow some users only
data "aws_iam_policy_document" "state_terraform_s3" {

  statement {
    sid    = "BlockUserAccessWhoIsNotListedHere"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*",
    ]
    resources = [
      "${aws_s3_bucket.state_terraform_s3.arn}",
      "${aws_s3_bucket.state_terraform_s3.arn}/*",
    ]
    condition {
      test     = "StringNotLike"
      variable = "aws:userId"

      values = [
        var.user_test,
        var.user_root,

      ]
    }
  }

}

resource "aws_s3_bucket_policy" "state_terraform_s3" {
  bucket = aws_s3_bucket.state_terraform_s3.id
  policy = "${data.aws_iam_policy_document.state_terraform_s3.json}"
}