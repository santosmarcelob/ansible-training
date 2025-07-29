# Desafio: Criando e Comparando Strategies no Ansible
## Objetivo: Construir playbooks que usem diferentes strategies (linear, free e host_pinned) para entender como cada uma afeta a execução das tarefas entre múltiplos hosts.

### Requisitos

Você deve:

- Criar um inventário com dois ou mais hosts (use localhost se necessário);
- Criar um playbook base com 3 tarefas;
- Executar o mesmo playbook usando três strategies diferentes;
- Medir e comparar os tempos de execução;
- Explicar, ao final, qual strategy foi mais eficiente e por quê.

**Etapas Obrigatórias**
1. Criar um inventário chamado inventory.yml
Inclua pelo menos dois hosts (simulados com localhost, se necessário):

Dica: use o parâmetro ansible_connection: local para simular múltiplos hosts na mesma máquina.

Exemplo:

```ini
[all]
host1 ansible_connection=local
host2 ansible_connection=local
```

2. Criar um arquivo chamado mensagem.txt com o seguinte conteúdo:

```text
Este arquivo foi gerado por Ansible.
```

Salve como: arquivos/mensagem.txt

3. Criar um playbook chamado strategy_test.yml com as seguintes 3 tarefas obrigatórias:

- Uma pausa de 10 segundos (pause);
- Um debug com o nome do host;
- Copiar o arquivo mensagem.txt para /tmp/mensagem_<hostname>.txt.

**Não defina nenhuma strategy neste playbook ainda.**

4. Executar o playbook 3 vezes, cada vez com uma strategy diferente

Exemplo:

```bash
ANSIBLE_STRATEGY=linear ansible-playbook -i inventory.yml strategy_test.yml
```

Cronometre o tempo com: `time`
