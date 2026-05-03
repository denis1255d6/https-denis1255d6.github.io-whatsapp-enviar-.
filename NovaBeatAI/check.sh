#!/usr/bin/env bash
set -euo pipefail

curl -fsS http://localhost:8080 >/dev/null && echo "OK frontend"
curl -fsS http://localhost:3000/health && echo
curl -fsS http://localhost:8000/docs >/dev/null && echo "OK fastapi"
