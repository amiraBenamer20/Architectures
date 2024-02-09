# S3 Bucket
resource "aws_s3_bucket" "restaurantapp_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
  
  

  website {
    index_document = "profile.html"  
    error_document = "fac.html"      
  }
}

resource "aws_s3_bucket_public_access_block" "restaurantapp_bucket" {
  bucket = aws_s3_bucket.restaurantapp_bucket.id

  block_public_acls       = false
  block_public_policy     = false #to be able customizing the put policy bucket 
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Ensure the S3 bucket is created before applying the policy
resource "aws_s3_bucket_policy" "restaurantapp_bucket_policy" {
  depends_on = [aws_s3_bucket.restaurantapp_bucket]

  bucket = aws_s3_bucket.restaurantapp_bucket.id

  policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "${aws_s3_bucket.restaurantapp_bucket.arn}/**"            
          ]        
      }    
    ]
}
POLICY
}


# s3 static website url

output "website_url" {
  value = "http://${var.s3_bucket_name}.s3-website-${var.aws_region}.amazonaws.com"#"http://${aws_s3_bucket.restaurantapp_bucket.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}
