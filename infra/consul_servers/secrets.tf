data "template_file" "consul_server_env" {
  template = file("${path.root}/envfiles/consul-server.env.tpl")

  vars = {
    service_discovery_cluster_component = var.service_discovery_cluster_component
  }
}

data "template_file" "consul_server_environment_object_key" {
  template = "secrets/environments/consul-server.env"
}

resource "aws_s3_bucket_object" "consul_server_env" {
  key = data.template_file.consul_server_environment_object_key.rendered
  bucket = var.secrets_bucket_name
  content = data.template_file.consul_server_env.rendered

  server_side_encryption = "AES256"
}
