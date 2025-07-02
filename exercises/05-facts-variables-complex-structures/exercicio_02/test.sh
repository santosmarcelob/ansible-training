#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if [[ -f /tmp/arquivo1.txt && -f /tmp/arquivo2.txt && -f /tmp/arquivo3.txt ]]; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi