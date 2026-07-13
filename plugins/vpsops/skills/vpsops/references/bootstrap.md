# First Access And SSH Safety

## Establish the starting point

Collect only in the active session:

- provider and the relevant order email, official access instructions, or access-page screenshot;
- power state, current public IPv4, whether IPv6 was assigned, and whether the user wants IPv6 configured and tested;
- actual SSH port, initial user, and authentication method; never assume `root:22`;
- provider firewall/security-group state and whether a web console, rescue console, or VNC is available;
- private-key file path if the provider issued a key;
- whether changing a cloud-init key requires a full power cycle.

Do not move from access discovery into bootstrap until IPv6 is recorded as `assigned + approved`, `assigned + declined`, or `unavailable`. If the panel is unclear, ask the user to open its network/address page or provide a redacted screenshot.

For a beginner, guide them through the provider panel or official documentation using the provider's actual labels. Ask for a screenshot when needed. Do not tell them merely to "check port 22," perform a broad port scan, or reboot repeatedly. Check whether a local VPN, Clash/sing-box TUN mode, proxy, or route captures the SSH destination; inspecting or changing that local client is a separate permission scope.

Before accepting a previously unseen SSH host key, compare its fingerprint with the provider console or another trusted channel when available. `StrictHostKeyChecking=accept-new` is trust-on-first-use, not identity verification.

Do not ask for, echo, or place passwords or private-key contents in chat, notes, scripts, audit reports, or command history. Use an interactive password prompt or provider console. If the user already exposed a password, do not repeat it; rotate it only after a verified recovery path exists.

## Password-first provider

1. Connect interactively as the provider's initial user or root.
2. Create a named sudo user and choose the administration model with the user: password-protected sudo, or explicit `NOPASSWD` with the warning that possession of the SSH private key then grants root access.
3. Generate a local Ed25519 key if the workstation has no appropriate key: `ssh-keygen -t ed25519`.
4. Add only the public key to the new user's `authorized_keys` with correct directory and file permissions.
5. Keep the original privileged session open. In a second terminal, confirm key-only login and actual root escalation: use interactive `sudo -v` for password-protected sudo, or validate a `0440` sudoers drop-in with `visudo -cf` and require `sudo -n id -u` to return `0` for `NOPASSWD`.
6. Back up SSH configuration, allow the confirmed SSH port through both provider and host firewalls, add a validated drop-in, check with `sshd -t`, and reload SSH.
7. In a third terminal, confirm key-only login and root escalation again, then inspect the effective SSH policy.
8. Only after all sessions and the provider-console recovery path work may root login and password authentication be disabled.

## Key-only provider

Use the provider-supplied key, exact provider username, and documented port first. Protect the local key file and do not enable password authentication merely for convenience. Create a personal sudo user and key only after access works, then apply the same key-plus-root-escalation gates above. Some providers inject SSH keys through cloud-init and require a shutdown then start cycle after a key replacement; follow the provider warning and confirm the new key after the full power cycle before removing the old one.

## If access fails

Classify the symptom before changing anything: a timeout usually points to power, route, or firewall; connection refused means the host is reachable but no listener accepted the port; disconnect before the SSH banner suggests sshd, ACL/fail2ban, or local proxy/TUN interference; authentication failure points to user, key, password, or permissions.

Check, in this order:

1. power state and current public IP in the provider panel;
2. provider firewall/security-group and SSH port;
3. whether the correct username, port, and key file are being used;
4. local network restrictions and IPv4 versus IPv6 reachability;
5. provider console or rescue environment.

Do not repeatedly alter SSH, firewall, or credentials without a known-good recovery path.

## Recommended SSH baseline

Use a non-root sudo user. Enable public keys, set `PermitRootLogin no`, set `PasswordAuthentication no`, restrict `AllowUsers`, and keep `MaxAuthTries` low. The SSH port is an operational choice, not a primary security control. Protect the account with key-only login and firewall rules.

At handoff, provide a copy-ready command using the actual values, for example `ssh -i ~/.ssh/id_ed25519 -p 48222 admin@203.0.113.10`. Include the provider-console recovery path; do not expose a password in the command.
