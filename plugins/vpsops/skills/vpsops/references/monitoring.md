# Monitoring, Reports, And Alerts

## Controller Selection

Put the collector on a stable, always-on machine selected by the user. It should reach every monitored node without exposing a panel or new public service. A fixed landing node is often convenient when relays change, but this is a topology choice, not a requirement.

The controller cannot report its own total outage. If the user has an independent VPS or chooses one later, configure it as an external observer for the controller. If no independent observer exists, document that coverage gap and continue with internal monitoring.

## Data And Access

- Use a separate monitor SSH key for each remote node. Restrict it to a forced read-only command; disable shell, PTY, agent forwarding, port forwarding, and X11 forwarding.
- Store bot tokens, chat IDs, and monitor keys only in root-owned runtime files. Never include them in reports, repositories, skills, or inventory.
- Prefer a private Telegram channel for reports and alerts. Give the bot only the permission required to post.
- Confirm timezone, schedule, traffic quota, reset date, expiry date, retention, and alert thresholds with the user. Do not hard-code a schedule or vendor plan.

## Recommended Signals

Report node/service state, uptime, CPU, memory, disk, daily and monthly upload/download traffic, quota percentage, expiry date, relay-to-landing TCP health, latency/loss samples, rolling success/P50/P95 when enough samples exist, recent alerts, and selected egress checks.

Do not claim controller-side checks prove the user's local broadband experience. Mark new telemetry as insufficient until enough samples exist, and state the traffic measurement start date.

## Alert Policy

Use sustained failures, such as three consecutive five-minute checks, before alerting. Alert for intended service failure, monitored-node reachability, relay-to-landing failure, disk pressure, OOM/restart loops, traffic thresholds, and expiry windows. Send one recovery message after a fault clears. Avoid alerts for a single transient timeout.

Keep short raw telemetry and longer daily summaries only when useful. A practical small-node default is 14 days raw and 180 days daily/alert summaries, with automatic cleanup.
