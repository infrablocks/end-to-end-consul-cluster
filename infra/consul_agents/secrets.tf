locals {
  consul_agent_env = templatefile("${path.root}/envfiles/consul-agent.env.tpl", {
    consul_server_address = data.terraform_remote_state.consul_servers.outputs.address
  })
  registrator_env = templatefile("${path.root}/envfiles/registrator.env.tpl", {
    consul_agent_uri = "localhost:${var.http_port}"
  })

  consul_agent_environment_object_key = "secrets/environments/consul-agent.env"
  registrator_environment_object_key = "secrets/environments/registrator.env"
}

resource "aws_s3_object" "consul_agent_env" {
  key = local.consul_agent_environment_object_key
  bucket = var.secrets_bucket_name
  content = local.consul_agent_env

  server_side_encryption = "AES256"
}

resource "aws_s3_object" "registrator_env" {
  key = local.registrator_environment_object_key
  bucket = var.secrets_bucket_name
  content = local.registrator_env

  server_side_encryption = "AES256"
}
