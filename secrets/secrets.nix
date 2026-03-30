let
  pvgj = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJhieS1XLEEGjAEUQT9KW7QEeOwvIXmnnZ9xWQEfDQh root@pvgj";
  philip = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLcdbypsebwiqsfbHCoMOW7Trj8StZ8yByDTGTk4s6F";
in {
  "molly_vapid_privkey_env.age".publicKeys = [pvgj philip];
  "ldap_root_pw.age".publicKeys = [pvgj philip];
  "ldap_user_pw.age".publicKeys = [pvgj philip];
}
