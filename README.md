<p align="center">
  <a href="https://github.com/terraform-trailwatch-modules" title="Terraform Trailwatch Modules"><img src="https://raw.githubusercontent.com/terraform-trailwatch-modules/art/refs/heads/main/logo.jpg" height="100" alt="Terraform Trailwatch Modules"></a>
</p>

<h1 align="center">Synthetics Canary</h1>

<p align="center">
  <a href="https://github.com/terraform-trailwatch-modules/module_name/releases" title="Releases"><img src="https://img.shields.io/badge/Release-1.0.0-1d1d1d?style=for-the-badge" alt="Releases"></a>
  <a href="https://github.com/terraform-trailwatch-modules/module_name/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-MIT-1d1d1d?style=for-the-badge" alt="License"></a>
</p>

## About
Set up a CloudWatch Synthetics Canary with ease. Creates all resources required to have a functional Canary in no time.

## Features
 - Creates policies, buckets, and the Canary.
 - Configures the bucket with lifecycle polices based on a 30 day data retention policy.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.6.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.74.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.canary_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.canary_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.canary_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.canary_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.canary_bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_versioning.canary_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_object.canary_script_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_synthetics_canary.canary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [null_resource.cleanup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.canary_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.canary_role_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Additional tags to apply to this module. | `map(string)` | `{}` | no |
| <a name="input_cwsyn_canary_env"></a> [cwsyn\_canary\_env](#input\_cwsyn\_canary\_env) | The CloudWatch Synthetics Canary environment variables. If using the default Lambda function, specify the URLS as a string-encoded JSON array. | `map(string)` | <pre>{<br/>  "WEBSITE_URLS": "[\"google.com\"]"<br/>}</pre> | no |
| <a name="input_cwsyn_canary_lambda_handler"></a> [cwsyn\_canary\_lambda\_handler](#input\_cwsyn\_canary\_lambda\_handler) | The handler function to use when invoking the Lambda function. | `string` | `"lambda.handler"` | no |
| <a name="input_cwsyn_canary_lambda_script_location"></a> [cwsyn\_canary\_lambda\_script\_location](#input\_cwsyn\_canary\_lambda\_script\_location) | The location of the Lambda Function artifact to use - must be a directory. Leave unspecified to use the Function that ships with this module. | `string` | `null` | no |
| <a name="input_cwsyn_canary_name"></a> [cwsyn\_canary\_name](#input\_cwsyn\_canary\_name) | Name to assign to the Canary. | `string` | n/a | yes |
| <a name="input_cwsyn_canary_rate"></a> [cwsyn\_canary\_rate](#input\_cwsyn\_canary\_rate) | The rate expression to use with the CloudWatch Synthetics Canary. | `string` | `"rate(1 minute)"` | no |
| <a name="input_cwsyn_canary_runtime"></a> [cwsyn\_canary\_runtime](#input\_cwsyn\_canary\_runtime) | The runtime to use with this Canary. | `string` | `"syn-python-selenium-4.1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Simple Example
```hcl
module "trailwatch_canary" {
  source = "terraform-trailwatch-modules/synthetics-canary/aws"
  cwsyn_canary_name = "website-monitor"
}
```

## Advanced Example
```hcl
module "trailwatch_canary" {
  source = "terraform-trailwatch-modules/synthetics-canary/aws"
  cwsyn_canary_name = "website_monitor"
  cwsyn_canary_runtime = "syn-python-selenium-4.0"
  cwsyn_canary_lambda_handler = "lambda.my_function"
  cwsyn_canary_lambda_script_location = "./path/to/directory"
  cwysn_canary_env = {"A_ENV": "B"}
  cwsyN_canary_rate = "rate(5 minutes)"
  ...
}
```

## Changelog
For a detailed list of changes, please refer to the [CHANGELOG.md](CHANGELOG.md).

## License
This module is licensed under the [MIT License](LICENSE).
