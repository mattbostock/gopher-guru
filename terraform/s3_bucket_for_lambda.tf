resource "aws_s3_bucket" "lambda_code" {
    bucket = "gopher-guru-lambda"
    acl = "public-read"
    # FIXME: Enabling versioning is a workaround for
    # https://github.com/hashicorp/terraform/issues/4931
    versioning {
      enabled = true
    }
}

# Used by CI to push a build artefact to S3
resource "aws_iam_user" "build_artefact_user" {
  name = "build_artefact_user"
}

resource "aws_iam_policy" "s3_artefact_push_policy" {
  name = "s3_artefact_push_policy"
  description = "Push to S3 bucket"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.lambda_code.bucket}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.lambda_code.bucket}/*"]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "s3_artefact_push_attachment" {
  name = "s3_artefact_push_policy"
  users = ["build_artefact_user"]
  policy_arn = "${aws_iam_policy.s3_artefact_push_policy.arn}"
}
