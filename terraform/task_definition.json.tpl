[
    {
      "cpu": 1024,
      "memory": 982,
      "essential": true,
      "image": "${REPOSITORY_URL}:latest",
      "name": "${NAME}",
      "portMappings": [
        {
          "containerPort": 4000,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "environment": ${ENVIRONMENT}
    }
  ]
