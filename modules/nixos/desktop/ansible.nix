# Ansible DevOps Learning Setup
# Provides Ansible CLI + companion tools for configuration management practice
{ config, pkgs, meta, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core configuration management tool
    ansible

    # Linter — checks playbooks for best-practice violations
    ansible-lint

    # Inventory/playbook formatter
    # (ansible-lint also handles some formatting)
  ];

  # Convenience shell aliases (available system-wide in any bash/zsh session)
  environment.shellAliases = {
    ap      = "ansible-playbook";
    apv     = "ansible-playbook --verbose";
    apc     = "ansible-playbook --check";       # dry run
    apcd    = "ansible-playbook --check --diff"; # dry run + show diffs
    ai      = "ansible-inventory --list";
    aping   = "ansible all -m ping";
    alint   = "ansible-lint";
    agalaxy = "ansible-galaxy";
  };
}
