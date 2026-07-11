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

Do not infer a user's return path, app experience, or a "premium route" from a test IP alone.

## Incident Order

Start read-only and classify the fault before changing settings:

1. Client profile, selected group, DNS, TUN, IPv4/IPv6, and local network.
2. Client reachability to relay or landing listener.
3. Relay service, listener, and relay-to-landing path.
4. Landing service, firewall, container/service logs, resources, and egress.
5. Target website/app behavior and account/geolocation policy.

Compare against a known fallback, recent monitoring, and the user's actual symptom. Propose a scoped change with backup and rollback only after evidence identifies the likely layer.
