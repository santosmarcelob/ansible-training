# Respostas
### 1.
``` yaml
tasks:
  - name: Instalar Nginx
    ansible.builtin.package:
      name: nginx
      state: present

  - name: Copiar nginx.conf
    ansible.builtin.copy:
      src: files/nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: Reiniciar Nginx

  - name: Copiar site.conf
    ansible.builtin.copy:
      src: files/site.conf
      dest: /etc/nginx/sites-available/default.conf
    notify: Reiniciar Nginx

handlers:
  - name: Reiniciar Nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```

### 2.
``` yaml
notify: restart_nginx

handlers:
  - name: Reiniciar Nginx
    listen: restart_nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
```

### 3.
``` yaml
tasks:
  - name: Atualizar sshd_config
    ansible.builtin.template:
      src: sshd_config.j2
      dest: /etc/ssh/sshd_config
    notify:
      - Validar SSH
      - Reiniciar SSH

handlers:
  - name: Validar SSH
    ansible.builtin.command: sshd -t

  - name: Reiniciar SSH
    ansible.builtin.service:
      name: ssh
      state: restarted
```

### 4.
``` yaml
tasks:
  - name: Atualizar nginx.conf
    ansible.builtin.copy:
      src: files/nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: Reiniciar Nginx

  - name: Atualizar php.ini
    ansible.builtin.copy:
      src: files/php.ini
      dest: /etc/php.ini
    notify: Reiniciar PHP-FPM

handlers:
  - name: Reiniciar Nginx
    ansible.builtin.service:
      name: nginx
      state: restarted

  - name: Reiniciar PHP-FPM
    ansible.builtin.service:
      name: php-fpm
      state: restarted
```

### 5.
``` yaml
handlers:
  - name: Reiniciar Aplicação
    listen: reiniciar_aplicacao
    ansible.builtin.service:
      name: myapp
      state: restarted
```

### 6.
``` yaml
tasks:
  - name: Verificar existência de arquivo
    ansible.builtin.stat:
      path: /tmp/algum_arquivo
    register: arquivo

  - name: Criar apenas se não existir
    ansible.builtin.file:
      path: /tmp/algum_arquivo
      state: touch
    when: not arquivo.stat.exists
    notify: Executar Handler

handlers:
  - name: Executar Handler
    ansible.builtin.debug:
      msg: "Este handler só roda se o arquivo foi criado"
```

### 7.
``` yaml
tasks:
  - name: Tarefa 1
    ansible.builtin.copy:
      src: f1
      dest: /tmp/f1
    notify: Reiniciar Serviço

  - name: Tarefa 2
    ansible.builtin.copy:
      src: f2
      dest: /tmp/f2
    notify: Reiniciar Serviço

  - name: Tarefa 3
    ansible.builtin.copy:
      src: f3
      dest: /tmp/f3
    notify: Reiniciar Serviço

handlers:
  - name: Reiniciar Serviço
    ansible.builtin.service:
      name: meu_servico
      state: restarted
```

### 8.
``` yaml
handlers:
  - name: Reaplicar Systemd
    ansible.builtin.command:
      cmd: systemctl daemon-reexec
```

### 9.
``` yaml
handlers:
  - name: Recarregar Nginx
    listen: reacao_web
    ansible.builtin.service:
      name: nginx
      state: reloaded

  - name: Validar Config
    listen: reacao_web
    ansible.builtin.command: nginx -t
```

### 10.
``` yaml
tasks:
  - name: Atualizar arquivo A
    ansible.builtin.copy:
      src: A
      dest: /etc/A
    notify: reload_foo

  - name: Atualizar arquivo B
    ansible.builtin.copy:
      src: B
      dest: /etc/B
    notify: reexec_foo

  - name: Atualizar arquivo C
    ansible.builtin.copy:
      src: C
      dest: /etc/C
    notify: restart_foo

handlers:
  - name: Reload Serviço
    listen: reload_foo
    ansible.builtin.service:
      name: foo
      state: reloaded

  - name: Reexec Serviço
    listen: reexec_foo
    ansible.builtin.command: systemctl daemon-reexec

  - name: Restart Serviço
    listen: restart_foo
    ansible.builtin.service:
      name: foo
      state: restarted
```