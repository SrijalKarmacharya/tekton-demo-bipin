terraform {
  backend "s3" {
    bucket = "myname-is-bipn-pandey-surbhi"
    key    = "bipin-eks1/terraform.tfstate"
    region = "us-east-2"
  }
}
