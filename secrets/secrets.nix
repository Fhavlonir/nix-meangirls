{
  self,
  inputs,
  ...
}: let
in {
  age.secrets = {
    "molly_vapid_privkey_env.age".rekeyFile = ./molly_vapid_privkey_env.age;
    "ldap_root_pw.age".publicKeys = ./ldap_root_pw.age;
    "ldap_user_pw.age".publicKeys = ./ldap_user_pw.age;
  };
}
