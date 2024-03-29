module "classic_load_balancer" {
  source  = "infrablocks/classic-load-balancer/aws"
  version = "2.1.0-rc.7"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids

  component = var.component
  deployment_identifier = var.deployment_identifier

  domain_name = data.terraform_remote_state.domain.outputs.domain_name
  public_zone_id = data.terraform_remote_state.domain.outputs.public_zone_id
  private_zone_id = data.terraform_remote_state.domain.outputs.private_zone_id

  listeners = [
    {
      lb_port = 80
      lb_protocol = "HTTP"
      instance_port = var.http_port
      instance_protocol = "HTTP"
      ssl_certificate_id = null
    },
    {
      lb_port = var.serf_lan_port
      lb_protocol = "TCP"
      instance_port = var.serf_lan_port
      instance_protocol = "TCP"
      ssl_certificate_id = null
    }
  ]

  access_control = [
    {
      lb_port = 80
      instance_port = var.http_port
      allow_cidrs = ["0.0.0.0/0"]
    },
    {
      lb_port = var.serf_lan_port
      instance_port = var.serf_lan_port
      allow_cidrs = ["0.0.0.0/0"]
    }
  ]

  egress_cidrs = [var.private_network_cidr]

  health_check_target = "HTTP:${var.http_port}/v1/status/leader"
  health_check_timeout = 10
  health_check_interval = 30
  health_check_unhealthy_threshold = 5
  health_check_healthy_threshold = 5

  enable_cross_zone_load_balancing = "yes"

  enable_connection_draining = "yes"
  connection_draining_timeout = 60

  idle_timeout = 60

  include_public_dns_record = "yes"
  include_private_dns_record = "yes"

  expose_to_public_internet = "yes"
}
