# Terraform DevOps Learning Setup
# Provides Terraform CLI + companion tools for IaC practice
{ config, pkgs, meta, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core IaC tool
    terraform

    # Linter — validates .tf files against best-practice rules
    tflint

    # Cost estimation — shows monthly AWS cost before applying
    infracost
  ];

  # Convenience shell aliases (available system-wide in any bash/zsh session)
  environment.shellAliases = {
    tf        = "terraform";
    tfi       = "terraform init";
    tfp       = "terraform plan";
    tfa       = "terraform apply";
    tfd       = "terraform destroy";
    tfv       = "terraform validate";
    tff       = "terraform fmt";
    tfout     = "terraform output";
    tfstate   = "terraform state list";
    tfws      = "terraform workspace list";
  };
}
