##################################################################################
# RESOURCES
##################################################################################


module "my_s3_bucket"{
  source = "./module/my-s3"

  bucket_name = "mytestbucket63070088npa15"
  common_tags = local.common_tags
  addName = local.cName
}

resource "aws_s3_bucket_object" "website" {
  bucket = module.my_s3_bucket.web_bucket.id
  key    = "a.jpg"
  source = "./a.jpg"

  tags = local.common_tags
}
