# Personal Proxy Deployment

## Applicability

Use only when the user explicitly asks for a personal proxy, landing service, or relay path. The default is **VLESS + TCP + REALITY on Xray**. Do not replace it with VMess, Trojan, AnyTLS, or a panel-script default without a compatibility or measured-performance reason.

## Deployment Rules

- Generate UUIDs, Reality keypairs, short IDs, and client material at deployment time. Keep them only in protected runtime configuration and the user's requested client profile; never place them in the skill, repository, inventory, report, or terminal output.
- Use Docker only when it fits the host. Pin the Xray image to a reviewed version or digest; do not use `latest` for unattended deployment.
- Pick an unused listener port deliberately, add only the required firewall rule, and restrict a landing listener to known relay addresses when relays exist.
- Keep the relay as a layer-4 HAProxy forwarder only. It must forward only to the selected landing listener and must not become an open proxy.
- Back up the previous service configuration, validate generated configuration, start/reload only the affected service, and verify the previous access path remains usable.

## Reality Target Selection

Never use a fixed tutorial target, a previous user's target, or a domain selected only because it is popular. A target that works from another provider or region is only a candidate.

First identify the VPS country/metro and provider network, then build a fresh candidate set whose DNS answers and TLS endpoints are served near that location. Compare the resolved IPs, repeated TLS timing, and stability from that VPS; document why each candidate fits the current region. Do not bundle a universal candidate list into the skill.

For normal proxy use, each candidate must be outside the restricted destination network, resolve from the VPS, accept TCP/443, negotiate TLS 1.3 and ALPN `h2`, and verify its certificate. Prefer a hostname that is not used for HTTP redirection, stable 2xx/4xx behavior, lower TLS handshake time, IPs topologically close to the VPS, OCSP stapling, and encrypted handshake messages after Server Hello. Record a redirect as a warning and ranking penalty rather than proof of incompatibility: HTTP behavior alone cannot prove the REALITY handshake, and the official guidance itself names `dl.google.com` as a favorable handshake example. Check the current [official XTLS REALITY guidance](https://github.com/XTLS/REALITY) when network access is available; a passing result is still point-in-time evidence, not a permanent default.

Copy [reality-target-check.sh](../scripts/reality-target-check.sh) to a temporary location on the target VPS and run it against at least three region-appropriate candidates. The script is a preflight filter, not proof of a working proxy. Reject a candidate if any required TLS check fails or repeated samples are unstable; rank a redirect warning below an otherwise equivalent non-redirecting candidate. If no candidate is eligible, stop and report the evidence instead of deploying with a fallback default.

Set the Xray REALITY `target` and allowed `serverNames` consistently from the selected result. Back up an existing target before replacement. Validate the Xray configuration, then test the node from a real client through the intended network. The client must complete the REALITY handshake, expose the intended egress IP, and successfully fetch a lightweight 2xx/204 endpoint through the proxy. A running container, open TCP port, successful direct HTTPS request, or preflight result is not sufficient. Keep the previous target and client profile until this test passes.

Treat target compatibility as changeable external state. Monitoring may re-run the TLS/ALPN and redirect-observation checks, then alert on a required TLS failure, instability, or behavior change; it must not rotate the target automatically. A replacement requires the same scan, configuration validation, client test, and rollback path.

Do not use ordinary Cloudflare DNS proxying to hide a raw REALITY TCP listener; it is not a substitute for a compatible TCP proxy service.

## Completion Tests

Verify container/service status, listener and firewall scope, relay-to-landing connectivity where applicable, actual client connection, intended outbound IP, fallback path, and the requested client/app behavior. Keep the old path until all tests pass and the user approves retirement.
