variable "cwsyn_canary_name" {
  description = "Name to assign to the Canary."
  type        = string
}

variable "aws_tags" {
  description = "Additional tags to apply to this module."
  type        = map(string)
  default     = {}
}

variable "cwsyn_canary_runtime" {
  description = "The runtime to use with this Canary."
  type        = string
  default     = "syn-python-selenium-4.1"
}

variable "cwsyn_canary_lambda_handler" {
  description = "The handler function to use when invoking the Lambda function."
  type        = string
  default     = "lambda.handler"

}

variable "cwsyn_canary_lambda_script_location" {
  description = "The location of the Lambda Function artifact to use - must be a directory. Leave unspecified to use the Function that ships with this module."
  type        = string
  nullable    = true
  default     = null
}

variable "cwsyn_canary_env" {
  description = "The CloudWatch Synthetics Canary environment variables. If using the default Lambda function, specify the URLS as a string-encoded JSON array."
  type        = map(string)
  default = {
    "WEBSITE_URLS" = "[\"google.com\"]"
  }
}

variable "cwsyn_canary_rate" {
  description = "The rate expression to use with the CloudWatch Synthetics Canary."
  type        = string
  default     = "rate(1 minute)"
}
