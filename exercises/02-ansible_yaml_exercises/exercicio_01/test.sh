#!/bin/bash
ansible-playbook -i inventory.ini main.yml | tee output.log

if grep -q "Este é meu primeiro playbook Ansible!" output.log; then
  echo "✅ Teste passou"
else
  echo "❌ Teste falhou"
fi
