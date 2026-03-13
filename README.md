<div>
  <h1 align="center">❄️ My NixOs Configs ❄️<p align="center" dir="auto"> </p></h1>
</div>

This repository contains my personal Nix configuration for **two machines** - a laptop and a homelab server. It uses Nix flakes, Home Manager (integrated as a NixOS module), and sops-nix for secrets. Everything is reproducible and deployable with a single command.

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

| Host      | Machine      | CPU       | GPU          | Role                                         |
| --------- | ------------ | --------- | ------------ | -------------------------------------------- |
| `victus`   | HP Victus 15 | i5-12450H | RTX 2050     | Daily driver laptop (Hyprland + GNOME)       |
| `homelab` | HP ENVY x360 | i5-6200U  | Intel HD 520 | Home server (Jellyfin, \*arr stack, Grafana) |

## 📁 Structure

```
dotfiles/
├── flake.nix                    # Entry point — one line per host
├── lib/                         # mkHost helper & shared functions
│
├── hosts/                       # Per-machine config (ONLY host-specific stuff)
│   ├── victus/                  #   Laptop — boot, audio, docker, LAMP, battery
│   └── homelab/                 #   Server — lid ignore, SSH, transcoding, firewall
│
├── modules/
│   ├── nixos/                   # System-level NixOS modules
│   │   ├── base.nix             #   Applied to ALL hosts (timezone, locale, git, tailscale)
│   │   ├── desktop/             #   Laptop-only (gnome, kde, hyprland, nvidia)
│   │   └── server/              #   Server-only (docker, jellyfin, monitoring, nginx)
│   └── home/                    # Home-manager modules (user-level)
│       ├── shell.nix            #   Zsh, aliases, oh-my-posh
│       ├── default.nix          #   Common CLI packages + imports
│       ├── programs/            #   alacritty, git, neovim, tmux, kitty, yazi
│       ├── desktop/             #   GNOME dconf settings
│       └── wm/                  #   Hyprland, waybar, dunst, scripts
│
├── users/                       # Per-user profiles
│   ├── rahul/                   #   Full desktop user (imports all home modules)
│   └── neo/                     #   Minimal server user (shell + programs only)
│
├── assets/                      # Wallpapers, oh-my-posh theme
└── secrets/                     # sops-nix encrypted secrets
```

## 🧩 Key Design Decisions

- **`meta.user`** is passed to all modules via `specialArgs` — **zero hardcoded usernames** anywhere
- **`config.time.timeZone`** is set once in `base.nix` and reused by all containers
- **Server module aggregator** — add a new service by creating a `.nix` file in `modules/nixos/server/`, no `flake.nix` edits needed
- **Per-user profiles** in `users/` — each user selects which home modules to import (desktop user vs. server user)

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
cp /etc/nixos/hardware-configuration.nix hosts/victus/hardware.nix
```

Build & apply - **one command does everything** (system + home-manager):

```bash
sudo nixos-rebuild switch --flake .#victus
```

For the homelab (remotely via SSH):

```bash
nixos-rebuild switch --flake .#homelab --target-host neo@homelab --use-remote-sudo
```

## ➕ Adding a New Host

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
  # is automatically applied from modules/nixos/base.nix

  users.users.${meta.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";
}
```

**4. Add one entry to `flake.nix`:**

```nix
nixosConfigurations = {
  victus  = myLib.mkHost { hostname = "victus";  user = "rahul"; homeModule = ./users/rahul; };
  homelab = myLib.mkHost { hostname = "homelab"; user = "neo";   extraModules = [...]; };
  myhost  = myLib.mkHost { hostname = "myhost";  user = "myuser"; };  # ← just this line
};
```

Then deploy:

```bash
sudo nixos-rebuild switch --flake .#myhost
```

## 👤 Adding a New User

Create a profile at `users/myuser/default.nix`:

```nix
{ config, pkgs, meta, ... }:
{
  imports = [
    ../../modules/home            # shell + packages + theme
    ../../modules/home/programs   # git, tmux, neovim, etc.
    # ../../modules/home/desktop  # GNOME dconf (desktop only)
    # ../../modules/home/wm       # Hyprland (desktop only)
  ];

  home.username = meta.user;
  home.homeDirectory = "/home/${meta.user}";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
```

Then reference it in `flake.nix` via `homeModule = ./users/myuser;`.

## 🔑 Home Manager

Home Manager is **integrated as a NixOS module** — no separate `home-manager switch` needed. When you run `nixos-rebuild switch`, it builds both system config and user environment atomically.

This is configured in `lib/default.nix` via the `mkHost` helper:

```nix
mkHost = { hostname, user ? "rahul", homeModule ? null, ... }:
  lib.nixosSystem {
    specialArgs = { meta = { inherit hostname user; }; };
    modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import homeModule;
        home-manager.extraSpecialArgs = { meta = { inherit hostname user; }; };
      }
    ];
  };
```

Pass `homeModule = ./users/username;` to enable it for a host, or omit it for headless servers.

---

<p align="center">
  Thank you ❤️
</p>
