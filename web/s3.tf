resource "aws_s3_bucket" "public" {

  bucket = "dawn-web-static-files"

  tags = {

    Name = "public-web"
  }
  acl = "private"

}


resource "aws_s3_bucket_object" "files" {

  bucket = aws_s3_bucket.public.id

  key = "jpeg/winetour.jpg"


  acl = "private" # or can be "public-read"

  source = "jpeg/winetour.jpg"

  etag = filemd5("jpeg/winetour.jpg")

}

resource "aws_s3_bucket_public_access_block" "public-web-access" {
  bucket              = aws_s3_bucket.public.id
  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "files-policy" {
  bucket = aws_s3_bucket.public.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy =<<POLICY
  {
   "Version": "2012-10-17",
   "Id": "PublicRead",
   "Statement": [
    {
       "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Principal": { "AWS": "arn:aws:iam::345339357186:role/ADFS-EnterpriseAdmin"},
        "Action": [
           "s3:GetObject",
           "s3:PutBucketPolicy"
        ],
         "Resource": [
        "${aws_s3_bucket.public.arn}",
        "${aws_s3_bucket.public.arn}/*"
      ]

    }
  ]
  }
POLICY
}
