#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if grep -q "Este é o conteúdo do arquivo." output.log; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi