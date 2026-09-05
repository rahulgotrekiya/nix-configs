# Terraform / IaC toolchain
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    terraform   # core IaC tool
    tflint      # linter - validates .tf against best-practice rules
    infracost   # cost estimation before apply
  ];

  environment.shellAliases = {
    tf      = "terraform";
    tfi     = "terraform init";
    tfp     = "terraform plan";
    tfa     = "terraform apply";
    tfd     = "terraform destroy";
    tfv     = "terraform validate";
    tff     = "terraform fmt";
    tfout   = "terraform output";
    tfstate = "terraform state list";
    tfws    = "terraform workspace list";
  };
}
