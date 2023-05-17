variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
}

variable "common_tags" {
    type        = map(string)
    description = "Common name for tagging"
}

variable "addName" {
    type        = string
    description = "Common name for tagging"
}