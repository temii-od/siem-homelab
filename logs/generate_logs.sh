#!/bin/bash

# =============================================================
# Fintech Attack Log Generator
# Simulates realistic attack patterns against a payment API
# Author: Temiloluwa Omodunbi
# =============================================================

OUTPUT_FILE="./logs/sample.log"
> "$OUTPUT_FILE"  # Clear the file before generating

echo "[*] Generating fintech attack simulation logs..."

# --- Helper: generate a random timestamp within today ---
random_timestamp() {
  HOUR=$(shuf -i 0-23 -n 1)
  MIN=$(shuf -i 0-59 -n 1)
  SEC=$(shuf -i 0-59 -n 1)
  echo "$(date +'%d/%b/%Y'):${HOUR}:${MIN}:${SEC} +0100"
}

# --- Scenario 1: Normal legitimate traffic ---
echo "[*] Generating normal traffic..."
LEGIT_IPS=("41.58.124.10" "197.210.65.3" "105.112.45.88" "41.184.21.7" "102.89.34.5")
LEGIT_USERS=("Taiwo" "Demi" "Lydia" "Ngozi" "Bayo")
LEGIT_ENDPOINTS=("/api/v1/balance" "/api/v1/profile" "/api/v1/transactions" "/api/v1/transfer")

for i in $(seq 1 80); do
  IP=${LEGIT_IPS[$RANDOM % ${#LEGIT_IPS[@]}]}
  USER=${LEGIT_USERS[$RANDOM % ${#LEGIT_USERS[@]}]}
  ENDPOINT=${LEGIT_ENDPOINTS[$RANDOM % ${#LEGIT_ENDPOINTS[@]}]}
  BYTES=$(shuf -i 200-2000 -n 1)
  TS=$(random_timestamp)
  echo "$IP - $USER [$TS] \"GET $ENDPOINT HTTP/1.1\" 200 $BYTES \"-\" \"Mozilla/5.0\"" >> "$OUTPUT_FILE"
done

# --- Scenario 2: Credential stuffing attack ---
echo "[*] Generating credential stuffing attack..."
ATTACKER_IP="185.220.101.47"

for i in $(seq 1 50); do
  FAKE_USER="user$(shuf -i 1000-9999 -n 1)"
  BYTES=$(shuf -i 120-300 -n 1)
  TS=$(random_timestamp)
  echo "$ATTACKER_IP - $FAKE_USER [$TS] \"POST /api/v1/login HTTP/1.1\" 401 $BYTES \"-\" \"python-requests/2.28.0\"" >> "$OUTPUT_FILE"
done

# --- Scenario 3: Successful attacker login after stuffing ---
echo "[*] Generating attacker successful login..."
TS=$(random_timestamp)
echo "$ATTACKER_IP - user7823 [$TS] \"POST /api/v1/login HTTP/1.1\" 200 512 \"-\" \"python-requests/2.28.0\"" >> "$OUTPUT_FILE"

# --- Scenario 4: Unauthorized transfer attempts ---
echo "[*] Generating unauthorized transfer attempts..."
for i in $(seq 1 30); do
  BYTES=$(shuf -i 150-400 -n 1)
  TS=$(random_timestamp)
  echo "$ATTACKER_IP - user7823 [$TS] \"POST /api/v1/transfer HTTP/1.1\" 403 $BYTES \"-\" \"python-requests/2.28.0\"" >> "$OUTPUT_FILE"
done

# --- Scenario 5: Privilege escalation probe ---
echo "[*] Generating privilege escalation attempts..."
ADMIN_ENDPOINTS=("/api/v1/admin/users" "/api/v1/admin/config" "/api/v1/admin/transactions" "/api/v1/admin/reports")

for i in $(seq 1 20); do
  ENDPOINT=${ADMIN_ENDPOINTS[$RANDOM % ${#ADMIN_ENDPOINTS[@]}]}
  BYTES=$(shuf -i 100-250 -n 1)
  TS=$(random_timestamp)
  echo "$ATTACKER_IP - user7823 [$TS] \"GET $ENDPOINT HTTP/1.1\" 403 $BYTES \"-\" \"python-requests/2.28.0\"" >> "$OUTPUT_FILE"
done

# --- Scenario 6: Server errors from exploit attempts ---
echo "[*] Generating server errors..."
EXPLOIT_PAYLOADS=("/api/v1/transfer?amount=99999999" "/api/v1/login?user=admin'--" "/api/v1/profile?id=../../../../etc/passwd")

for i in $(seq 1 15); do
  ENDPOINT=${EXPLOIT_PAYLOADS[$RANDOM % ${#EXPLOIT_PAYLOADS[@]}]}
  BYTES=$(shuf -i 500-1500 -n 1)
  TS=$(random_timestamp)
  echo "$ATTACKER_IP - - [$TS] \"GET $ENDPOINT HTTP/1.1\" 500 $BYTES \"-\" \"curl/7.68.0\"" >> "$OUTPUT_FILE"
done

# --- Scenario 7: Normal traffic resuming after attack ---
echo "[*] Generating post-attack normal traffic..."
for i in $(seq 1 40); do
  IP=${LEGIT_IPS[$RANDOM % ${#LEGIT_IPS[@]}]}
  USER=${LEGIT_USERS[$RANDOM % ${#LEGIT_USERS[@]}]}
  ENDPOINT=${LEGIT_ENDPOINTS[$RANDOM % ${#LEGIT_ENDPOINTS[@]}]}
  BYTES=$(shuf -i 200-2000 -n 1)
  TS=$(random_timestamp)
  echo "$IP - $USER [$TS] \"GET $ENDPOINT HTTP/1.1\" 200 $BYTES \"-\" \"Mozilla/5.0\"" >> "$OUTPUT_FILE"
done

echo "[✓] Done. $(wc -l < $OUTPUT_FILE) log lines written to $OUTPUT_FILE"
