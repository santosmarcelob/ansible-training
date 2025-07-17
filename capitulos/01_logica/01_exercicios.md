# Exercícios de Lógica de Programação com Ansible

Estes exercícios foram projetados para ajudá-lo a praticar os conceitos de lógica de programação (variáveis, condicionais e loops) no contexto dos playbooks Ansible. Tente resolvê-los por conta própria antes de consultar o arquivo de soluções.

## Seção 1: Variáveis e Fatos

### Exercício 1: Variável Simples
Crie um playbook que defina uma variável `mensagem_boas_vindas` com o valor "Bem-vindo ao Ansible!" e use o módulo `debug` para exibir essa mensagem.

### Exercício 2: Variáveis de Inventário
Modifique o playbook anterior para que a mensagem de boas-vindas seja definida no inventário para um grupo de hosts chamado `webservers`. O playbook deve exibir a mensagem apenas para os hosts nesse grupo.

### Exercício 3: Variáveis de Linha de Comando
Crie um playbook que aceite uma variável `nome_usuario` via linha de comando (usando `-e`) e crie um usuário com esse nome no host de destino. Use o módulo `ansible.builtin.user`.

### Exercício 4: Fatos do Sistema
Crie um playbook que colete os fatos do sistema e use o módulo `debug` para exibir o nome do sistema operacional (`ansible_facts['os_family']`) e a quantidade de memória RAM (`ansible_facts['memtotal_mb']`).

### Exercício 5: Variáveis Complexas (Dicionário)
Defina uma variável `servico_web` como um dicionário contendo `nome: nginx` e `porta: 80`. Use essas variáveis para instalar o serviço e garantir que a porta esteja aberta no firewall (assumindo um módulo de firewall genérico como `ansible.builtin.firewalld` ou `ansible.builtin.ufw`).

## Seção 2: Condicionais (`when`)

### Exercício 6: Instalação Condicional
Crie um playbook que instale o pacote `apache2` apenas se o sistema operacional for da família Debian (`ansible_facts['os_family'] == "Debian"`).

### Exercício 7: Serviço Condicional
Crie um playbook que inicie o serviço `nginx` apenas se ele estiver instalado e o host for um `webserver` (use `inventory_hostname` ou um grupo de inventário).

### Exercício 8: Condicional com Variável Booleana
Defina uma variável `habilitar_servico_x: true` ou `false`. Crie uma tarefa que instale e inicie um serviço fictício `servico_x` apenas se `habilitar_servico_x` for `true`.

### Exercício 9: Condicional com Múltiplas Condições (AND)
Crie um playbook que crie um diretório `/opt/backup` apenas se o sistema operacional for CentOS (`ansible_facts['os_family'] == "RedHat"`) E a memória RAM total for maior que 1024 MB (`ansible_facts['memtotal_mb'] > 1024`).

### Exercício 10: Condicional com Múltiplas Condições (OR)
Crie um playbook que instale o pacote `vim` se o sistema operacional for Debian OU RedHat.

### Exercício 11: Condicional com `is defined`
Crie um playbook que exiba uma mensagem de depuração "A variável 'ambiente' está definida." apenas se a variável `ambiente` estiver definida. Teste com e sem a variável definida.

## Seção 3: Loops

### Exercício 12: Instalação de Múltiplos Pacotes
Crie um playbook que instale os pacotes `git`, `htop` e `tree` usando um loop.

### Exercício 13: Criação de Múltiplos Usuários
Crie um playbook que crie os usuários `devops`, `admin` e `monitor` usando um loop. Cada usuário deve ter um `shell` diferente (`/bin/bash`, `/bin/sh`, `/sbin/nologin`, respectivamente).

### Exercício 14: Criação de Múltiplos Diretórios
Crie um playbook que crie os diretórios `/var/www/html`, `/var/log/app` e `/etc/app/conf` usando um loop.

### Exercício 15: Loop com Dicionários (Serviços)
Crie um playbook que gerencie os seguintes serviços usando um loop de dicionários: `nginx` (estado: `started`), `mysql` (estado: `stopped`), `apache2` (estado: `restarted`).

### Exercício 16: Loop com Condicional Interna
Crie um playbook que itere sobre uma lista de pacotes (`nginx`, `apache2`, `php`). Instale `nginx` e `php` se o sistema operacional for Debian, e `apache2` se for RedHat. Use um loop e uma condicional `when` dentro da tarefa.

## Seção 4: Desafios Combinados

### Exercício 17: Gerenciamento de Usuários com Variáveis e Condicionais
Crie um playbook que gerencie uma lista de usuários definida em uma variável. Para cada usuário, o playbook deve:
*   Criar o usuário se `state: present`.
*   Remover o usuário se `state: absent`.
*   Definir o `shell` do usuário com base em uma propriedade no dicionário do usuário.

### Exercício 18: Configuração de Firewall Dinâmica
Crie um playbook que adicione regras de firewall (usando um módulo fictício como `ansible.builtin.firewalld`) para as portas 80 (HTTP) e 443 (HTTPS) apenas se o host for um `webserver` e a variável `habilitar_firewall: true` estiver definida.

### Exercício 19: Instalação de Pacotes por Ambiente
Crie um playbook que instale diferentes conjuntos de pacotes com base em uma variável `ambiente` (ex: `dev`, `prod`).
*   Se `ambiente` for `dev`, instale `git` e `vim`.
*   Se `ambiente` for `prod`, instale `nginx` e `mysql-server`.

### Exercício 20: Backup de Arquivos com Loop e Condicional
Crie um playbook que faça backup de uma lista de arquivos. Para cada arquivo na lista, ele deve:
*   Criar um diretório de backup (`/tmp/backups`).
*   Copiar o arquivo para o diretório de backup.
*   A tarefa de cópia só deve ser executada se o arquivo original existir no sistema de destino.

