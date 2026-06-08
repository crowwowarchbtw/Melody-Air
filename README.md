# Melody Air

<img width="1254" height="1254" alt="image" src="https://github.com/user-attachments/assets/029e8bfd-52d6-467a-b757-aae5d9cca7ab" />


Melody Air is a deeply hardened, telemetry-free, and standalone portable distribution framework built on top of the Opera One (Air) desktop core. It is engineered to permanently eliminate corporate spyware, tracking modules, and forced update loops that cause background performance degradation during high-intensity gaming sessions.

## The Core Mission: Pure Performance

Standard browser distributions actively utilize background loops to profile users, index behavior, and force silent updates. Melody Air disrupts this mechanism, shifting control back to the user by deploying an aggressive system-purging script that strips the engine down to its essential binary elements.

### Key Architectural Overhauls

* **Spyware & Telemetry Eradication**
  The deployment script recursively scans the installation directory and completely obliterates integrated analytical daemons and reporting components (`opera_crashreporter.exe` and related telemetry hooks). No silent data packets, no background tracking sockets.
* **Forced Update Interdiction (Broken Updates)**
  Background updates are completely blocked by purging the native update infrastructure (`opera_autoupdate.exe` and `opera_autoupdate.gup`). This guarantees that your browser environment remains locked at the deployment version, eliminating sudden CPU spikes and unwanted automated patches.
* **True Portable Confinement**
  By hardcoding internal runtime configuration arrays (`sidekick.config`) and applying the `/standalone` environment vector, the browser is entirely sandboxed inside `C:\MelodyAir`. It leaves zero residue data in the host machine's `%APPDATA%`, `%LOCALAPPDATA%`, or Windows Registry strings.
* **First-Run Welcome Suppression**
  The framework injects automated static verification markers (`First Run`) across the directory matrix. This deceives the internal Chromium wizard, completely blinding the browser's introductory setup sequence. Users bypass promotional splash screens, mandatory account creation prompts, and aggressive cookie-consent walls on startup.
* **Local DPAPI Cryptographic Alignment**
  To prevent the profile resets triggered by Chromium's hardware-bound HMAC encryption (Windows DPAPI), version 0.1 allows the browser engine to natively sign a fresh local database. You get a perfectly stable foundation that allows you to configure everything manually from scratch without facing silent corruption resets.

## Installation and Deployment

1. Download the latest release package as a `.zip` archive.
2. **Extract the archive** completely into any regular directory on your system (do not run files from within the compressed folder).
3. Execute **`install.bat`** (the script automatically applies `-ExecutionPolicy Bypass` to temporarily suspend restrictive host Windows execution arrays).
4. Once deployment stabilizes, launch the browser exclusively via the master launcher: `C:\MelodyAir\launcher.exe`.

## Technical Specifications

* **Base Core:** Opera Desktop Core (One/Air Engine)
* **Target Directory:** `C:\MelodyAir`
* **Network Sockets:** Hardened (Inbound analytics blocked)
* **Process Priority Hooks:** Isolated

## License

Distributed under the Apache License 2.0. See `LICENSE` for more information. Developed by crowwowarchbtw.
