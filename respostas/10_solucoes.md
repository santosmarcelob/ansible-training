# Respostas
### 1. roles/mysql/tasks/main.yml
``` yaml
- name: Instalar MySQL
  apt:
    name: mysql-server
    state: present
  notify: reiniciar mysql

- name: Iniciar serviço MySQL
  service:
    name: mysql
    state: started
```

### 2. roles/mysql/handlers/main.yml
``` yaml
- name: reiniciar mysql
  service:
    name: mysql
    state: restarted
```

### 3.

roles/mysql/defaults/main.yml:

``` yaml
mysql_port: 3306
```

roles/mysql/templates/my.cnf.j2:

```ini
[mysqld]
port = {{ mysql_port }}
```

### 4. site.yml
``` yaml
- hosts: dbservers
  become: yes
  roles:
    - role: mysql
      vars:
        mysql_port: 3307
```

### 5. roles/firewall/meta/main.yml
``` yaml
---
dependencies:
  - role: common
```

### 6. Exemplo de uso:
``` yaml
- name: Import role backup
  import_role:
    name: backup

- name: Include role backup (dinâmico)
  include_role:
    name: backup
```

### 7.
defaults/main.yml: usado para definir variáveis que podem ser facilmente sobrescritas (por playbook, group_vars etc).

vars/main.yml: usado para definir variáveis que não devem ser sobrescritas. Tem maior precedência.

Variáveis críticas ou sensíveis devem ir em vars.

### 8. roles/webapp/tasks/main.yml
``` yaml
- name: Copiar página index.html
  copy:
    src: index.html
    dest: /var/www/html/index.html
```

### 9.
roles/apache/templates/apache.conf.j2:

``` ini
Listen {{ listen_port }}
```

roles/apache/defaults/main.yml:

``` yaml
listen_port: 80
roles/apache/tasks/main.yml:
```

``` yaml
- name: Copiar configuração do Apache
  template:
    src: apache.conf.j2
    dest: /etc/apache2/ports.conf
  notify: reiniciar apache
```

### 10. site.yml
``` yaml
- name: Configurar Apache nos Webservers
  hosts: webservers
  become: yes
  roles:
    - role: apache
      vars:
        listen_port: 8081
```