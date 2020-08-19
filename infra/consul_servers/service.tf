data "template_file" "consul_server_task_container_definitions" {
  template = file("${path.root}/container-definitions/consul-server.json.tpl")

  vars = {
    environment_object_path = "s3://${var.secrets_bucket_name}/${data.template_file.consul_server_environment_object_key.rendered}"
    data_mount_point = var.container_data_directory
    http_port = var.http_port
    dns_port = var.dns_port
    server_port = var.server_port
    serf_lan_port = var.serf_lan_port
    serf_wan_port = var.serf_wan_port
  }
}

data "aws_iam_policy_document" "consul_server_assume_role_policy_content" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"]
      type = "Service"
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "consul_server_role_policy_content" {
  statement {
    actions = [
      "ec2:DescribeInstances",
    ]

    resources = [
      "*"]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.secrets_bucket_name}/*",
    ]
  }
}

resource "aws_iam_role" "consul_server_role" {
  name = "consul-server-role-${var.component}-${var.deployment_identifier}"

  assume_role_policy = data.aws_iam_policy_document.consul_server_assume_role_policy_content.json
}

resource "aws_iam_role_policy" "consul_server_role_policy" {
  role = aws_iam_role.consul_server_role.id
  policy = data.aws_iam_policy_document.consul_server_role_policy_content.json
}

module "consul_server_ecs_service" {
  source = "infrablocks/ecs-service/aws"
  version = "2.5.0"

  region = var.region
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  component = var.component
  deployment_identifier = var.deployment_identifier

  service_name = "consul-servers"
  service_image = var.consul_server_image
  service_port = var.http_port

  service_task_container_definitions = data.template_file.consul_server_task_container_definitions.rendered
  service_task_network_mode = "host"

  service_role = aws_iam_role.consul_server_role.arn

  service_volumes = [
    {
      name = "consul-data"
      host_path = var.host_data_directory
    }
  ]

  service_desired_count = var.service_desired_count
  service_deployment_minimum_healthy_percent = "50"
  service_deployment_maximum_percent = "200"

  service_elb_name = module.classic_load_balancer.name

  ecs_cluster_id = data.terraform_remote_state.cluster.outputs.ecs_cluster_id
  ecs_cluster_service_role_arn = data.terraform_remote_state.cluster.outputs.ecs_service_role_arn
}
