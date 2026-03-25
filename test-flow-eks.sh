#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

AUTH_URL="${AUTH_URL:-https://desafio.jhousyfran.click/auth}"
FLAG_URL="${FLAG_URL:-https://desafio.jhousyfran.click/flag}"
TARGETING_URL="${TARGETING_URL:-https://desafio.jhousyfran.click/targeting}"
EVAL_URL="${EVAL_URL:-https://desafio.jhousyfran.click/evaluation}"

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
  CREATE_KEY_STATUS=""
  for _ in {1..5}; do
    CREATE_KEY_BODY="$(curl -sS -o /tmp/create_key_body.json -w "%{http_code}" -X POST "$AUTH_URL/admin/keys" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $MASTER_KEY" \
      -d '{"name":"test-flow"}' || true)"
    CREATE_KEY_STATUS="$CREATE_KEY_BODY"
    CREATE_KEY_BODY="$(cat /tmp/create_key_body.json 2>/dev/null || true)"
    if [ -n "$CREATE_KEY_BODY" ] && [ "$CREATE_KEY_STATUS" = "201" ]; then
      break
    fi
    sleep 2
  done

  if [ -z "$CREATE_KEY_BODY" ] || [ "$CREATE_KEY_STATUS" != "201" ]; then
    echo "Erro ao criar chave de API (status ${CREATE_KEY_STATUS:-unknown})."
    if [ -n "$CREATE_KEY_BODY" ]; then
      echo "Resposta: $CREATE_KEY_BODY"
    fi
    exit 1
  fi

  SERVICE_API_KEY="$(python3 - <<'PY' "$CREATE_KEY_BODY"
import json, sys
data = json.loads(sys.argv[1])
print(data["key"])
PY
)"

  export SERVICE_API_KEY
  echo "SERVICE_API_KEY definida para esta execucao."
fi

echo "Chave de API: $SERVICE_API_KEY"

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
echo "Endpoint: $EVAL_URL/evaluate?user_id=$USER_ID&flag_name=$FLAG_NAME"
curl -fsS "$EVAL_URL/evaluate?user_id=$USER_ID&flag_name=$FLAG_NAME"
echo
