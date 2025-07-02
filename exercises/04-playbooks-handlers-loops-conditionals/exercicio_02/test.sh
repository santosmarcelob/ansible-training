#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if [[ -f /tmp/arquivo_1.txt && -f /tmp/arquivo_2.txt && -f /tmp/arquivo_3.txt ]]; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi