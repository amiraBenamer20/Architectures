
/*variable "aws_access_key" {
  type        = string
  description = "programmatic access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "programmatic secret key"
  sensitive   = true
}*/

variable "aws_region" {
  type        = string
  description = "region"
  default     = "eu-west-3"
}

variable "s3_bucket_name" {
  type = string
  default = "restaurant123"
}


variable "source_name" {
  type        = list(string)
  description = "default pages"
  default     = ["index.html", "error.html"]
}

variable "lambda1_code_path" {
  description = "get"
  type        = string
  default = "D:\\Cloud Courses\\Devops\\terraform-getting-started-2023\\Getting-Started-Terraform\\Devops2\\Unify-Exercice\\Code\\getEmployee.zip"
}

variable "lambda2_code_path" {
  description = "put"
  type        = string
  default = "D:\\Cloud Courses\\Devops\\terraform-getting-started-2023\\Getting-Started-Terraform\\Devops2\\Unify-Exercice\\Code\\insertEmployeeData.zip"
}
