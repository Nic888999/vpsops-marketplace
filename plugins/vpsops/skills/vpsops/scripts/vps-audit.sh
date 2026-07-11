#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: vps-audit.sh --host HOST --user USER [--port PORT] [--identity FILE] [--jump USER@HOST:PORT]

Runs a read-only health and security audit through SSH. It never changes the remote host.
EOF
}

host=""
user=""
port="22"
identity=""
jump=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) host="$2"; shift 2 ;;
    --user) user="$2"; shift 2 ;;
    --port) port="$2"; shift 2 ;;
    --identity) identity="$2"; shift 2 ;;
    --jump) jump="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$host" && -n "$user" ]] || { usage >&2; exit 2; }

ssh_args=(-o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new -p "$port")
[[ -n "$identity" ]] && ssh_args+=(-i "$identity" -o IdentitiesOnly=yes)
[[ -n "$jump" ]] && ssh_args+=(-J "$jump")

ssh "${ssh_args[@]}" "$user@$host" 'bash -s' <<'REMOTE'
set -u
section() { printf '\n## %s\n' "$1"; }

section "Host"
hostname
uptime -p
cat /proc/loadavg

section "Storage"
df -hT /
df -hi /
journalctl --disk-usage 2>&1 || true

section "Memory"
free -h

section "Services"
systemctl --failed --no-legend || true
systemctl is-active ssh sshd docker haproxy nginx 2>/dev/null || true

section "Network"
sudo ss -ltnp 2>/dev/null || ss -ltnp
sudo ufw status verbose 2>/dev/null || true

section "Maintenance"
systemctl list-timers --all --no-pager 2>/dev/null | grep -E 'apt|logrotate|fstrim' || true
test -f /etc/apt/apt.conf.d/20auto-upgrades && cat /etc/apt/apt.conf.d/20auto-upgrades || true

section "Security Signals"
sudo sshd -T 2>/dev/null | grep -E 'permitrootlogin|passwordauthentication|pubkeyauthentication|allowusers|maxauthtries' || true
sudo journalctl -u ssh --since '24 hours ago' --no-pager 2>/dev/null | grep -Eic 'Failed password|Invalid user|authentication failure' || true

section "Pending Updates"
apt list --upgradable 2>/dev/null | sed -n '1,30p' || true
REMOTE
