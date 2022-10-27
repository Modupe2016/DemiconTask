terraform {
  backend "s3" {
    bucket          = "my-first-backupp-bucket"
    key             = "terraform.tfstate"
    region          = "eu-central-1"
    dynamodb_table  = "terraform-state-lock-dynamo"
  }
}