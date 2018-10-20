[
  {
    "name": "$${name}",
    "image": "$${image}",
    "memoryReservation": 128,
    "essential": true,
    "command": $${command},
    "mountPoints": [
      {
        "sourceVolume": "docker-socket",
        "containerPath": "/tmp/docker.sock"
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
