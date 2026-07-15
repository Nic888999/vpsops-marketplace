# Local Client Delivery

## Scope

Use after a server or relay path is verified, or when maintaining an existing client. Ask which device, operating system, proxy app, and exact core version the user uses. If no client is installed, explain two or three suitable current options and let the user choose. A server-only deployment is incomplete until an approved client path can use it.

## Discover Before Writing

Identify the device OS, installed client and core version, active profile, operating mode, current primary/fallback groups, existing exceptions, DNS/TUN/IPv6 state, and whether a restart would interrupt the user. Preserve the current client and create a dated local backup before edits.

Server deployment authorization does not authorize local work. Inspect the client read-only first. Before writing, list the exact local file paths, node names, groups, rules, DNS/TUN/IPv6 effects, whether runtime reload or node switching is proposed, and the rollback. Wait for explicit approval of that local scope. Do not conflate an IP direct rule, a proxy node, a proxy group, and a routing-policy rule.

Phrases such as “you can look,” “check my client,” or “help me configure later” authorize inspection or planning only. They do not authorize a file edit, runtime API call, reload, restart, profile activation, node switch, or routing change.

When the only immediate problem is SSH blocked by the local proxy/TUN, use the access-unblock decision in `bootstrap.md`. Do not treat it as client delivery and do not make a persistent direct rule by default.

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
- Prefer an isolated temporary test profile or a user-imported node before integrating with an active profile. Protect and remove temporary client material after the test.
- Validate configuration before reload where the client supports it. Do not edit the active runtime, reload/restart/quit the client, switch a selected group, or alter routing without explicit approval for that exact action; otherwise tell the user how to perform the manual action.
- Treat activating a subscription/profile and selecting a proxy node as state-changing actions. Do not perform either merely to test a new relay. If the user has not authorized local testing, complete only server-side validation and mark device acceptance as pending.
- Never put private keys, access tokens, subscription URLs, UUIDs, or personal routing history into the skill, inventory, Git, or report.

## Acceptance And Handoff

Test: mainland direct, normal external path, each fallback, every requested exception, DNS behavior, TUN-dependent apps if enabled, IPv4/IPv6 paths selected by the user, and IP/geolocation expectations where relevant. State which tests are server-side versus performed on the actual device. Leave the user with the backup location, chosen primary/fallback, exact manual reload/import step, exception template, and rollback action.
