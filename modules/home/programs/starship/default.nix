{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      kubernetes.disabled = false;
      kubernetes.format = "[⎈ $context(/$namespace)]($style) ";
      aws.disabled = false;
      terraform.disabled = false;
      git_status.disabled = false;
    };
  };
}
