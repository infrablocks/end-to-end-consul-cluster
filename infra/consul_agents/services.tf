data "template_file" "consul_agent_task_container_definitions" {
  template = "${file("${path.root}/container-definitions/consul-agent.json.tpl")}"

  vars {
    environment_object_path = "s3://${var.secrets_bucket_name}/${data.template_file.consul_agent_environment_object_key.rendered}"
    data_mount_point = "${var.container_data_directory}"
    http_port = "${var.http_port}"
    dns_port = "${var.dns_port}"
    server_port = "${var.server_port}"
    serf_lan_port = "${var.serf_lan_port}"
    serf_wan_port = "${var.serf_wan_port}"
    component = "${var.component}"
    deployment_identifier = "${var.deployment_identifier}"
  }
}

data "template_file" "registrator_task_container_definitions" {
  template = "${file("${path.root}/container-definitions/registrator.json.tpl")}"

  vars {
    environment_object_path = "s3://${var.secrets_bucket_name}/${data.template_file.registrator_environment_object_key.rendered}"
  }
}

module "consul_agent_ecs_service" {
  source = "infrablocks/ecs-service/aws"
  version = "0.2.0-rc.4"

  region = "${var.region}"
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"

  component = "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  service_name = "consul-agents"
  service_image = "${var.consul_agent_image}"

  service_task_container_definitions = "${data.template_file.consul_agent_task_container_definitions.rendered}"
  service_task_network_mode = "host"

  service_volumes = [
    {
      name = "consul-data"
      host_path = "${var.host_data_directory}"
    }
  ]

  service_deployment_minimum_healthy_percent = "50"
  service_deployment_maximum_percent = "100"

  scheduling_strategy="DAEMON"

  attach_to_load_balancer="no"

  ecs_cluster_id = "${data.terraform_remote_state.cluster.ecs_cluster_id}"
  ecs_cluster_service_role_arn = "${data.terraform_remote_state.cluster.ecs_service_role_arn}"
}

module "registrator_ecs_service" {
  source = "infrablocks/ecs-service/aws"
  version = "0.2.0-rc.4"

  region = "${var.region}"
  vpc_id = "${data.terraform_remote_state.network.vpc_id}"

  component = "${var.component}"
  deployment_identifier = "${var.deployment_identifier}"

  service_name = "registrators"
  service_image = "${var.registrator_image}"

  service_task_container_definitions = "${data.template_file.registrator_task_container_definitions.rendered}"
  service_task_network_mode = "host"

  service_volumes = [
    {
      name = "docker-socket"
      host_path = "/var/run/docker.sock"
    }
  ]

  service_deployment_minimum_healthy_percent = "50"
  service_deployment_maximum_percent = "100"

  scheduling_strategy="DAEMON"

  attach_to_load_balancer="no"

  ecs_cluster_id = "${data.terraform_remote_state.cluster.ecs_cluster_id}"
  ecs_cluster_service_role_arn = "${data.terraform_remote_state.cluster.ecs_service_role_arn}"
}

