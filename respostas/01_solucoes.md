# Soluções dos Exercícios de Lógica de Programação com Ansible

Este arquivo contém as soluções propostas para os exercícios de lógica de programação em Ansible. Lembre-se que, em automação, muitas vezes existem múltiplas maneiras de alcançar o mesmo resultado. Estas soluções são um guia e uma forma de verificar seu entendimento.

## Seção 1: Variáveis e Fatos

### Exercício 1: Variável Simples

**Playbook:**
```yaml
---
- name: Exibir mensagem de boas-vindas
  hosts: localhost
  gather_facts: false
  vars:
    mensagem_boas_vindas: "Bem-vindo ao Ansible!"

  tasks:
    - name: Debug da mensagem
      ansible.builtin.debug:
        msg: "{{ mensagem_boas_vindas }}"
```

### Exercício 2: Variáveis de Inventário

**Inventário (`inventory.ini`):**
```ini
[webservers]
webserver1 ansible_host=127.0.0.1
webserver2 ansible_host=127.0.0.1

[webservers:vars]
mensagem_boas_vindas="Bem-vindo aos servidores web!"
```

**Playbook (`ex2_variavel_inventario.yml`):**
```yaml
---
- name: Exibir mensagem de boas-vindas do inventário
  hosts: webservers
  gather_facts: false

  tasks:
    - name: Debug da mensagem do inventário
      ansible.builtin.debug:
        msg: "{{ mensagem_boas_vindas }}"
```

### Exercício 3: Variáveis de Linha de Comando

**Playbook:**
```yaml
---
- name: Criar usuário com variável de linha de comando
  hosts: localhost
  gather_facts: false
  become: true

  tasks:
    - name: Criar usuário {{ nome_usuario }}
      ansible.builtin.user:
        name: "{{ nome_usuario }}"
        state: present
        shell: /bin/bash
```

**Como executar:**
`ansible-playbook ex3_variavel_linha_comando.yml -e "nome_usuario=aluno_teste"`

### Exercício 4: Fatos do Sistema

**Playbook:**
```yaml
---
- name: Exibir fatos do sistema
  hosts: localhost
  gather_facts: true

  tasks:
    - name: Exibir nome do sistema operacional
      ansible.builtin.debug:
        msg: "Sistema Operacional: {{ ansible_facts["os_family"] }}"

    - name: Exibir memória RAM total
      ansible.builtin.debug:
        msg: "Memória RAM Total: {{ ansible_facts["memtotal_mb"] }} MB"
```

### Exercício 5: Variáveis Complexas (Dicionário)

**Playbook:**
```yaml
---
- name: Instalar serviço web e abrir porta
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    servico_web:
      nome: nginx
      porta: 80

  tasks:
    - name: Instalar {{ servico_web.nome }}
      ansible.builtin.apt:
        name: "{{ servico_web.nome }}"
        state: present

    - name: Abrir porta {{ servico_web.porta }} no firewall (exemplo com ufw)
      community.general.ufw:
        rule: allow
        port: "{{ servico_web.porta }}"
        proto: tcp
        state: enabled
      # Nota: O módulo ufw requer que o ufw esteja instalado e habilitado no host.
      # Para firewalld, seria ansible.builtin.firewalld:
      #   port: "{{ servico_web.porta }}/tcp"
      #   state: enabled
      #   permanent: true
      #   immediate: true
```

## Seção 2: Condicionais (`when`)

### Exercício 6: Instalação Condicional

**Playbook:**
```yaml
---
- name: Instalar Apache2 condicionalmente
  hosts: localhost
  gather_facts: true
  become: true

  tasks:
    - name: Instalar apache2 se for Debian
      ansible.builtin.apt:
        name: apache2
        state: present
      when: ansible_facts["os_family"] == "Debian"
```

### Exercício 7: Serviço Condicional

**Inventário (`inventory.ini`):**
```ini
[webservers]
webserver1 ansible_host=127.0.0.1
```

