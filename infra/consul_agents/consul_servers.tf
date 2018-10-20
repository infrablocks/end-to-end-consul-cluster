data "terraform_remote_state" "consul_servers" {
  backend = "s3"

  config {
    bucket = "${var.consul_servers_state_bucket_name}"
    key = "${var.consul_servers_state_key}"
    region = "${var.region}"
    encrypt = "${var.consul_servers_state_bucket_is_encrypted}"
  }
}
