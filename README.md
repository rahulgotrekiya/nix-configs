<div>
  <h1 align="center">❄️ My NixOs Configs ❄️<p align="center" dir="auto"> </p></h1>
</div>

This repository contains my personal Nix configuration for **two machines** — a laptop and a homelab server. It uses Nix flakes, Home Manager (integrated as a NixOS module), and sops-nix for secrets. Everything is reproducible and deployable with a single command.

---

## ⚡ Screenshots
<div align="center">
  <img  align="center" src="https://github.com/user-attachments/assets/7a398c64-6659-4a14-bb7b-fec38b3dc40c" width="800">
</div>
<br>
<div align="center">
  <img  align="center" src="https://github.com/user-attachments/assets/87c925ac-da51-4e1c-aab3-b274d7700415" width="800">
</div>

## 🖥️ Machines

| Host | Machine | CPU | GPU | Role |
|---|---|---|---|---|
| `nixos` | HP Victus 15 | i5-12450H | RTX 2050 | Daily driver laptop (Hyprland + GNOME) |
| `homelab` | HP ENVY x360 | i5-6200U | Intel HD 520 | Home server (Jellyfin, *arr stack, Grafana) |

## 📁 Structure

```
dotfiles/
├── flake.nix              # Entry point — mkHost helper, one line per host
│
├── hosts/                 # Per-machine config (ONLY host-specific stuff)
│   ├── nixos/             # Laptop — boot, audio, docker, LAMP, battery
│   └── homelab/           # Server — lid ignore, SSH, transcoding, firewall
│
├── modules/               # Shared & opt-in NixOS modules
│   ├── base.nix           # Applied to ALL hosts (timezone, locale, git, tailscale)
│   ├── desktop/           # Laptop-only (gnome, kde, hyprland, nvidia)
│   └── server/            # Server-only (docker, jellyfin, monitoring, nginx)
│
├── home/                  # Home Manager config (integrated into nixos-rebuild)
│   ├── default.nix        # Entry point
│   ├── shell.nix          # Zsh, aliases, oh-my-posh
│   ├── programs/          # alacritty, git, neovim, tmux, kitty, yazi
│   ├── wm/hyprland/       # Waybar, mako, scripts, swaync
│   └── themes/            # Prompt theme, wallpapers
│
└── secrets/               # sops-nix encrypted secrets
    ├── sops.nix
    ├── common/
    └── homelab/
```

## ⚙️ Usage

### Prerequisites

Enable flakes in your system (add to `/etc/nixos/configuration.nix`):

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

### Clone & Apply

```bash
git clone https://github.com/rahulgotrekiya/nix-configs.git ~/dotfiles
cd ~/dotfiles
```

Replace the hardware config with your own:

```bash
cp /etc/nixos/hardware-configuration.nix hosts/nixos/hardware.nix
```

Build & apply - **one command does everything** (system + home-manager):

```bash
sudo nixos-rebuild switch --flake .#nixos
```

For the homelab (remotely via SSH):

```bash
nixos-rebuild switch --flake .#homelab --target-host neo@homelab --use-remote-sudo
```

## ➕ Adding a New Host

Adding a new machine is a 4-step process:

**1. Create the host directory:**

```bash
mkdir -p hosts/myhost
```

**2. Add hardware config:**

```bash
# On the target machine:
nixos-generate-config --show-hardware-config > hosts/myhost/hardware.nix
```

**3. Create `hosts/myhost/default.nix`** with only host-specific settings:

```nix
{ config, pkgs, meta, ... }:
{
  imports = [ ./hardware.nix ];
  
  # Only what's unique to this host goes here.
  # Shared config (timezone, git, nix settings, tailscale)
  # is automatically applied from modules/base.nix
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";
}
```

**4. Add one entry to `flake.nix`:**

```nix
nixosConfigurations = {
  nixos   = mkHost { hostname = "nixos"; homeModule = ./home; };
  homelab = mkHost { hostname = "homelab"; user = "neo"; extraModules = [...]; };
  myhost  = mkHost { hostname = "myhost"; };  # ← just this line
};
```

Then deploy:

```bash
sudo nixos-rebuild switch --flake .#myhost
```

## 🔑 Home Manager

Home Manager is **integrated as a NixOS module** — no separate `home-manager switch` needed. When you run `nixos-rebuild switch`, it builds both system config and user environment atomically.

This is configured in `flake.nix` via the `mkHost` helper:

```nix
mkHost = { hostname, user ? "rahul", homeModule ? null, ... }:
  lib.nixosSystem {
    modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import homeModule;
      }
    ];
  };
```

Pass `homeModule = ./home;` to enable it for a host, or omit it for headless servers.

---

<p align="center">
  Thank you ❤️
</p>
