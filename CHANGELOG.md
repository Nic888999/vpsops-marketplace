# Changelog

All notable changes to VPSOps are documented here.

## [0.1.2] - 2026-07-13

### Added

- A reusable REALITY target preflight script with repeated TLS 1.3, ALPN `h2`, certificate, redirect warnings, and HTTP checks.
- Billing-cycle monitoring rules for provider reset timestamps, mid-cycle baselines, bidirectional quotas, and unavailable counters.

### Fixed

- Removed fixed or popularity-based REALITY target selection; deployment now stops unless a candidate passes VPS-side checks and a real-client handshake.
- Prevented the read-only audit helper from blocking on interactive `sudo` or SSH password prompts, and fixed zero-count SSH failures being mislabeled as unavailable.
- Clarified that relay-to-landing telemetry is server-link health, not local user experience.

## [0.1.1] - 2026-07-12

### Added

- Public README, security policy, MIT license, and changelog.
- Marketplace metadata for repository, website, license, and discovery keywords.

### Changed

- Replaced the development cachebuster with the formal version `0.1.1`.
- Unified the plugin and skill display name as `VPSOps`.
- Limited default starter prompts to the three supported by the Codex interface.

## [0.1.0]

### Added

- Initial VPS lifecycle workflow: secure bootstrap, deployment, relay design, client delivery, monitoring, audits, and maintenance.
