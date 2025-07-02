#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if grep -q "name = MeuApp" /tmp/config.ini && grep -q "port = 8080" /tmp/config.ini; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi