module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.server_name

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.bootcamp_keypair.key_name
  monitoring             = var.monitoring
  vpc_security_group_ids = [module.jenkins_server_sg.security_group_id]
  subnet_id              = data.aws_subnet.bootcamp_public_sub_2a.id

  user_data = file("./dependencias.sh")

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = local.tags
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.jenkins_role.name
}

resource "aws_eip" "jenkins-ip" {
  instance = module.ec2_instance.id
  vpc      = true

  tags = merge(
    local.eip_tags,
    local.tags
  )
}