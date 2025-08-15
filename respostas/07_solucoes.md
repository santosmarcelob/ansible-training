# Respostas
### Resposta 1
``` yaml
---
- name: Instalar Nginx nos webservers Debian
  hosts: webservers
  become: true
  tasks:
    - name: Instalar Nginx
      ansible.builtin.package:
        name: nginx
        state: present
      when: ansible_facts.distribution == "Debian"

    - name: Iniciar Nginx
      ansible.builtin.service:
        name: nginx
        state: started
      when: ansible_facts.distribution == "Debian"

- name: Instalar Firewalld nos databases RedHat
  hosts: databases
  become: true
  tasks:
    - name: Instalar firewalld
      ansible.builtin.package:
        name: firewalld
        state: present
      when: ansible_facts.distribution == "RedHat"

    - name: Iniciar firewalld
      ansible.builtin.service:
        name: firewalld
        state: started
      when: ansible_facts.distribution == "RedHat"
``` 

### Resposta 2
``` yaml
---
- name: Instalar pacotes e contar mudanças
  hosts: all
  become: true
  tasks:
    - name: Instalar pacotes
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop:
        - htop
        - vim
        - curl
      register: resultado

    - name: Mostrar quantos pacotes foram instalados
      ansible.builtin.debug:
        msg: "Foram instalados {{ resultado.results | selectattr('changed') | list | length }} pacotes."
``` 

### Resposta 3
``` yaml
---
- name: Ping dinâmico com base em variável
  hosts: "{{ custom_target }}"
  gather_facts: false
  tasks:
    - name: Ping
      ansible.builtin.ping:
      register: ping_result

    - name: Confirmação
      ansible.builtin.debug:
        msg: "Conectado com sucesso ao {{ inventory_hostname }}"
      when: not ping_result.failed
``` 

### Resposta 4
``` yaml
---
- name: Criar múltiplos diretórios
  hosts: all
  become: true
  tasks:
    - name: Criar diretórios de teste
      ansible.builtin.file:
        path: "/opt/teste{{ item }}"
        state: directory
      loop: "{{ lookup('sequence', start=1, end=10) }}"
``` 

### Resposta 5
``` yaml
---
- name: Verificar carga do sistema
  hosts: all
  become: true
  tasks:
    - name: Executar uptime
      ansible.builtin.command: uptime
      register: resultado_uptime

    - name: Verificar carga e exibir alerta
      ansible.builtin.debug:
        msg: "ALERTA: carga alta - {{ resultado_uptime.stdout }}"
      when: resultado_uptime.stdout.split('load average:')[1].split(',')[0] | float > 1.0
``` 

### Resposta 6
``` yaml
---
- name: Template condicional
  hosts: all
  become: true
  tasks:
    - name: Copiar template
      ansible.builtin.template:
        src: mensagem.j2
        dest: /etc/mensagem.txt
      register: resultado_template

    - name: Exibir log se houve mudança
      ansible.builtin.debug:
        msg: "Arquivo atualizado em {{ inventory_hostname }}"
      when: resultado_template.changed
``` 

### Resposta 7
``` yaml
---
- name: Criar usuários dinamicamente
  hosts: all
  become: true
  vars:
    usuarios:
      - nome: joao
        shell: /bin/bash
      - nome: maria
        shell: /bin/zsh
  tasks:
    - name: Criar usuários
      ansible.builtin.user:
        name: "{{ item.nome }}"
        shell: "{{ item.shell }}"
        state: present
      loop: "{{ usuarios }}"
``` 

### Resposta 8
``` yaml
---
- name: Criar usuários com base em arquivo
  hosts: all
  become: true
  tasks:
    - name: Ler arquivo de usuários
      ansible.builtin.set_fact:
        user_list: "{{ lookup('file', 'users.txt').splitlines() }}"

    - name: Criar usuários
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
      loop: "{{ user_list }}"
``` 

### Resposta 9
Execute no terminal:

``` bash
ansible-playbook -i inventario.ini playbook_nginx.yml --check --diff
``` 

### Resposta 10
``` yaml
---
- name: Configurar servidores Web
  hosts: webservers
  become: true
  tasks:
    - name: Instalar nginx
      ansible.builtin.package:
        name: nginx
        state: present

    - name: Iniciar nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

- name: Configurar banco de dados
  hosts: databases
  become: true
  tasks:
    - name: Verificar se PostgreSQL está ativo
      ansible.builtin.shell: systemctl is-active postgresql
      register: postgres_status
      ignore_errors: true

    - name: Criar banco
      community.postgresql.postgresql_db:
        name: meu_banco
        state: present
      when: postgres_status.stdout == "active"
``` 