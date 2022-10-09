resource "aws_iam_instance_profile" "assume-role-ec2" {
  name = "assume-role-ec2"
  role = aws_iam_role.role-ec2.id
  tags = {
    yor_trace = "5956ebd5-949e-47f3-9cd7-09a2a6a9aca9"
  }
}

resource "aws_iam_role" "role-ec2" {
  name = "role-ec2"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      }
    }
  ]
}
EOF

  tags = {
    yor_trace = "8c67d686-75fe-4c2c-a76f-9c77d6af5a66"
  }
}

resource "aws_iam_role_policy" "role-ec2-policy" {
  name = "role-ec2-policy"
  role = aws_iam_role.role-ec2.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowStopStartEc2",
            "Effect": "Allow",
            "Action": [ "ec2:StartInstances", "ec2:StopInstances"],
            "Resource": "arn:aws:ec2:${var.aws_region}:${var.aws_master_account_id}:instance/*",
            "Condition": {
                "StringLike": {
                  "ec2:ResourceTag/Name": "${var.ec2_tag}"
                }
            }
        }
    ]
}
EOF

}
