provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-1"
}

resource "aws_instance" "ec2_sample" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"

  tags = {
    Name        = "Sample EC2"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "s3_sample" {
  bucket = "my-tf-sample-bucket"
  acl    = "private"

  tags = {
    Name        = "Sample S3"
    Environment = "Dev"
  }
}
