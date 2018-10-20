data "template_file" "consul_agent_env" {
  template = "${file("${path.root}/envfiles/consul-agent.env.tpl")}"

  vars {
    consul_server_address = "${data.terraform_remote_state.consul_servers.address}"
  }
}

data "template_file" "registrator_env" {
  template = "${file("${path.root}/envfiles/registrator.env.tpl")}"

  vars {
    consul_agent_uri = "localhost:${var.http_port}"
  }
}

data "template_file" "consul_agent_environment_object_key" {
  template = "secrets/environments/consul-agent.env"
}

data "template_file" "registrator_environment_object_key" {
  template = "secrets/environments/registrator.env"
}

resource "aws_s3_bucket_object" "consul_agent_env" {
  key = "${data.template_file.consul_agent_environment_object_key.rendered}"
  bucket = "${var.secrets_bucket_name}"
  content = "${data.template_file.consul_agent_env.rendered}"

  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "registrator_env" {
  key = "${data.template_file.registrator_environment_object_key.rendered}"
  bucket = "${var.secrets_bucket_name}"
  content = "${data.template_file.registrator_env.rendered}"

  server_side_encryption = "AES256"
}
