#!/bin/bash
ansible-playbook -i inventory.ini main.yml --vault-password-file vault_pass.txt | tee output.log

if [[ -f /tmp/arquivo_vault.txt ]]; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi