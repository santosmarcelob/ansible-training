# Módulo 01 - Introdução à Lógica com Ansible

Este módulo é voltado para a prática de lógica usando Ansible e YAML. Você irá usar **playbooks** com **condições**, **loops** e **variáveis** para construir soluções simples, mas representativas.

## 🧪 Exercícios

### Exercicio 01 - Verificar se um número é par ou ímpar
Use uma variável para armazenar um número e escreva uma tarefa que mostre se o número é **par** ou **ímpar**, usando `when`.

### Exercicio 02 - Imprimir números de 1 a 10
Use um loop `with_sequence` para imprimir os números de 1 a 10 usando `debug`.

### Exercicio 03 - Calcular a soma dos números de 1 até N
Use `set_fact` com um loop para somar os números de 1 até N, onde `N` é uma variável definida no playbook.

## ▶️ Como executar

```bash
cd exercicio_01
ansible-playbook -i inventory.ini main.yml
```

Compare o resultado com o arquivo `expected_output.txt`.
