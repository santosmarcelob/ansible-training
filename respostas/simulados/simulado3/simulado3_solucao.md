Vault (vault.yml) Exemplo
```yaml
---
backup_password: "SenhaSecreta123"
backup_ssh_pubkey: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
```
Para criptografar:
```bash
ansible-vault encrypt vault.yml --vault-password-file .vault_pass.txt
```
ou
```bash
ansible-vault encrypt vault.yml
```