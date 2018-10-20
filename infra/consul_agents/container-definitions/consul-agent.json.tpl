[
  {
    "name": "$${name}",
    "image": "$${image}",
    "memoryReservation": 128,
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
      { "name": "ENV_FILE_S3_BUCKET_REGION", "value": "$${region}" },
      { "name": "ENV_FILE_S3_OBJECT_PATH", "value": "${environment_object_path}" }
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
