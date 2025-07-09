#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if grep -q "$(cat expected_output.txt | head -n 1)" output.log; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi
