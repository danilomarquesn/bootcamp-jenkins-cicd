module "jenkins_access_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "jenkins_server_policy"
  path        = "/"
  description = "Ec2 and S3 full access policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "FullAccessS3",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "FullAccessEc2",
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF

  tags = local.tags

}
