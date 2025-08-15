# Respostas com Exemplos
### Exercício 1 — Ignorar Falha
``` yaml
- name: Ignorar erro e continuar
  hosts: localhost
  tasks:
    - name: Tarefa que falha
      command: /bin/false
      ignore_errors: true

    - name: Continuar após falha
      debug:
        msg: "Seguimos mesmo com falha"
```

### Exercício 2 — failed_when personalizado
``` yaml
- name: Falha apenas se 'ERRO' na saída
  hosts: localhost
  tasks:
    - name: Rodar comando
      shell: echo "ALERTA: Aviso não crítico"
      register: saida
      failed_when: "'ERRO' in saida.stdout"
```

### Exercício 3 — Bloco com block, rescue, always
``` yaml
- name: Tratamento de erro com bloco
  hosts: localhost
  tasks:
    - block:
        - name: Falha intencional
          command: /bin/false

      rescue:
        - name: Tratar erro
          debug:
            msg: "Executando bloco de recuperação"

      always:
        - name: Finalizando execução
          debug:
            msg: "Sempre será executado"
```

Exercício 4 — Parar com fail
``` yaml
- name: Falha manual se variável não definida
  hosts: localhost
  tasks:
    - name: Verificar variável
      fail:
        msg: "meu_parametro não foi definido"
      when: meu_parametro is not defined
```

### Exercício 5 — Verificar SO com assert
``` yaml
- name: Verificar sistema operacional
  hosts: localhost
  tasks:
    - name: Garantir que é Debian
      assert:
        that:
          - ansible_os_family == "Debian"
        fail_msg: "Somente sistemas Debian são suportados"
```

### Exercício 6 — Usar register + when
``` yaml
- name: Instalação com verificação
  hosts: localhost
  tasks:
    - name: Tentar instalar pacote inexistente
      apt:
        name: pacote_inexistente
        state: present
      register: resultado
      ignore_errors: true

    - name: Informar falha
      debug:
        msg: "Instalação falhou"
      when: resultado.failed
```

### Exercício 7 — Exibir stderr
``` yaml
- name: Ver erro detalhado
  hosts: localhost
  tasks:
    - name: Rodar comando com erro
      shell: ls /caminho/que/nao/existe
      register: erro
      ignore_errors: true

    - name: Mostrar stderr
      debug:
        msg: "Erro: {{ erro.stderr }}"
```

### Exercício 8 — any_errors_fatal
``` yaml
- name: Falha em um = parar todos
  hosts: all
  any_errors_fatal: true
  tasks:
    - name: Tarefa que pode falhar
      command: /bin/false
```

### Exercício 9 — max_fail_percentage
``` yaml
- name: Controlar falhas por porcentagem
  hosts: all
  serial: 2
  max_fail_percentage: 50
  tasks:
    - name: Falhar intencionalmente
      command: /bin/false
```

### Exercício 10 — Desafio Final
``` yaml
- name: Error handling completo
  hosts: localhost
  tasks:
    - block:
        - name: Instalar pacote válido
          apt:
            name: curl
            state: present
          register: r1

        - name: Instalar pacote inexistente
          apt:
            name: pacote_inexistente
            state: present
          register: r2

      rescue:
        - name: Informar falha
          debug:
            msg: "Erro ao instalar algum pacote"

      always:
        - name: Mensagem final
          debug:
            msg: "Playbook finalizado"

    - name: Verificar existência do arquivo
      file:
        path: /usr/bin/curl
        state: file
      register: verif

    - name: Garantir que curl existe
      assert:
        that:
          - verif.stat.exists
        fail_msg: "O arquivo curl não foi encontrado!"
```