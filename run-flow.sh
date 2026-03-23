#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

AUTH_URL="${AUTH_URL:-http://localhost:8001}"
FLAG_URL="${FLAG_URL:-http://localhost:8002}"
TARGETING_URL="${TARGETING_URL:-http://localhost:8003}"
EVAL_URL="${EVAL_URL:-http://localhost:8004}"
LOCALSTACK_URL="${LOCALSTACK_URL:-http://localhost:4566/_localstack/health}"

MASTER_KEY="${MASTER_KEY:-admin-secreto-123}"
FLAG_NAME="${FLAG_NAME:-enable-new-dashboard}"
RULE_PERCENT="${RULE_PERCENT:-50}"
USER_ID="${USER_ID:-user-123}"

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

echo "Subindo containers..."
docker compose up -d --build

wait_for_health "localstack" "$LOCALSTACK_URL"
wait_for_health "auth-service" "$AUTH_URL/health"

echo "Criando chave de API..."
CREATE_KEY_BODY=""
for _ in {1..5}; do
  CREATE_KEY_BODY="$(curl -sS -X POST "$AUTH_URL/admin/keys" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $MASTER_KEY" \
    -d '{"name":"local-automation"}' || true)"
  if [ -n "$CREATE_KEY_BODY" ]; then
    break
  fi
  sleep 2
done

if [ -z "$CREATE_KEY_BODY" ]; then
  echo "Erro ao criar chave de API (resposta vazia)."
  exit 1
fi

API_KEY="$(python3 - <<'PY' "$CREATE_KEY_BODY"
import json, sys
data = json.loads(sys.argv[1])
print(data["key"])
PY
)"

export SERVICE_API_KEY="$API_KEY"
echo "Recriando evaluation-service com SERVICE_API_KEY..."
docker compose up -d --force-recreate evaluation-service

wait_for_health "flag-service" "$FLAG_URL/health"
wait_for_health "targeting-service" "$TARGETING_URL/health"
wait_for_health "evaluation-service" "$EVAL_URL/health"

echo "Criando flag '$FLAG_NAME'..."
FLAG_STATUS="$(curl -sS -o /dev/null -w "%{http_code}" -X POST "$FLAG_URL/flags" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{\"name\":\"$FLAG_NAME\",\"description\":\"Ativa o novo dashboard\",\"is_enabled\":true}")"
if [ "$FLAG_STATUS" != "201" ] && [ "$FLAG_STATUS" != "409" ]; then
  echo "Erro ao criar flag (status $FLAG_STATUS)."
  exit 1
fi

echo "Criando regra de targeting ($RULE_PERCENT%)..."
RULE_STATUS="$(curl -sS -o /dev/null -w "%{http_code}" -X POST "$TARGETING_URL/rules" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{\"flag_name\":\"$FLAG_NAME\",\"is_enabled\":true,\"rules\":{\"type\":\"PERCENTAGE\",\"value\":$RULE_PERCENT}}")"
if [ "$RULE_STATUS" != "201" ] && [ "$RULE_STATUS" != "409" ]; then
  echo "Erro ao criar regra (status $RULE_STATUS)."
  exit 1
fi

echo "Testando avaliacao..."
curl -fsS "$EVAL_URL/evaluate?user_id=$USER_ID&flag_name=$FLAG_NAME"
echo
