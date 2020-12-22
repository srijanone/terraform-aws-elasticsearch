resource "aws_iam_service_linked_role" "this" {
  count            = var.create_service_link_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
  description      = "Service-linked role to give Amazon ES permissions to access your VPC"
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.cloudwatch_log_group_arn == "" ? 1 : 0
  name              = "${var.domain_name}-log_group"
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key_id

  tags = var.tags
}

resource "aws_elasticsearch_domain" "this" {
  count       = var.create ? 1 : 0
  domain_name = var.domain_name

  # ElasticSeach version
  elasticsearch_version = var.elasticsearch_version

  access_policies = var.access_policies

  advanced_options = var.advanced_options

  # advanced_security_options
  dynamic "advanced_security_options" {
    for_each = length(keys(var.advanced_security_options)) == 0 ? [ ] : [var.advanced_security_options]
    content {
      enabled                        = lookup(advanced_security_options.value, "enabled")
      internal_user_database_enabled = lookup(advanced_security_options.value, "internal_user_database_enabled", false)

      master_user_options {
        master_user_arn      = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_arn", null)
        master_user_name     = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_name", null)
        master_user_password = lookup(lookup(advanced_security_options.value, "master_user_options"), "master_user_password", null)
      }
    }
  }

  # checkov:skip=CKV_AWS_83:Enforce HTTPS are enabled by default
  # domain_endpoint_options
  dynamic "domain_endpoint_options" {
    for_each = length(keys(var.domain_endpoint_options)) == 0 ? [] : [var.domain_endpoint_options]
    content {
      enforce_https       = lookup(domain_endpoint_options.value, "enforce_https", true)
      tls_security_policy = lookup(domain_endpoint_options.value, "tls_security_policy", "Policy-Min-TLS-1-2-2019-07")
    }
  }

  # ebs_options
  dynamic "ebs_options" {
    for_each = length(keys(var.ebs_options)) == 0 ? [ ] : [var.ebs_options]
    content {
      ebs_enabled = lookup(ebs_options.value, "ebs_enabled", true)
      volume_type = lookup(ebs_options.value, "volume_type", "gp2")
      volume_size = lookup(ebs_options.value, "volume_size", 20)
      iops        = lookup(ebs_options.value, "iops", 0)
    }
  }

  # checkov:skip=CKV_AWS_5:Encrypt at Rest are enabled by default
  # encrypt_at_rest
  dynamic "encrypt_at_rest" {
    for_each = [var.encrypt_at_rest]
    content {
      #tfsec:ignore:AWS031
      enabled    = lookup(encrypt_at_rest.value, "enabled", true)
      kms_key_id = lookup(encrypt_at_rest.value, "kms_key_id", null)
    }
  }

  # node_to_node_encryption
  #tfsec:ignore:AWS032
  node_to_node_encryption {

    enabled = lookup(var.node_to_node_encryption, "enabled", false)
  }

  # cluster_config
  dynamic "cluster_config" {
    for_each = [var.cluster_config]
    content {
      instance_type            = lookup(cluster_config.value, "instance_type", "r5.large.elasticsearch")
      instance_count           = lookup(cluster_config.value, "instance_count", 3)
      dedicated_master_enabled = lookup(cluster_config.value, "dedicated_master_enabled", true)
      dedicated_master_type    = lookup(cluster_config.value, "dedicated_master_type", "r5.large.elasticsearch")
      dedicated_master_count   = lookup(cluster_config.value, "dedicated_master_count", 3)
      zone_awareness_enabled   = lookup(cluster_config.value, "zone_awareness_enabled", false)
      warm_enabled             = lookup(cluster_config.value, "warm_enabled", false)
      warm_count               = lookup(cluster_config.value, "warm_count", null)
      warm_type                = lookup(cluster_config.value, "warm_type", null)

      dynamic "zone_awareness_config" {
        # cluster_availability_zone_count valid values: 2 or 3.
        for_each = lookup(cluster_config.value, "zone_awareness_enabled", false) == false  ? [ ] : [ lookup(cluster_config.value, "zone_awareness_config", {})]
        content {
          availability_zone_count = lookup(zone_awareness_config.value, "availability_zone_count")
        }
      }
    }
  }

  # snapshot_options
  dynamic "snapshot_options" {
    for_each = length(keys(var.snapshot_options)) == 0 ? [ ] : [var.snapshot_options]
    content {
      automated_snapshot_start_hour = lookup(snapshot_options.value, "automated_snapshot_start_hour")
    }
  }

  # vpc_options
  dynamic "vpc_options" {
    for_each = length(keys(var.vpc_options)) == 0 ? [ ]: [var.vpc_options]
    content {
      security_group_ids = lookup(vpc_options.value, "security_group_ids", [])
      subnet_ids         = lookup(vpc_options.value, "subnet_ids")
    }
  }

  # checkov:skip=CKV_AWS_84:Logs are enabled but needs Cloudwatch ARN
  # log_publishing_options
  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options
    content {
      log_type                 = lookup(log_publishing_options.value, "log_type", "AUDIT_LOGS")
      cloudwatch_log_group_arn = var.cloudwatch_log_group_arn == "" ? join("",aws_cloudwatch_log_group.this.*.arn) : var.cloudwatch_log_group_arn
      enabled                  = lookup(log_publishing_options.value, "enabled", true)
    }
  }

  # cognito_options
  dynamic "cognito_options" {
    for_each = length(keys(var.cognito_options)) == 0 ? [] : [var.cognito_options]
    content {
      enabled          = lookup(cognito_options.value, "enabled", false)
      user_pool_id     = lookup(cognito_options.value, "user_pool_id")
      identity_pool_id = lookup(cognito_options.value, "identity_pool_id")
      role_arn         = lookup(cognito_options.value, "role_arn")
    }
  }

  # Timeouts
  dynamic "timeouts" {
    for_each = length(keys(var.timeouts)) == 0 ? [] : [var.timeouts]
    content {
      update = lookup(timeouts.value, "update")
    }
  }

  # Tags
  tags = var.tags

  # Service-linked role to give Amazon ES permissions to access your VPC
  depends_on = [
    aws_iam_service_linked_role.this,
  ]

}

