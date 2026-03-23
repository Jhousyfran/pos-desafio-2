#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

AUTH_URL="${AUTH_URL:-http://localhost:8001}"
FLAG_URL="${FLAG_URL:-http://localhost:8002}"
TARGETING_URL="${TARGETING_URL:-http://localhost:8003}"
EVAL_URL="${EVAL_URL:-http://localhost:8004}"

SERVICE_API_KEY="${SERVICE_API_KEY:-}"
MASTER_KEY="${MASTER_KEY:-admin-secreto-123}"
RULE_PERCENT="${RULE_PERCENT:-50}"
USER_ID="${USER_ID:-user-$RANDOM}"

wait_for_health() {
  local name="$1"
  local url="$2"

  echo "Aguardando $name em $url..."
  for _ in {1..30}; do
    if curl -fsS "$url" >/dev/null 2>&1; then
      echo "$name OK"
      return 0
    fi
    sleep 2
  done

  echo "Timeout aguardando $name"
  return 1
}

wait_for_health "auth-service" "$AUTH_URL/health"
wait_for_health "flag-service" "$FLAG_URL/health"
wait_for_health "targeting-service" "$TARGETING_URL/health"
wait_for_health "evaluation-service" "$EVAL_URL/health"

if [ -z "$SERVICE_API_KEY" ]; then
  echo "Criando chave de API..."
  CREATE_KEY_BODY=""
  for _ in {1..5}; do
    CREATE_KEY_BODY="$(curl -sS -X POST "$AUTH_URL/admin/keys" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $MASTER_KEY" \
      -d '{"name":"test-flow"}' || true)"
    if [ -n "$CREATE_KEY_BODY" ]; then
      break
    fi
    sleep 2
  done

  if [ -z "$CREATE_KEY_BODY" ]; then
    echo "Erro ao criar chave de API (resposta vazia)."
    exit 1
  fi

  SERVICE_API_KEY="$(python3 - <<'PY' "$CREATE_KEY_BODY"
import json, sys
data = json.loads(sys.argv[1])
print(data["key"])
PY
)"

  export SERVICE_API_KEY
  echo "Recriando evaluation-service com SERVICE_API_KEY..."
  docker compose up -d --force-recreate evaluation-service
fi

RAND_SUFFIX="$(date +%s)-$RANDOM"
FLAG_NAME="enable-new-dashboard-$RAND_SUFFIX"

echo "Criando flag '$FLAG_NAME'..."
FLAG_STATUS="$(curl -sS -o /dev/null -w "%{http_code}" -X POST "$FLAG_URL/flags" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $SERVICE_API_KEY" \
  -d "{\"name\":\"$FLAG_NAME\",\"description\":\"Flag criada pelo teste\",\"is_enabled\":true}")"
if [ "$FLAG_STATUS" != "201" ]; then
  echo "Erro ao criar flag (status $FLAG_STATUS)."
  exit 1
fi

echo "Criando regra de targeting ($RULE_PERCENT%)..."
RULE_STATUS="$(curl -sS -o /dev/null -w "%{http_code}" -X POST "$TARGETING_URL/rules" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $SERVICE_API_KEY" \
  -d "{\"flag_name\":\"$FLAG_NAME\",\"is_enabled\":true,\"rules\":{\"type\":\"PERCENTAGE\",\"value\":$RULE_PERCENT}}")"
if [ "$RULE_STATUS" != "201" ]; then
  echo "Erro ao criar regra (status $RULE_STATUS)."
  exit 1
fi

echo "Testando avaliacao (user_id=$USER_ID)..."
curl -fsS "$EVAL_URL/evaluate?user_id=$USER_ID&flag_name=$FLAG_NAME"
echo
