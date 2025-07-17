# Exercícios - Capítulo 2: Introdução ao Ansible

Estes exercícios foram projetados para ajudá-lo a praticar os conceitos abordados no Capítulo 2: Introdução ao Ansible. Eles cobrem desde a criação de inventários básicos até a execução de playbooks simples e a compreensão da idempotência.

--- 

## Exercício 1: Criando um Inventário Estático Básico

Crie um arquivo de inventário estático chamado `inventario_exercicio1.ini` que contenha:

*   Um grupo chamado `servidores_web` com os hosts `webserver01.example.com` e `webserver02.example.com`.
*   Um grupo chamado `servidores_banco` com o host `dbserver01.example.com`.
*   Defina uma variável de grupo para `servidores_web` chamada `http_port` com o valor `80`.
*   Defina uma variável de host para `dbserver01.example.com` chamada `db_version` com o valor `PostgreSQL 14`.

## Exercício 2: Testando Conectividade com o Módulo `ping`

Usando o inventário criado no Exercício 1, crie um playbook chamado `ping_all.yml` que utilize o módulo `ansible.builtin.ping` para testar a conectividade com todos os hosts definidos no inventário.

## Exercício 3: Executando um Comando Ad-Hoc

Utilize um comando ad-hoc do Ansible para executar o comando `uptime` em todos os hosts do grupo `servidores_web` do seu inventário.

## Exercício 4: Criando um Playbook Simples para Instalar um Pacote

Crie um playbook chamado `instalar_nginx.yml` que:

*   Seja direcionado ao grupo `servidores_web`.
*   Utilize `become: true` para elevação de privilégios.
*   Tenha uma tarefa para instalar o pacote `nginx` (use o módulo `ansible.builtin.package` ou `ansible.builtin.apt`/`ansible.builtin.yum` conforme seu ambiente de teste) e garantir que ele esteja `presente`.

## Exercício 5: Gerenciando um Serviço com um Playbook

Modifique o playbook `instalar_nginx.yml` do Exercício 4 (ou crie um novo `gerenciar_nginx.yml`) para incluir uma tarefa que garanta que o serviço `nginx` esteja `started` (iniciado) e `enabled` (habilitado para iniciar no boot) nos `servidores_web`.

## Exercício 6: Entendendo a Idempotência

Execute o playbook `gerenciar_nginx.yml` (ou `instalar_nginx.yml` modificado) duas vezes seguidas. Observe a saída do Ansible. Explique o que acontece na segunda execução e por que isso demonstra o conceito de idempotência.

## Exercício 7: Usando `ansible.cfg` para Definir o Inventário Padrão

Crie um arquivo `ansible.cfg` no mesmo diretório do seu inventário e playbooks. Configure-o para que o Ansible use `inventario_exercicio1.ini` como o inventário padrão. Em seguida, execute o playbook `ping_all.yml` sem especificar o inventário na linha de comando (`-i`).

## Exercício 8: Definindo Variáveis em `ansible.cfg`

Modifique o `ansible.cfg` para definir `ansible_user=seu_usuario_ssh` e `host_key_checking=False` (apenas para ambiente de laboratório!). Execute um comando ad-hoc ou playbook para verificar se essas configurações estão sendo aplicadas.

## Exercício 9: Criando um Playbook com Múltiplas Tarefas

Crie um playbook chamado `configurar_servidor.yml` que:

*   Seja direcionado a `servidores_web`.
*   Instale o pacote `apache2`.
*   Garanta que o serviço `apache2` esteja iniciado e habilitado.
*   Copie um arquivo `index.html` simples (crie este arquivo localmente) para `/var/www/html/index.html` nos servidores web.

## Exercício 10: Explorando Fatos do Ansible

Crie um playbook chamado `explorar_fatos.yml` que:

*   Seja direcionado a `all` os hosts.
*   Tenha uma tarefa que use o módulo `ansible.builtin.debug` para exibir o nome do sistema operacional (`ansible_facts.distribution`) e a versão (`ansible_facts.distribution_version`) de cada host.

