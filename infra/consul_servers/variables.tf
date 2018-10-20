variable "region" {}
variable "component" {}
variable "deployment_identifier" {}

variable "service_discovery_cluster_component" {}

variable "private_network_cidr" {}

variable "service_desired_count" {}

variable "consul_server_image" {}

variable "secrets_bucket_name" {}

variable "http_port" {}
variable "dns_port" {}
variable "server_port" {}
variable "serf_lan_port" {}
variable "serf_wan_port" {}

variable "container_data_directory" {}
variable "host_data_directory" {}

variable "domain_state_bucket_region" {}
variable "domain_state_bucket_name" {}
variable "domain_state_bucket_is_encrypted" {}
variable "domain_state_key" {}

variable "network_state_bucket_region" {}
variable "network_state_bucket_name" {}
variable "network_state_key" {}
variable "network_state_bucket_is_encrypted" {}

variable "cluster_state_bucket_region" {}
variable "cluster_state_bucket_name" {}
variable "cluster_state_key" {}
variable "cluster_state_bucket_is_encrypted" {}
