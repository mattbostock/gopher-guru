resource "aws_iam_role" "lambda_s3_execution_role" {
  name = "lambda_s3_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "runner" {
  function_name = "runner"
  handler = "runner_lambda_shim.main"
  role = "${aws_iam_role.lambda_s3_execution_role.arn}"
  s3_bucket = "${aws_s3_bucket.lambda_code.bucket}"
  s3_key = "runner.zip"

  # FIXME: Remove version once is issue below is fixed:
  # https://github.com/hashicorp/terraform/issues/4931
  #
  # Use a variable as otherwise we'd have to update the version on every code
  # deploy
  s3_object_version = "${var.lambda_s3_object_version}"
}
