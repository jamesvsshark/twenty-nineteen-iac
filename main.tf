provider "aws" {
  region     = "us-east-1"
}

# our s3 bucket to store our TF state file remotely
resource "aws_s3_bucket" "iac_state" {
  bucket = "twenty-nineteen-iac"
}

terraform {
  backend "s3" {
    bucket = "twenty-nineteen-iac"
    key    = "state/master/terraform.tfstate"
    region = "us-east-1"
  }
}

# our s3 bucket which will serve our static web app
resource "aws_s3_bucket" "twenty_nineteen_web_app" {
  bucket = "app.twentynineteen.me"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

module "wordpress" {
  source = "./modules/startup_wordpress"
  name   = "twenty-nineteen-wordpress"
}
