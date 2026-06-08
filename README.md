# Melody Air

<p align="center">
  <img src="https://github.com/user-attachments/assets/1cda7e47-3da7-4db8-bcef-ec91af502ea0" width="150" alt="Melody Air Logo">
</p>

> **Main Project:** This is a streamlined edition of our primary framework, [MelodyGX](https://github.com/crowwowarchbtw/MelodyGX), specifically adapted for the Opera One (Air) desktop core.

Melody Air is a practical, portable deployment script built on top of the Opera One (Air) desktop engine. We are not trying to be heroes or reinvent the wheel here—this framework simply strips out the user tracking, proprietary telemetry, and forced background update loops that shouldn't have been running on your machine in the first place.

## What It Actually Does

Standard browser builds constantly run background tasks to profile your behavior, log analytics, and push silent updates that disrupt system performance. Melody Air removes this fluff, giving you a clean, isolated standalone browser that leaves your system resources alone.

### Core Enhancements

* **Telemetry Stripping**
  The script locates and permanently purges integrated analytical daemons and crash reporters (`opera_crashreporter.exe` and tracking hooks). No automated data packets, no background metrics collection.
* **Forced Update Interdiction**
  Background update cycles are completely blocked by deleting the update binaries (`opera_autoupdate.exe` and `opera_autoupdate.gup`). Your browser version remains locked exactly where you deployed it, preventing sudden CPU spikes and forced changes.
* **True Portable Confinement**
  By utilizing `sidekick.config` and the native `/standalone` flag, the entire runtime environment is locked inside `C:\MelodyAir`. It doesn't write data to the host registry or leak temporary cache files into `%APPDATA%` or `%LOCALAPPDATA%`.
* **First-Run Suppression**
  The script injects automated `First Run` marker files directly into the data matrix. This fools the browser into thinking it has already been launched before, completely bypassing welcome wizards, promo screens, and tracking cookie prompts on startup.
* **Native Profile Generation**
  Instead of fighting Chromium's machine-bound HMAC encryption (Windows DPAPI) with pre-configured profile clones, version 0.1 lets the engine natively sign a clean local profile on the target system. You get a stable, uncorrupted foundation to configure your personal preferences from scratch.

## Installation and Deployment

1. Download the repository as a `.zip` archive.
2. **Extract the archive** completely to a local folder (do not execute scripts inside the compressed ZIP folder).
3. Run **`install.bat`** (the batch file automatically bypasses Windows execution restrictions via `-ExecutionPolicy Bypass`).
4. Always launch the browser using the master binary at `C:\MelodyAir\launcher.exe`.

## Technical Specifications

* **Base Core:** Opera Desktop Core (One/Air Engine)
* **Target Directory:** `C:\MelodyAir`
* **Primary Objective:** Telemetry removal and environment isolation

## License

Distributed under the Apache License 2.0. Developed by crowwowarchbtw.
