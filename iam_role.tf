resource "aws_iam_role" "jenkins_role" {
  name               = var.iam_instance_profile
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "FullAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = local.tags

}

resource "aws_iam_role_policy_attachment" "ec2-and-s3-access-policy-attachment" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = module.jenkins_access_policy.arn
}