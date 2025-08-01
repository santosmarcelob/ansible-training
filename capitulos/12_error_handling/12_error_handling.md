# Capítulo 12: Error Handling no Ansible

## Introdução

Ao automatizar tarefas com Ansible, é inevitável encontrar falhas — sejam elas conexões instáveis, comandos malformados ou serviços indisponíveis. Para que seus playbooks sejam **robustos**, **seguros** e **resilientes**, é fundamental dominar o tratamento de erros (error handling).

Este capítulo apresenta os principais recursos e boas práticas de tratamento de erros no Ansible, com foco em exemplos práticos.

---

## Falhas em Tarefas: Comportamento Padrão

Por padrão, se uma tarefa falhar em um host, o Ansible:

- Marca o host como `FAILED`
- Para a execução para aquele host
- Continua nos demais hosts (salvo exceções)

### Exemplo:

```yaml
- name: Tarefa que vai falhar
  command: /bin/false
```

---

## Ignorando Falhas: `ignore_errors`

Use `ignore_errors: true` para continuar a execução mesmo se a tarefa falhar.

```yaml
- name: Tentar algo arriscado
  command: /bin/false
  ignore_errors: true

- name: Esta tarefa ainda será executada
  debug:
    msg: "Continuação após falha"
```

> ⚠️ Atenção: `ignore_errors` não afeta o status da tarefa — ela ainda será marcada como `FAILED`, apenas não interrompe o play.

---

## Manipulando o Resultado com `failed_when`

Com `failed_when`, você pode personalizar a lógica que determina se uma tarefa falhou ou não.

### Exemplo: Não falhar se erro for específico

```yaml
- name: Rodar script que pode gerar aviso
  shell: ./verifica.sh
  register: resultado
  failed_when: "'ALERTA' in resultado.stderr"
```

> Isso permite que você trate erros esperados sem parar o playbook.

---

## Controlando a Continuação com `block`, `rescue` e `always`

O Ansible oferece um sistema parecido com `try/catch/finally` usando:

- `block:` → bloco principal
- `rescue:` → executado se algo no bloco principal falhar
- `always:` → executado sempre, falhe ou não

### Exemplo prático:

```yaml
- name: Exemplo com bloco de tratamento
  hosts: all
  tasks:
    - block:
        - name: Tarefa principal (falha)
          command: /bin/false

        - name: Nunca será executada
          debug:
            msg: "Tudo certo"

      rescue:
        - name: Tratar erro
          debug:
            msg: "Tarefa falhou, executando fallback"

      always:
        - name: Sempre executar
          debug:
            msg: "Finalizando bloco"
```

---

## Usando `when` com status de tarefas

Você pode usar as propriedades `failed`, `skipped` ou `changed` de uma tarefa registrada para tomar decisões condicionais:

```yaml
- name: Tentar instalar pacote
  apt:
    name: pacote_inexistente
    state: present
  register: resultado
  ignore_errors: true

- name: Agir se falhou
  debug:
    msg: "A instalação falhou"
  when: resultado.failed
```

---

## Parando a Execução Condicionalmente com `fail` e `assert`

### 1. Usando `fail`

Gera um erro manual com mensagem customizada.

```yaml
- name: Interromper se variável estiver vazia
  fail:
    msg: "Variável 'app_env' não definida"
  when: app_env is not defined
```

### 2. Usando `assert`

Verifica uma condição lógica e falha se for falsa.

```yaml
- name: Garantir sistema suportado
  assert:
    that:
      - ansible_os_family == 'Debian'
    fail_msg: "Este playbook só suporta Debian"
```

---

## Limitando Falhas: `max_fail_percentage` e `any_errors_fatal`

### 1. `max_fail_percentage`

Determina a porcentagem máxima de falhas permitida por batch.

```yaml
- name: Atualizar servidores em lotes
  hosts: all
  serial: 4
  max_fail_percentage: 25
  tasks:
    - name: Exemplo de tarefa
      shell: /bin/false
```

### 2. `any_errors_fatal: true`

Faz com que uma falha em qualquer host pare o play em todos os outros.

```yaml
- name: Interromper se um falhar
  hosts: all
  any_errors_fatal: true
  tasks:
    - command: /bin/false
```

---

## Estratégias para Diagnóstico

- Use `register:` para capturar detalhes de erro
- Use `ansible-playbook -v/-vvv` para verbosidade
- Combine com `debug:` para inspecionar `stdout`, `stderr`

### Exemplo:

```yaml
- name: Tentar comando
  shell: ./meuscript.sh
  register: resultado
  ignore_errors: true

- debug:
    msg: "STDERR: {{ resultado.stderr }}"
```

---

## Checklist de Aproveitamento do Capítulo

```yaml
✅ Checklist do Aluno
- [ ] Usei `ignore_errors` corretamente
- [ ] Manipulei falhas com `failed_when`
- [ ] Usei `block`, `rescue` e `always`
- [ ] Interrompi playbook com `fail` ou `assert`
- [ ] Usei `register` + `when` para tratar falhas
- [ ] Experimentei `max_fail_percentage` e `any_errors_fatal`
```

---

## Desafio Final

Crie um playbook que:

1. Tente instalar dois pacotes, sendo um inexistente
2. Use `register` para capturar falha
3. Registre erro e tome ação alternativa com `block`/`rescue`
4. Use `assert` para garantir que um arquivo foi criado corretamente
5. Finalize sempre com uma mensagem `debug` no `always`

Execute com:

```bash
ansible-playbook -i inventario.yml error-handling.yml
```