**Playbook (`ex7_servico_condicional.yml`):**
```yaml
---
- name: Iniciar Nginx condicionalmente
  hosts: webservers
  gather_facts: true
  become: true

  tasks:
    - name: Verificar se Nginx está instalado
      ansible.builtin.package_facts:
        manager: auto

    - name: Iniciar Nginx se instalado e host for webserver
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
      when: 
        - "nginx" in ansible_facts.packages
        - inventory_hostname in groups["webservers"]
```

### Exercício 8: Condicional com Variável Booleana

**Playbook:**
```yaml
---
- name: Gerenciar serviço fictício com booleana
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    habilitar_servico_x: true # Mude para false para testar a não execução

  tasks:
    - name: Instalar e iniciar servico_x
      ansible.builtin.debug:
        msg: "Instalando e iniciando servico_x"
      when: habilitar_servico_x

    - name: Parar servico_x
      ansible.builtin.debug:
        msg: "Parando servico_x"
      when: not habilitar_servico_x
```

### Exercício 9: Condicional com Múltiplas Condições (AND)

**Playbook:**
```yaml
---
- name: Criar diretório de backup condicionalmente
  hosts: localhost
  gather_facts: true
  become: true

  tasks:
    - name: Criar /opt/backup se for CentOS e RAM > 1GB
      ansible.builtin.file:
        path: /opt/backup
        state: directory
        mode: '0755'
      when: 
        - ansible_facts["os_family"] == "RedHat"
        - ansible_facts["memtotal_mb"] > 1024
```

### Exercício 10: Condicional com Múltiplas Condições (OR)

**Playbook:**
```yaml
---
- name: Instalar Vim condicionalmente
  hosts: localhost
  gather_facts: true
  become: true

  tasks:
    - name: Instalar vim se for Debian ou RedHat
      ansible.builtin.package:
        name: vim
        state: present
      when: 
        - ansible_facts["os_family"] == "Debian" or ansible_facts["os_family"] == "RedHat"
```

### Exercício 11: Condicional com `is defined`

**Playbook:**
```yaml
---
- name: Verificar se variável 'ambiente' está definida
  hosts: localhost
  gather_facts: false
  vars:
    # ambiente: "producao" # Descomente para testar com a variável definida

  tasks:
    - name: Mensagem se 'ambiente' estiver definida
      ansible.builtin.debug:
        msg: "A variável 'ambiente' está definida."
      when: ambiente is defined

    - name: Mensagem se 'ambiente' NÃO estiver definida
      ansible.builtin.debug:
        msg: "A variável 'ambiente' NÃO está definida."
      when: ambiente is not defined
```

## Seção 3: Loops

### Exercício 12: Instalação de Múltiplos Pacotes

**Playbook:**
```yaml
---
- name: Instalar múltiplos pacotes
  hosts: localhost
  gather_facts: false
  become: true

  tasks:
    - name: Instalar pacotes essenciais
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop:
        - git
        - htop
        - tree
```

### Exercício 13: Criação de Múltiplos Usuários

**Playbook:**
```yaml
---
- name: Criar múltiplos usuários com shells diferentes
  hosts: localhost
  gather_facts: false
  become: true

  tasks:
    - name: Criar usuário {{ item.name }}
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: present
        shell: "{{ item.shell }}"
      loop:
        - { name: 'devops', shell: '/bin/bash' }
        - { name: 'admin', shell: '/bin/sh' }
        - { name: 'monitor', shell: '/sbin/nologin' }
```

### Exercício 14: Criação de Múltiplos Diretórios

**Playbook:**
```yaml
---
- name: Criar múltiplos diretórios
  hosts: localhost
  gather_facts: false
  become: true

  tasks:
    - name: Criar diretório {{ item }}
      ansible.builtin.file:
        path: "{{ item }}"
        state: directory
        mode: '0755'
      loop:
        - /var/www/html
        - /var/log/app
        - /etc/app/conf
```

### Exercício 15: Loop com Dicionários (Serviços)

**Playbook:**
```yaml
---
- name: Gerenciar múltiplos serviços
  hosts: localhost
  gather_facts: false
  become: true

  tasks:
    - name: Gerenciar serviço {{ item.name }}
      ansible.builtin.service:
        name: "{{ item.name }}"
        state: "{{ item.state }}"
      loop:
        - { name: 'nginx', state: 'started' }
        - { name: 'mysql', state: 'stopped' }
        - { name: 'apache2', state: 'restarted' }
      ignore_errors: true # Para evitar falhas se um serviço não existir
```

