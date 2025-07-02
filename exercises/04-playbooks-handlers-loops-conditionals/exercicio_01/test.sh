#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if grep -q "Serviço reiniciado com sucesso!" output.log; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi