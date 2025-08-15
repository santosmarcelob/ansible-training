# Respostas
### 1.
``` yaml
- name: Copiar MOTD apenas se diferente
  ansible.builtin.copy:
    src: motd
    dest: /etc/motd
    owner: root
    group: root
    mode: '0644'
``` 

### 2.
``` yaml
- name: Criar diretório de logs da aplicação
  ansible.builtin.file:
    path: /opt/app/logs
    state: directory
    mode: '0750'
    owner: appuser
    group: adm
``` 

### 3.
``` yaml
- name: Instalar pacotes em qualquer SO
  ansible.builtin.package:
    name:
      - curl
      - vim
      - net-tools
    state: present
    update_cache: yes
``` 

### 4.

``` yaml
- name: Copiar nginx.conf e reiniciar nginx se mudar
  ansible.builtin.copy:
    src: files/nginx.conf
    dest: /etc/nginx/nginx.conf
    mode: '0644'
    owner: root
    group: root
  notify: Restart Nginx

handlers:
  - name: Restart Nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
``` 

### 5.
``` yaml
- name: Gerar arquivo de config com template
  ansible.builtin.template:
    src: templates/myapp.conf.j2
    dest: /etc/myapp.conf
    owner: root
    group: root
    mode: '0644'
  vars:
    port: 8080
``` 

### 6.
``` yaml
- name: Verificar porta 22 com shell
  ansible.builtin.shell: "ss -tuln | grep :22"
  register: porta_22

- name: Mostrar resultado
  ansible.builtin.debug:
    var: porta_22.stdout
``` 

### 7.
``` yaml
- name: Backup do fstab se ainda não existir
  ansible.builtin.command:
    cmd: cp /etc/fstab /backup/fstab.bkp
    creates: /backup/fstab.bkp
``` 

### 8.
``` yaml
- name: Pegar hostname completo
  ansible.builtin.command:
    cmd: hostname -f
  register: resultado

- name: Mostrar hostname
  ansible.builtin.debug:
    var: resultado.stdout
``` 

### 9.
``` yaml
- name: Garantir que cron está rodando e habilitado
  ansible.builtin.service:
    name: cron
    state: started
    enabled: true
``` 

### 10.
``` yaml
- name: Mostrar SO e versão
  ansible.builtin.debug:
    msg: "Sistema: {{ ansible_facts.distribution }} {{ ansible_facts.distribution_version }}"
``` 