# Local Client Delivery

## Scope

Use after a server or relay path is verified, or when maintaining an existing client. A server-only deployment is incomplete until the requested client can use it.

## Discover Before Writing

Identify the device OS, installed client and core version, active profile, operating mode, current primary/fallback groups, existing exceptions, DNS/TUN/IPv6 state, and whether a restart would interrupt the user. Preserve the current client and create a dated local backup before edits.

Prefer the user's working client. For a new choice, verify current platform availability first. Typical defaults are a Mihomo-compatible client on macOS/Windows, sing-box where its current core supports the required configuration, and Shadowrocket for a simple iOS import workflow. Do not force an app change because a tutorial prefers it.

## Routing Model

Build readable semantic groups rather than provider-specific names:

1. `Primary`: selected direct or relay-to-landing path.
2. `Fallback`: independently tested direct landing or alternative relay.
3. `Airport`: optional provider group for explicit exceptions only.
4. `Mainland Direct`: maintained mainland domain/IP rules and local/private ranges.

Default mainland destinations to direct and intended external traffic to `Primary`. Add airport or location exceptions only after the user names the site/app and desired egress. Treat media, payment, Apple, gaming, and work apps as explicit policy decisions; do not assume a country requirement.

## Client Safety

- Keep proxy groups, rules, DNS, TUN, IPv6, and node definitions in the syntax supported by that exact client/core version.
- Do not carry deprecated sing-box or Mihomo syntax into a newer profile.
- Keep IPv4 and IPv6 independently selectable until both pass real-device tests. Do not force IPv6 merely because its latency is lower.
- Validate configuration before reload where the client supports it. Do not restart or quit the user's local proxy client unless explicitly asked; tell the user when a manual reload/restart is required.
- Never put private keys, access tokens, subscription URLs, UUIDs, or personal routing history into the skill, inventory, Git, or report.

## Acceptance And Handoff

Test: mainland direct, normal external path, each fallback, every requested exception, DNS behavior, TUN-dependent apps if enabled, and IP/geolocation expectations where relevant. State which tests are server-side versus performed on the actual device. Leave the user with the backup location, chosen primary/fallback, exception template, and rollback action.
