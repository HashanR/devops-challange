
############################################################
#                      Cloudwatch                          #
############################################################
resource "aws_iam_role" "cloudwatch_log_role" {
  name = "cloudwatch_log_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "hub88_log_group"
}


resource "aws_iam_policy" "cloudwatch_log_policy" {
  name = "cloudwatch_log_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${var.region}:*:log-group:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_role_policy_attachment" {
  policy_arn = aws_iam_policy.cloudwatch_log_policy.arn
  role       = aws_iam_role.cloudwatch_log_role.name
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.cloudwatch_log_role.name
}
