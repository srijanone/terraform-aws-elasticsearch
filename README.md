![Static security analysis for Terraform](https://github.com/srijanone/terraform-aws-elasticsearch/workflows/Static%20security%20analysis%20for%20Terraform/badge.svg)
 terraform module for AWS Elasticsearch Service
## Examples

Check the [examples](/examples/) folder 
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.7, < 0.14 |
| aws | >= 2.68, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.68, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_policies | (Optional) IAM policy document specifying the access policies for the domain | `string` | `null` | no |
| advanced\_options | (Optional) Key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply. | `map(string)` | `{}` | no |
| advanced\_security\_options | (Optional) Options for fine-grained access control. | `any` | `{}` | no |
| cloudwatch\_log\_group\_arn | (Optional) ARN of the Cloudwatch log group to which log needs to be published. | `string` | `""` | no |
| cloudwatch\_log\_kms\_key\_id | (Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. | `string` | `null` | no |
| cloudwatch\_log\_retention\_in\_days | (Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `0` | no |
| cluster\_config | (Optional) Cluster configuration of the domain | `any` | <pre>{<br>  "dedicated_master_count": 3,<br>  "dedicated_master_enabled": true,<br>  "dedicated_master_type": "r5.large.elasticsearch",<br>  "instance_count": 3,<br>  "instance_type": "r5.large.elasticsearch",<br>  "zone_awareness_enabled": false<br>}</pre> | no |
| cognito\_options | (Optional) Options for Amazon Cognito Authentication for Kibana | `any` | `{}` | no |
| create | Do you want to create ES Cluster | `bool` | `true` | no |
| create\_service\_link\_role | Create service link role for AWS Elasticsearch Service | `bool` | `true` | no |
| domain\_endpoint\_options | (Optional) Domain endpoint HTTP(S) related options. | `any` | <pre>{<br>  "enforce_https": true,<br>  "tls_security_policy": "Policy-Min-TLS-1-2-2019-07"<br>}</pre> | no |
| domain\_name | (Required) Name of the domain. | `string` | n/a | yes |
| ebs\_options | (Optional) EBS related options, may be required based on chosen instance size. | `any` | <pre>{<br>  "ebs_enabled": true,<br>  "volume_size": 20,<br>  "volume_type": "gp2"<br>}</pre> | no |
| elasticsearch\_version | (Optional) The version of Elasticsearch to deploy. Defaults to 1.5 | `string` | `"1.5"` | no |
| encrypt\_at\_rest | Optional) Encrypt at rest options. Only available for certain instance types. | `any` | <pre>{<br>  "enabled": true<br>}</pre> | no |
| log\_publishing\_options | (Optional) Options for publishing slow and application logs to CloudWatch Logs. This block can be declared multiple times, for each log\_type, within the same resource. | `any` | <pre>[<br>  {<br>    "log_type": "INDEX_SLOW_LOGS"<br>  },<br>  {<br>    "log_type": "SEARCH_SLOW_LOGS"<br>  },<br>  {<br>    "log_type": "ES_APPLICATION_LOGS"<br>  }<br>]</pre> | no |
| node\_to\_node\_encryption | (Optional) Node-to-node encryption options. | `any` | <pre>{<br>  "enabled": false<br>}</pre> | no |
| snapshot\_options | (Optional) Snapshot related options | `any` | `{}` | no |
| tags | (Optional) A map of tags to assign to the resource | `map` | `{}` | no |
| timeouts | Timeouts map. | `any` | `{}` | no |
| vpc\_options | (Optional) VPC related options, Adding or removing this configuration forces a new resource | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of the domain |
| domain\_id | Unique identifier for the domain |
| endpoint | Domain-specific endpoint used to submit index, search, and data upload requests |
| kibana\_endpoint | Domain-specific endpoint for kibana without https scheme |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# License

Apache 2 Licensed. See LICENSE for full details.