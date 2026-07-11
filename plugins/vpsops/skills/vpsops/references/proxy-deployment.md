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

Choose a generic public target at runtime rather than copying a user's former target or hard-coding one into the skill. Verify from the server that the candidate resolves, accepts TLS, supports the intended ALPN, and is reachable reliably. Record only the selection rationale, not user-specific hostnames or keys. Do not use ordinary Cloudflare DNS proxying to hide a raw Reality TCP listener; it is not a substitute for a compatible TCP proxy service.

## Completion Tests

Verify container/service status, listener and firewall scope, relay-to-landing connectivity where applicable, actual client connection, intended outbound IP, fallback path, and the requested client/app behavior. Keep the old path until all tests pass and the user approves retirement.
