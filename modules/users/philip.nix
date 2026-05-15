{config, ...}: let
  inherit (config) vars;
in {
  flake.modules.nixos.philip = _: {
    users.users."philip.johansson" = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = vars.sshAuthorizedKeys;
    };
  };
}
