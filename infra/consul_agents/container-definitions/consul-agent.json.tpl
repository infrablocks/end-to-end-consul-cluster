[
  {
    "name": "$${name}",
    "image": "$${image}",
    "memoryReservation": 192,
    "essential": true,
    "command": $${command},
    "portMappings": [
      {
        "containerPort": ${http_port},
        "hostPort": ${http_port}
      },
      {
        "containerPort": ${dns_port},
        "hostPort": ${dns_port}
      },
      {
        "containerPort": ${server_port},
        "hostPort": ${server_port}
      },
      {
        "containerPort": ${serf_lan_port},
        "hostPort": ${serf_lan_port}
      },
      {
        "containerPort": ${serf_wan_port},
        "hostPort": ${serf_wan_port}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "consul-data",
        "containerPath": "${data_mount_point}"
      }
    ],
    "environment": [
      { "name": "AWS_S3_BUCKET_REGION", "value": "$${region}" },
      { "name": "AWS_S3_ENV_FILE_OBJECT_PATH", "value": "${environment_object_path}" },
      { "name": "SERVICE_NAME", "value": "consul-agent" },
      { "name": "SERVICE_${http_port}_NAME", "value": "consul-agent-http" },
      { "name": "SERVICE_${dns_port}_NAME", "value": "consul-agent-dns" },
      { "name": "SERVICE_${server_port}_NAME", "value": "consul-agent-rpc" },
      { "name": "SERVICE_${serf_lan_port}_NAME", "value": "consul-agent-serf-lan" },
      { "name": "SERVICE_${serf_wan_port}_NAME", "value": "consul-agent-serf-wan" },
      { "name": "SERVICE_TAGS", "value": "${component},${deployment_identifier}" },
      { "name": "SERVICE_COMPONENT", "value": "${component}" },
      { "name": "SERVICE_DEPLOYMENT_IDENTIFIER", "value": "${deployment_identifier}" }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "$${log_group}",
        "awslogs-region": "$${region}"
      }
    }
  }
]
