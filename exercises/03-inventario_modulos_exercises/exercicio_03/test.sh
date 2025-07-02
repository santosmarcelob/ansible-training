#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if grep -q "Olá, Ansible!" output.log; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi
