terraform {
  backend "s3" {
    bucket = "bootcamp-myawsbucket-tf-remote-state" # Bucket name
    key    = "bootcamp-infraestructure.tfstate"
    region = "us-east-2"
  }
}
