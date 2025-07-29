# Capítulo 11: Strategies no Ansible

## O que são Strategies no Ansible

No Ansible, uma *strategy* define **como** as tarefas são executadas nos hosts em um playbook. Por padrão, o Ansible executa as tarefas de forma *sincronizada* em todos os hosts, um passo por vez. Mas à medida que os ambientes se tornam maiores ou mais dinâmicos, pode ser vantajoso adotar uma strategy diferente para melhorar desempenho ou tolerância a falhas.

### Por que strategies importam?
- Otimização de tempo em execuções longas
- Melhor controle sobre hosts com falhas
- Execução mais responsiva e paralela

---

## Tipos de Strategies Disponíveis

O Ansible vem com 3 strategies principais:

### 1. `linear` (padrão)
Executa uma tarefa por vez em todos os hosts. Passa para a próxima tarefa apenas quando todos os hosts completam a atual.

**Visualmente:**
```
Tarefa 1: host1, host2, host3
Tarefa 2: host1, host2, host3
```

### 2. `free`
Permite que cada host execute as tarefas em seu próprio ritmo. Hosts mais rápidos não precisam esperar os mais lentos.

**Visualmente:**
```
host1: T1, T2, T3...
host2: T1 ------> T2
```

### 3. `host_pinned`
Execução semelhante ao `free`, mas fixa cada worker (processo de execução) a um host específico. Pode melhorar performance em alguns cenários.

**Diferença técnica entre free e host_pinned**

**free**: o Ansible usa uma fila de tarefas e vai alocando workers para os hosts conforme eles ficam livres. A associação entre worker e host não é fixa.

**host_pinned**: o Ansible fixa cada worker em um host até o final do play. Isso pode reduzir sobrecarga de reatribuição e aumentar performance em execuções longas.

---

## Como Definir uma Strategy

Você pode definir a strategy de três formas:

### 1. No próprio playbook:
```yaml
- name: Executar em paralelo
  hosts: all
  strategy: free
  tasks:
    - name: Esperar alguns segundos
      wait_for:
        timeout: 5
```

### 2. Via `ansible.cfg`:
```ini
[defaults]
strategy = free
```

### 3. Via linha de comando (temporariamente):
```bash
ANSIBLE_STRATEGY=free ansible-playbook playbook.yml
```

---

## Exemplo Comparativo na Prática

### Playbook para Teste de Strategy
```yaml
- name: Testar diferentes strategies
  hosts: all
  gather_facts: false
  strategy: linear  # ou free ou host_pinned
  tasks:
    - name: Pausa de 10 segundos
      pause:
        seconds: 10
    - name: Exibir mensagem
      debug:
        msg: "Host {{ inventory_hostname }} terminou"
```

### Execução:
```bash
ansible-playbook -i hosts test-strategy.yml
```

### Resultado Esperado:
- Com `linear`: todos os hosts esperam juntos.
- Com `free`: cada host termina no seu tempo.

---

## Strategy Plugins Personalizados

É possível criar suas próprias strategies como *plugins*. Isso é avançado, mas pode ser útil em ambientes com requisitos especiais (ex: interrupção condicional, paralelismo personalizado).

**Diretório padrão de plugins:**
```
~/.ansible/plugins/strategy/
ou
project_root/strategy_plugins/
```

**Exemplo mínimo de plugin:**
```python
# strategy_plugins/custom_linear.py
from ansible.plugins.strategy.linear import StrategyModule as LinearStrategy

class StrategyModule(LinearStrategy):
    name = 'custom_linear'

    def run(self, iterator, play_context):
        self._display.banner("Usando strategy customizada!")
        return super().run(iterator, play_context)
```

**Habilitar em `ansible.cfg`:**
```ini
[defaults]
strategy_plugins = ./strategy_plugins
strategy = custom_linear
```

---

## Boas Práticas com Strategy

- Use `linear` para execuções previsíveis e seguras.
- Use `free` para otimização de tempo quando não houver dependências entre hosts.
- Combine com `serial`, `max_fail_percentage`, `any_errors_fatal` para controle fino.

**Exemplo com `serial` e `free`:**
```yaml
- name: Atualização em lotes
  hosts: all
  serial: 2
  strategy: free
  tasks:
    - name: Atualizar pacotes
      apt:
        upgrade: dist
```

---

## Checklist de Aproveitamento do Capítulo

```yaml
✅ Checklist do Aluno
- [ ] Sei o que são strategies e para que servem
- [ ] Testei `linear`, `free` e `host_pinned`
- [ ] Configurei strategy no playbook e no ansible.cfg
- [ ] Executei o mesmo playbook com strategies diferentes
- [ ] Usei `serial` com strategy
- [ ] Experimentei criar ou usar plugin de strategy
```

---

## Desafio Final

1. Crie um playbook com 3 tarefas:
    - Uma pausa de 5 segundos
    - Um `debug` mostrando o nome do host
    - Uma tarefa de escrita em arquivo (`copy`)

2. Execute-o com cada uma das strategies:
    - `linear`
    - `free`
    - `host_pinned`

3. Cronometre o tempo total de execução com cada uma. Qual foi mais eficiente?

4. Escreva um `ansible.cfg` com strategy padrão definida como `host_pinned` e experimente rodar um segundo playbook sem strategy definida.

**Objetivo:** Entender o impacto real da strategy escolhida na performance e comportamento do playbook.

