# First Access And SSH Safety

## Establish the starting point

Collect only in the active session:

- provider and whether a web console, rescue console, or VNC is available;
- public address, SSH port, current user, and current authentication method;
- private-key file path if the provider issued a key;
- whether changing a cloud-init key requires a full power cycle.

Before accepting a previously unseen SSH host key, compare its fingerprint with the provider console or another trusted channel when available. `StrictHostKeyChecking=accept-new` is trust-on-first-use, not identity verification.

Do not place passwords or private-key contents in notes, scripts, audit reports, or command history.

## Password-first provider

1. Connect interactively as the provider's initial user or root.
2. Create a named sudo user.
3. Generate a local Ed25519 key if the workstation has no appropriate key: `ssh-keygen -t ed25519`.
4. Add only the public key to the new user's `authorized_keys` with correct directory and file permissions.
5. Open a second terminal and confirm that key-only login works.
6. Back up SSH configuration, add a validated drop-in, check with `sshd -t`, allow the SSH port through the firewall, and reload SSH.
7. Only after the second session works, disable root login and password authentication.

## Key-only provider

Use the provider-supplied key and exact provider username first. Do not enable password authentication merely for convenience. Create a personal sudo user and key only after access works. Some providers inject SSH keys through cloud-init and require a shutdown then start cycle after a key replacement; follow the provider warning and confirm the new key before removing the old one.

## If access fails

Check, in this order:

1. power state and current public IP in the provider panel;
2. provider firewall/security-group and SSH port;
3. whether the correct username, port, and key file are being used;
4. local network restrictions and IPv4 versus IPv6 reachability;
5. provider console or rescue environment.

Do not repeatedly alter SSH, firewall, or credentials without a known-good recovery path.

## Recommended SSH baseline

Use a non-root sudo user. Enable public keys, set `PermitRootLogin no`, set `PasswordAuthentication no`, restrict `AllowUsers`, and keep `MaxAuthTries` low. The SSH port is an operational choice, not a primary security control. Protect the account with key-only login and firewall rules.
