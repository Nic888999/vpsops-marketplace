# Acceptance And Incident Diagnosis

## Acceptance Matrix

For each planned path, record the tested device/network, path type, address family, time window, connection success rate, representative site/app result, median/P95 latency when samples exist, loss/timeouts, throughput where permitted, and rollback result.

Test separately:

1. Client to public relay or landing listener.
2. Relay to landing listener.
3. Landing service and outbound egress.
4. Primary, fallback, and every user-requested routing exception.
5. Mainland direct and DNS behavior.
6. TUN-only apps and IPv6 only when each is enabled.
7. For REALITY: target TLS 1.3, ALPN `h2`, certificate verification, redirect warning/ranking, repeated target reachability, Xray configuration validation, and an actual client handshake through the deployed node.

Do not accept a REALITY deployment because the listener is open or the container is healthy. Fetch a lightweight 2xx/204 endpoint through the real client, verify the intended egress IP, and keep the previous target/profile until the replacement passes.

Do not infer a user's return path, app experience, or a "premium route" from a test IP alone.

## Final Handoff

Do not call the work complete until the report states: the copy-ready terminal SSH command; provider-console recovery route; verified sudo model; native/Docker deployment and pinned version; intended ports/firewall; whether IPv6 was offered, configured, declined, or unavailable; REALITY candidate comparison and selected rationale; real-client app/core and acceptance status; remote and local changes separated; backups/rollback; temporary-secret cleanup; and any credential that should be rotated. Never claim that existing routing was unaffected without comparing and verifying it.

If local-client modification or testing was not authorized, mark device acceptance as `pending user authorization`; do not attempt to make the report complete by editing, activating, reloading, or selecting anything locally. The SSH command is mandatory even when the remaining client step is pending.

## Incident Order

Start read-only and classify the fault before changing settings:

1. Client profile, selected group, DNS, TUN, IPv4/IPv6, and local network.
2. Client reachability to relay or landing listener.
3. Relay service, listener, and relay-to-landing path.
4. Landing service, firewall, container/service logs, resources, and egress.
5. Target website/app behavior and account/geolocation policy.

Compare against a known fallback, recent monitoring, and the user's actual symptom. Propose a scoped change with backup and rollback only after evidence identifies the likely layer.
