terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-for-my-app"
    key = "anacounts/my_new_env"
    region = "eu-west-3"
    encrypt = true
  }
}
