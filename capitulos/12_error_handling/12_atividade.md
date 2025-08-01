### Você deve criar um playbook chamado error-handling.yml que execute os seguintes passos:

**1. Instalação de dois pacotes:**

- Um real (ex: curl)
- Um falso (ex: pacote_invalido)
- Capturar o resultado com register
- Ignorar a falha com ignore_errors: true

**2. Reagir à falha do pacote inválido:**
- Usar when para exibir uma mensagem debug caso a instalação tenha falhado.

**3. Criar um bloco de tarefas com tratamento de erro:**
- Dentro de um block, copiar um arquivo (mensagem.txt) para /tmp/mensagem.txt
- Forçar uma falha proposital (ex: command: /bin/false)
- Usar rescue para exibir uma mensagem de fallback
- Usar always para mostrar que o bloco foi finalizado

**4. Garantir que o arquivo foi copiado corretamente:**
- Validar com assert que /tmp/mensagem.txt existe (use ansible.builtin.fileglob)
- Exibir uma mensagem clara se a validação falhar

**5. Interromper a execução se a variável app_env não for "dev":**

- Declarar a variável no início do playbook
- Usar fail condicionalmente com when