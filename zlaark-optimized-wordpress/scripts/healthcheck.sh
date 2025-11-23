#!/usr/bin/env bash
set -e
STATUS=$(curl -sS -o /dev/null -w "%{http_code}" http://localhost/healthz || echo 000)
if [ "$STATUS" != "200" ]; then
  echo "Unhealthy ($STATUS)"
  exit 1
fi
echo "Healthy"
