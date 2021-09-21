resource "random_pet" "friendly_key_name" {
  prefix    = "vault_unseal_key"
  length    = 2
  separator = "_"
}

resource "random_pet" "friendly_keyring_name" {
  prefix    = "vault_unseal_keyring"
  length    = 2
  separator = "_"
}
