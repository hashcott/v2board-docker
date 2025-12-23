#!/bin/bash
# Run v2board in development mode
docker compose -f docker-compose.yaml -f docker-compose.dev.yaml "$@"

