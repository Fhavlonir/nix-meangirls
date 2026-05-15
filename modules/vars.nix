{lib, ...}: {
  options.vars = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "philip.johansson";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Philip Johansson";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "philip.johansson@synotio.se";
    };
    sshAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICVYhZcVj1ZjwMNiaZAjyzrqo2wGVe6bVXddBNEivhldAAAABHNzaDo= philip.johansson@synotio.se"
      ];
      description = "SSH public keys authorized across all hosts";
    };
  };
}
