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
      { "name": "AWS_S3_BUCKET_REGION", "value": "$${region}" },
      { "name": "AWS_S3_ENV_FILE_OBJECT_PATH", "value": "${environment_object_path}" }
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
