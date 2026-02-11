````markdown
# 💻 Lenovo Vantage for NixOS

<p align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos-white.png" width="320" />
</p>

<p align="center">
  Lenovo Vantage utilities packaged natively for <b>NixOS</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/NixOS-Compatible-blue?logo=nixos&logoColor=white" />
  <img src="https://img.shields.io/badge/Linux-Supported-green?logo=linux" />
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" />
</p>

---

## 📖 Overview

This project brings **Lenovo Vantage functionality** to Linux, specifically packaged for **NixOS**.

Originally ported to Linux by [niizam](https://github.com/niizam/vantage), this repository provides a **fully declarative Nix derivation** ensuring the tool runs seamlessly inside the Nix ecosystem.

It allows Lenovo users to manage hardware-specific features such as:

- Battery conservation mode  
- Rapid charging  
- Input device configuration  
- Hardware management utilities  

All features are delivered through a lightweight graphical interface built around shell scripting.

---

## ⚙️ Features

### 🧊 Nix Native Packaging
- Built using `stdenv.mkDerivation`
- Fully reproducible and declarative

### 📦 Automatic Dependency Handling
Includes runtime wrapping for:

- `zenity`
- `xinput`
- `networkmanager`
- `pulseaudio`

### 🖥 Desktop Integration
- Application launcher entry
- Icon support
- Native system menu integration

### 🔒 Sandbox Compatible
- Shebang patching
- Runtime path corrections
- Compatible with Nix read-only store

---

## 🚀 Installation, Usage & Repository Layout

### ✅ System-Wide Installation

Add the package to your `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  (pkgs.callPackage (fetchTarball "https://github.com/nabilksabu/vantage-nix/archive/main.tar.gz") {})
];
````

Apply the configuration and rebuild your system:

```bash
sudo nixos-rebuild switch
```

---

### 🧪 Quick Test (Temporary Run)

Run without permanently installing:

```bash
nix-shell -p "(pkgs.callPackage (fetchTarball \"https://github.com/nabilksabu/vantage-nix/archive/main.tar.gz\") {})" --run vantage
```

---

### 📂 Repository Structure

```
├── default.nix    # Nix build definition
├── vantage.sh     # Core Linux port logic
├── icon.png       # Application icon
└── images/        # UI assets
```

---

## 🧠 Architecture

The Nix packaging wraps the original Bash utility and injects required binaries into the runtime `$PATH`.
This ensures the application functions correctly even on minimal NixOS installations.

---

## 🙌 Credits

### Original Linux Port

* [niizam](https://github.com/niizam)
  Developer who brought Lenovo Vantage features to Linux.

### NixOS Packaging

* [nabilksabu](https://github.com/nabilksabu)
  Maintains Nix derivation and ecosystem compatibility.

---

## 📜 License

This project is licensed under the **MIT License**.

---

<p align="center">
  Made for Lenovo users running NixOS
</p>
```
