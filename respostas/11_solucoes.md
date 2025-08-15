# Respostas e Exemplos
### Exercício 1 – Resposta
``` yaml
# test_strategy.yml
- name: Testar diferentes strategies
  hosts: all
  gather_facts: false
  strategy: free  # ou linear ou host_pinned
  tasks:
    - name: Aguardar 5 segundos
      pause:
        seconds: 5

    - name: Exibir nome do host
      debug:
        msg: "Host {{ inventory_hostname }} pronto"

    - name: Copiar README
      copy:
        src: README.txt
        dest: /tmp/README.txt
```

Resultado esperado: free termina mais rápido em ambientes com hosts mais rápidos.

### Exercício 2 – Resposta
``` ini
# ansible.cfg
[defaults]
strategy = host_pinned
```
Execute:

``` bash
ansible-playbook -i inventory.yml test_strategy.yml
```

Resultado: O Ansible usará host_pinned como strategy padrão.

### Exercício 3 – Resposta
``` yaml
# update_batch.yml
- name: Atualização em lotes
  hosts: all
  become: yes
  serial: 2
  strategy: free
  tasks:
    - name: Atualizar pacotes
      apt:
        upgrade: dist
        update_cache: yes
      when: ansible_os_family == 'Debian'

    - name: Atualizar pacotes RHEL
      yum:
        name: '*'
        state: latest
      when: ansible_os_family == 'RedHat'
```

### Exercício 4 – Resposta
``` yaml
- name: Teste de falha com interrupção
  hosts: all
  strategy: free
  any_errors_fatal: true
  tasks:
    - name: Gerar falha em um host
      command: /bin/false
```

Resultado: ao falhar em um host, todos os outros param imediatamente.

### Exercício 5 – Resposta
Compare os tempos e ordem dos logs. Com:

linear: todos sincronizados

free: cada host termina sozinho

host_pinned: semelhante ao free, com workers fixos

### Exercício 6 – Resposta
```bash
ANSIBLE_STRATEGY=free ansible-playbook test_strategy.yml
```

Resultado: strategy forçada para free, mesmo sem estar no playbook ou cfg.

### Exercício 7 – Resposta
Arquivo: strategy_plugins/custom_banner.py

```python
from ansible.plugins.strategy.linear import StrategyModule as LinearStrategy

class StrategyModule(LinearStrategy):
    name = 'custom_banner'

    def run(self, iterator, play_context):
        self._display.banner("Executando minha strategy personalizada!")
        return super().run(iterator, play_context)
```

ansible.cfg:

```ini
[defaults]
strategy_plugins = ./strategy_plugins
strategy = custom_banner
```

### Exercício 8 – Resposta
``` yaml
- name: Executar tarefas incluídas com strategy
  hosts: all
  strategy: free
  tasks:
    - name: Incluir tarefas
      include_tasks: tasks/tasks.yml
```

tasks/tasks.yml:

``` yaml
- pause: { seconds: 5 }
- debug: { msg: "Tarefa incluída executada" }
```

Resultado: O strategy continua válido dentro do include_tasks.

### Exercício 9 – Resposta
``` yaml
- name: Executar com strategy linear e serial
  hosts: all
  strategy: linear
  serial: 2
  tasks:
    - name: Verificar conectividade
      ping:
```

Resultado: 2 hosts por vez, mantendo sincronismo entre tarefas.

### Exercício 10 – Resposta
Monte uma planilha com colunas:

Nome do playbook

Strategy usada

Tempo de execução (cronômetro manual ou time no terminal)

Conclusão esperada:

linear: mais previsível, mas mais lento

free: ideal para paralelismo e ganho de tempo

host_pinned: boa alternativa para clusters grandes

serial: ótimo para atualizações em ondas

any_errors_fatal: útil para segurança e rollback