### Exercício 16: Loop com Condicional Interna

**Playbook:**
```yaml
---
- name: Instalar pacotes com loop e condicional
  hosts: localhost
  gather_facts: true
  become: true

  tasks:
    - name: Instalar pacote {{ item }}
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop:
        - nginx
        - apache2
        - php
      when: 
        - (item == 'nginx' or item == 'php') and ansible_facts["os_family"] == "Debian"
        - (item == 'apache2') and ansible_facts["os_family"] == "RedHat"
```

## Seção 4: Desafios Combinados

### Exercício 17: Gerenciamento de Usuários com Variáveis e Condicionais

**Playbook:**
```yaml
---
- name: Gerenciar usuários dinamicamente
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    usuarios_para_gerenciar:
      - name: user_dev
        state: present
        shell: /bin/bash
      - name: user_qa
        state: present
        shell: /bin/sh
      - name: user_old
        state: absent
        # shell não é necessário para absent, mas pode ser incluído

  tasks:
    - name: Gerenciar usuário {{ item.name }}
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: "{{ item.state }}"
        shell: "{{ item.shell | default('/bin/bash') }}" # Default shell se não especificado
        remove: true # Garante que o home dir seja removido se state: absent
      loop: "{{ usuarios_para_gerenciar }}"
      loop_control:
        label: "{{ item.name }}"
```

### Exercício 18: Configuração de Firewall Dinâmica

**Inventário (`inventory.ini`):**
```ini
[webservers]
webserver1 ansible_host=127.0.0.1

[all:vars]
habilitar_firewall=true
```

**Playbook (`ex18_firewall_dinamico.yml`):**
```yaml
---
- name: Configurar firewall dinamicamente
  hosts: webservers
  gather_facts: false
  become: true

  tasks:
    - name: Abrir porta HTTP (80)
      community.general.ufw:
        rule: allow
        port: 80
        proto: tcp
        state: enabled
      when: 
        - habilitar_firewall is defined and habilitar_firewall | bool
        - inventory_hostname in groups["webservers"]

    - name: Abrir porta HTTPS (443)
      community.general.ufw:
        rule: allow
        port: 443
        proto: tcp
        state: enabled
      when: 
        - habilitar_firewall is defined and habilitar_firewall | bool
        - inventory_hostname in groups["webservers"]
```

### Exercício 19: Instalação de Pacotes por Ambiente

**Playbook:**
```yaml
---
- name: Instalar pacotes por ambiente
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    ambiente: "dev" # Mude para "prod" para testar o outro cenário

  tasks:
    - name: Instalar pacotes para ambiente de desenvolvimento
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop:
        - git
        - vim
      when: ambiente == "dev"

    - name: Instalar pacotes para ambiente de produção
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop:
        - nginx
        - mysql-server
      when: ambiente == "prod"
```

### Exercício 20: Backup de Arquivos com Loop e Condicional

**Playbook:**
```yaml
---
- name: Fazer backup de arquivos
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    arquivos_para_backup:
      - /etc/hosts
      - /etc/fstab
      - /tmp/arquivo_inexistente.txt # Arquivo que não existe para testar a condicional

  tasks:
    - name: Criar diretório de backup
      ansible.builtin.file:
        path: /tmp/backups
        state: directory
        mode: '0755'

    - name: Verificar se o arquivo existe antes de copiar
      ansible.builtin.stat:
        path: "{{ item }}"
      register: file_status
      loop: "{{ arquivos_para_backup }}"
      loop_control:
        label: "{{ item }}"

    - name: Copiar arquivo para backup se existir
      ansible.builtin.copy:
        src: "{{ item.item }}"
        dest: "/tmp/backups/{{ item.item | basename }}"
        remote_src: true
      loop: "{{ file_status.results }}"
      when: item.stat.exists
      loop_control:
        label: "{{ item.item }}"
```


