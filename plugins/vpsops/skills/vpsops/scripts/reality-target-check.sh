#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s HOST [HOST ...]\n' "${0##*/}"
  printf 'Run on the target VPS. PASS is preferred; WARN means redirect behavior needs ranking and real-client verification.\n'
}

if [[ $# -lt 1 ]]; then
  usage >&2
  exit 2
fi

for command_name in getent openssl curl timeout awk grep sort paste; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command_name" >&2
    exit 2
  fi
done

printf 'host\tsample\tresult\ttls13\th2\tcert\thttp\tremote_ip\tconnect_s\ttls_s\tttfb_s\tredirect\n'
any_pass=0

for host in "$@"; do
  if [[ ! "$host" =~ ^[A-Za-z0-9.-]+$ ]] || [[ "$host" == .* ]] || [[ "$host" == *. ]]; then
    printf '%s\t-\tFAIL\t-\t-\t-\t-\t-\t-\t-\t-\tinvalid-hostname\n' "$host"
    continue
  fi

  ips=$(getent ahosts "$host" 2>/dev/null | awk '{print $1}' | sort -u | paste -sd, - || true)
  if [[ -z "$ips" ]]; then
    printf '%s\t-\tFAIL\t-\t-\t-\t-\t-\t-\t-\t-\tdns-failed\n' "$host"
    continue
  fi

  candidate_pass=1
  for sample in 1 2 3; do
    tls_output=$(timeout 12 openssl s_client \
      -connect "${host}:443" \
      -servername "$host" \
      -tls1_3 \
      -alpn h2 \
      -verify_return_error </dev/null 2>&1 || true)

    tls13=no
    h2=no
    cert=no
    grep -Eq 'New, TLSv1\.3|Protocol *: TLSv1\.3' <<<"$tls_output" && tls13=yes
    grep -q 'ALPN protocol: h2' <<<"$tls_output" && h2=yes
    grep -q 'Verify return code: 0 (ok)' <<<"$tls_output" && cert=yes

    http_result=$(curl --tlsv1.3 --connect-timeout 5 --max-time 12 --max-redirs 0 \
      -sS -o /dev/null \
      -w '%{http_code}|%{remote_ip}|%{time_connect}|%{time_appconnect}|%{time_starttransfer}|%{redirect_url}' \
      "https://${host}/" 2>/dev/null || true)
    IFS='|' read -r http_code remote_ip connect_s tls_s ttfb_s redirect <<<"$http_result" || true
    http_code=${http_code:-000}
    remote_ip=${remote_ip:--}
    connect_s=${connect_s:--}
    tls_s=${tls_s:--}
    ttfb_s=${ttfb_s:--}
    redirect=${redirect:--}

    result=PASS
    if [[ "$tls13" != yes || "$h2" != yes || "$cert" != yes || ! "$http_code" =~ ^[234][0-9][0-9]$ ]]; then
      result=FAIL
      candidate_pass=0
    elif [[ "$http_code" =~ ^3[0-9][0-9]$ || "$redirect" != - ]]; then
      result=WARN
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$host" "$sample" "$result" "$tls13" "$h2" "$cert" "$http_code" \
      "$remote_ip" "$connect_s" "$tls_s" "$ttfb_s" "$redirect"
  done

  if (( candidate_pass == 1 )); then
    any_pass=1
  fi
done

if (( any_pass == 0 )); then
  exit 1
fi
