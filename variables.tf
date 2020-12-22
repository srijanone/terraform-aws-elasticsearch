#
# AWS ElasticSearch
#
variable "create" {
  type        = bool
  description = "Do you want to create ES Cluster"
  default     = true
}
variable "domain_name" {
  type        = string
  description = "(Required) Name of the domain."
}
variable "elasticsearch_version" {
  type        = string
  description = "(Optional) The version of Elasticsearch to deploy. Defaults to 1.5"
  default     = "1.5"
}

variable "access_policies" {
  type        = string
  description = "(Optional) IAM policy document specifying the access policies for the domain"
  default     = null
}

# Advanced security options
variable "advanced_security_options" {
  type        = any
  description = " (Optional) Options for fine-grained access control."
  default = {

  }
}

# Domain endpoint options
variable "domain_endpoint_options" {
  type        = any
  description = "(Optional) Domain endpoint HTTP(S) related options."
  default = {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
}

# Advanced options
variable "advanced_options" {
  type        = map(string)
  description = " (Optional) Key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply."
  default = {

  }
}

# ebs_options
variable "ebs_options" {
  type        = any
  description = "(Optional) EBS related options, may be required based on chosen instance size."
  default = {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 20
  }
}


# encrypt_at_rest
variable "encrypt_at_rest" {
  type        = any
  description = "Optional) Encrypt at rest options. Only available for certain instance types."
  default = {
    enabled = true
  }
}

# node_to_node_encryption
variable "node_to_node_encryption" {
  type        = any
  description = "(Optional) Node-to-node encryption options."
  default = {
    enabled = false
  }
}

##### Cloudwatch Log group
variable "cloudwatch_log_group_arn" {
  type        = string
  description = "(Optional) ARN of the Cloudwatch log group to which log needs to be published."
  default     = ""
}
variable "cloudwatch_log_retention_in_days" {
  type        = number
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 0
}
variable "cloudwatch_log_kms_key_id" {
  type        = string
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. "
  default     = null
}

# cluster_config 
variable "cluster_config" {
  description = "(Optional) Cluster configuration of the domain"
  type        = any
  default = {
    "instance_type"            = "r5.large.elasticsearch"
    "instance_count"           = 3
    "dedicated_master_enabled" = true
    "dedicated_master_type"    = "r5.large.elasticsearch"
    "dedicated_master_count"   = 3
    "zone_awareness_enabled"   = false
  }
}

# snapshot_options
variable "snapshot_options" {
  description = "(Optional) Snapshot related options"
  type        = any
  default = {

  }
}

# vpc_options
variable "vpc_options" {
  description = "(Optional) VPC related options, Adding or removing this configuration forces a new resource"
  type        = any
  default = {

  }
}

# log_publishing_options 
variable "log_publishing_options" {
  description = "(Optional) Options for publishing slow and application logs to CloudWatch Logs. This block can be declared multiple times, for each log_type, within the same resource."
  type        = any
  default = [
    {
      log_type = "INDEX_SLOW_LOGS"
    },
    {
      log_type = "SEARCH_SLOW_LOGS"
    },
    {
      log_type = "ES_APPLICATION_LOGS"
    }
  ]
}

# cognito_options  
variable "cognito_options" {
  description = "(Optional) Options for Amazon Cognito Authentication for Kibana"
  type        = any
  default = {
  }
}
variable "tags" {
  description = "(Optional) A map of tags to assign to the resource"
  type        = map
  default = {

  }
}

# Timeouts
variable "timeouts" {
  description = "Timeouts map."
  type        = any
  default = {

  }
}

# Service Link Role
variable "create_service_link_role" {
  type        = bool
  description = "Create service link role for AWS Elasticsearch Service"
  default     = true
}
