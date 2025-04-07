terraform {
  backend "s3" {
    bucket = "ramfirstbuck762863.k8s.local"
    key = "Bhargav/terraform.tfstate"
    region= "us-east-1"
  }
}