let
  pvgj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJhieS1XLEEGjAEUQT9KW7QEeOwvIXmnnZ9xWQEfDQh root@pvgj";
in {
  "molly_vapid_privkey_env.age".publicKeys = [pvgj];
}
