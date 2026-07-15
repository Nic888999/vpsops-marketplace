# Topologies

## Single VPS

Use one machine for a low-complexity website, Docker service, personal application, or egress service. Expose only necessary ports. Keep the deployment, firewall, logs, and backups on that host. A single machine has fewer failure points but no path redundancy.

## Relay And Landing

Use this only when the user needs a separate ingress path or a different egress network.

```text
client -> relay public listener -> authenticated/encrypted service on landing -> internet
```

- Relay: expose only the listener needed by clients and SSH. Forward only to the fixed landing address and service port.
- Landing: allow SSH as needed; allow the service port only from known relay addresses. Do not expose an unnecessary direct listener.
- Keep an independently tested fallback: another relay, direct landing access, or a separate provider. Do not make a fallback depend on the same failing relay.

## Reference Host Comparison

When the user says to "reference" an existing relay or landing VPS, inspect it read-only and report a comparison before copying anything. State: source role and service mode; listener and backend boundary; firewall allowlist; address-family choice; logging/maintenance policy; and the requested new machine role. Mark each item as `reuse`, `adapt`, `exclude`, or `unknown`, and ask the user to approve the copy plan.

Do not infer that a reference authorizes its port numbers, firewall rules, HAProxy/Xray configuration, client nodes, proxy groups, direct rules, active-node selection, or local profile activation. A local-client change always needs its own approval.

## Personal Proxy Default

Apply this section only when the user explicitly requests a personal proxy, landing server, or relay path. The default stack is **VLESS + TCP + REALITY** on Xray. When a relay is needed, use HAProxy as a layer-4 TCP forwarder to the fixed landing listener.

- Do not use an unrelated protocol by default because a script or tutorial uses it.
- Pin the Xray container image to a tested version; never use `latest` for unattended deployments.
- On the landing machine, permit the service listener only from known relay addresses when relays exist.
- Verify configuration syntax and a real client connection before retiring an older path.
- Keep proxy routing separate from ordinary website, Docker, database, and panel deployments.

## Multi-relay And Dual Stack

Treat every IPv4 or IPv6 path as independent. Measure each path from the actual client network. Retain IPv6 as a selectable path only when the local ISP, client mode, firewall, DNS, and remote route are all stable. Do not claim a route is optimized from a single test IP or one traceroute.

## Client routing

Start with a simple default: local/private destinations direct and intended external traffic through the selected primary path. Add exceptions only for an explicitly identified site or app that needs a different egress. Keep rules readable, grouped, and backed up. Test configuration syntax before reload and let the user restart their local client when convenient.
