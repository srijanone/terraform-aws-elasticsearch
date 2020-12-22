resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = "${var.es_domain_name}-log-group-access-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

module "aws_es" {

  source = "../../"

  domain_name           = var.es_domain_name
  elasticsearch_version = var.es_version

  cluster_config = {
    dedicated_master_enabled = true
    instance_count           = "3"
    instance_type            = "r4.large.elasticsearch"
    zone_awareness_enabled   = true
    zone_awareness_config = {
      availability_zone_count  = "3"
    }
  }

  ebs_options = {
    ebs_enabled = true
    volume_size = "25"
  }

  encrypt_at_rest = {
    enabled    = true
    kms_key_id = "alias/aws/es"
  }

  vpc_options = {
    subnet_ids         = ["subnet-076e3117a5a9424ae", "subnet-03c84fdb221778ab2", "subnet-0dc16899b28388c73"]
    security_group_ids = ["sg-011d77df254f4bb2f"]
  }

  node_to_node_encryption                = {
    enabled = true
  }
  snapshot_options = {
    automated_snapshot_start_hour = "23"
  }

  access_policies = templatefile("${path.module}/access_policies.tpl", {
    region      = data.aws_region.current.name,
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.es_domain_name
  })

  timeouts = {
    update = "60m"
  }

  tags = {
    Owner = "sysops"
    env   = "dev"
  }

}
