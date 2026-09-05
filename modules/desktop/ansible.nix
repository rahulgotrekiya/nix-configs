# Ansible / configuration-management toolchain
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ansible       # core config-management tool
    ansible-lint  # linter - checks playbooks for best-practice violations
  ];

  environment.shellAliases = {
    ap      = "ansible-playbook";
    apv     = "ansible-playbook --verbose";
    apc     = "ansible-playbook --check";        # dry run
    apcd    = "ansible-playbook --check --diff";  # dry run + show diffs
    ai      = "ansible-inventory --list";
    aping   = "ansible all -m ping";
    alint   = "ansible-lint";
    agalaxy = "ansible-galaxy";
  };
}
