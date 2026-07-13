# Baseline, Testing, And Maintenance

## Baseline

Apply only after initial access is proven:

- Ubuntu 24.04 LTS for new general servers;
- non-root sudo user and key-only SSH;
- default-deny inbound firewall with explicit service rules;
- automatic security updates with automatic reboot disabled;
- `logrotate` enabled, system journal size/retention limited, and Docker logs capped if Docker is used;
- regular `fstrim` where supported;
- no unnecessary panel, database, or container exposed to the internet.

Present the baseline before applying it. Treat fail2ban, SSH port changes, swap creation, BBR/sysctl or other TCP tuning, kernel changes, panels, monitoring, and reboots as optional changes that require a reason and separate approval. Do not install them merely because they appear in a common tutorial.

Use explicit package versions or digest-pinned images for critical deployments. Avoid `latest` for unattended production updates. Check image upgrades deliberately, review release notes, then deploy and verify.

For an explicitly requested personal proxy or relay, use VLESS + TCP + REALITY as the standard Xray deployment. Use HAProxy only for a separate TCP relay. Treat a change to VMess, Trojan, AnyTLS, or another protocol as an architecture decision: explain the reason, back up the current configuration, validate the replacement, and retain a tested rollback path.

## Read-only health audit

Check uptime/load, disk and inode use, memory/swap, failed units, intended service state, listening sockets, firewall, journal usage, log rotation timer, automatic-update configuration, recent SSH failures, and pending updates. Treat blocked internet scans as normal when the firewall blocks them; investigate successful logins, unfamiliar listening ports, sustained resource use, or repeated service restarts.

## Route comparison

Compare direct and each relay path at several times, including a busy period. Record:

- connection success/timeout rate;
- median and P95 application request latency;
- packet loss or TCP retransmissions when available;
- download/upload throughput from representative permitted sources;
- actual loading of the user's relevant websites or applications.

Use results to select a primary and fallback. Do not use only a server-side route test to infer the client's return path.

## Retention policy

Use log rotation and journal limits on every host. Retain routine logs for 7-14 days on small VPS instances unless operational needs justify more. Rotate Docker logs daily with a size threshold. Retain temporary comparison telemetry only until a route decision is made, then summarize and remove or stop the high-frequency collector.
