# Monitoring, Reports, And Alerts

## Controller Selection

Put the collector on a stable, always-on machine selected by the user. It should reach every monitored node without exposing a panel or new public service. A fixed landing node is often convenient when relays change, but this is a topology choice, not a requirement.

The controller cannot report its own total outage. If the user has an independent VPS or chooses one later, configure it as an external observer for the controller. If no independent observer exists, document that coverage gap and continue with internal monitoring.

## Data And Access

- Use a separate monitor SSH key for each remote node. Restrict it to a forced read-only command; disable shell, PTY, agent forwarding, port forwarding, and X11 forwarding.
- Store bot tokens, chat IDs, and monitor keys only in root-owned runtime files. Never include them in reports, repositories, skills, or inventory.
- Prefer a private Telegram channel for reports and alerts. Give the bot only the permission required to post.
- Confirm timezone, schedule, traffic quota, exact reset timestamp/timezone, expiry date, retention, alert thresholds, and whether the provider bills ingress, egress, or both. Do not hard-code a schedule or vendor plan.
- Treat the provider dashboard as authoritative. If collection starts mid-cycle, capture the provider's current used amount and the node's current cumulative counter as a baseline; report provider usage plus subsequent counter deltas. At reset, start a new baseline within the collector interval and document the possible small timing error.
- Track each node independently. A relay and landing node may both bill the same user payload; never add their quotas together as if they were one account. For bidirectional plans, calculate `RX + TX` on each node.
- Validate parser output and retry transient reads. Missing, malformed, or inaccessible counters must be reported as `unavailable`, never silently converted to `0`.

## Recommended Signals

Report node/service state, uptime, CPU, memory, disk, daily traffic, current billing-cycle usage and remaining quota, expiry date, relay-to-landing TCP health, latency/loss samples, recent alerts, and selected egress checks. Keep natural calendar-month counters only as optional diagnostic data.

Label relay-to-landing measurements as `server link`, not user experience. Do not claim controller-side checks prove the user's local broadband, return path, client, DNS, or application experience. A local probe may measure the actual client path and representative sites only while that device is online; mark offline periods as `not collected`, not healthy or failed. Mark new telemetry as insufficient until enough samples exist, and state the traffic measurement start date.

## Alert Policy

Use sustained failures, such as three consecutive five-minute checks, before alerting. Alert for intended service failure, monitored-node reachability, relay-to-landing failure, disk pressure, OOM/restart loops, traffic thresholds, and expiry windows. Send one recovery message after a fault clears. Avoid alerts for a single transient timeout.

Keep short raw telemetry and longer daily summaries only when useful. A practical small-node default is 14 days raw and 180 days daily/alert summaries, with automatic cleanup.
