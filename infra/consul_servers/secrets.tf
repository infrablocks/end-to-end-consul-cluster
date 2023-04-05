locals {
  consul_server_env = templatefile("${path.root}/envfiles/consul-server.env.tpl", {
    service_discovery_cluster_component = var.service_discovery_cluster_component
  })
  consul_server_environment_object_key = "secrets/environments/consul-server.env"
}

resource "aws_s3_object" "consul_server_env" {
  key = local.consul_server_environment_object_key
  bucket = var.secrets_bucket_name
  content = local.consul_server_env

  server_side_encryption = "AES256"
}
