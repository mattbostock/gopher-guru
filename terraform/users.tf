resource "aws_iam_user" "mattbostock_user" {
  name = "mattbostock"
}

resource "aws_iam_policy" "admin_policy" {
  name = "admin-policy"
  description = "Admin policy: full access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "admin_attachment" {
  name = "admin_policy"
  users = ["mattbostock"]
  policy_arn = "${aws_iam_policy.admin_policy.arn}"
}
