resource "aws_s3_bucket" "canary_bucket" {
  bucket_prefix = "cwsyn-canary-${var.cwsyn_canary_name}"
  tags          = var.aws_tags
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "canary_bucket_versioning" {
  bucket = aws_s3_bucket.canary_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "canary_bucket_lifecycle" {
  bucket = aws_s3_bucket.canary_bucket.id
  rule {
    id = "stale-data"
    filter {}
    expiration {
      days = 30
    }
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
    status = "Enabled"
  }
}

resource "aws_s3_object" "canary_script_object" {
  source = data.archive_file.lambda.output_path
  bucket = aws_s3_bucket.canary_bucket.id
  key    = "lambda.zip"
  tags   = var.aws_tags
}


resource "aws_iam_policy" "canary_role_inline_policy" {
  name_prefix = "cwsyn-canary-${var.cwsyn_canary_name}-inline-policy"
  policy      = data.aws_iam_policy_document.canary_role_inline_policy.json
  description = "Specific permissions that are granted to the Synthetics Canary Lambda function."
  tags        = var.aws_tags
}

resource "aws_iam_role" "canary_role" {
  name_prefix        = "cwsyn-canary-${var.cwsyn_canary_name}-role"
  description        = "IAM rule that is used by CloudWatch Synthetics Canaries"
  assume_role_policy = data.aws_iam_policy_document.canary_role_trust_policy.json
  tags               = var.aws_tags
}

resource "aws_iam_role_policy_attachment" "canary_role_inline_policy" {
  policy_arn = aws_iam_policy.canary_role_inline_policy.arn
  role       = aws_iam_role.canary_role.name
}

resource "aws_synthetics_canary" "canary" {
  name                 = "cwsyn-canary-${var.cwsyn_canary_name}"
  artifact_s3_location = "s3://${aws_s3_bucket.canary_bucket.id}"
  runtime_version      = var.cwsyn_canary_runtime
  execution_role_arn   = aws_iam_role.canary_role.arn
  s3_bucket            = aws_s3_bucket.canary_bucket.id
  s3_key               = aws_s3_object.canary_script_object.key
  s3_version           = aws_s3_object.canary_script_object.version_id
  start_canary         = true
  handler              = var.cwsyn_canary_lambda_handler
  delete_lambda        = true
  tags                 = var.aws_tags
  schedule {
    expression = var.cwsyn_canary_name
  }
  run_config {
    environment_variables = var.cwsyn_canary_env
  }
}

resource "null_resource" "cleanup" {
  depends_on = [aws_s3_object.canary_script_object]
  triggers = {
    "always" = timestamp()
  }
  provisioner "local-exec" {
    command = "rm -rf ${data.archive_file.lambda.output_path}"
  }
}
