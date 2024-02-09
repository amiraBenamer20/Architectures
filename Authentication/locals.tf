locals {
  bucket_name = "my-static-website-bucket-${random_integer.s3.result}"
  
}

resource "random_integer" "s3" {
  min = 10000
  max = 99999
}