# Respostas dos Exercícios
### Resposta 1
``` bash
ansible-vault encrypt_string 'ABC1234' --name 'api_key'
```

Resultado → cole em group_vars/all.yml

Playbook:

``` yaml
- hosts: all
  vars_files:
    - group_vars/all.yml
  tasks:
    - name: Exibir API key
      debug:
        msg: "{{ api_key }}"
```
### Resposta 2
``` bash
ansible-vault encrypt_string 'devkey123' --name 'api_key' --vault-id dev@prompt
ansible-vault encrypt_string 'prodkey456' --name 'api_key' --vault-id prod@prompt
```
Crie dois arquivos:

group_vars/dev.yml → conteúdo com api_key do dev

group_vars/prod.yml → conteúdo com api_key do prod

Playbook:

``` yaml
- hosts: all
  vars_files:
    - group_vars/{{ ambiente }}.yml
  tasks:
    - debug: msg="Chave usada: {{ api_key }}"
```
Execute:

``` bash
ansible-playbook play.yml -e "ambiente=dev" --vault-id dev@vault_dev.txt
```
### Resposta 3
Crie:

``` bash
echo 'minhasenha' > vault_pass.txt
chmod 600 vault_pass.txt
```
ansible.cfg

``` ini
[defaults]
vault_password_file = vault_pass.txt
```
Agora execute:

``` bash
ansible-playbook playbook.yml
```

### Resposta 4
host_vars/web01.yml:

``` yaml
db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  ...
host_vars/web02.yml:
```

``` yaml
db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  ...
```

Playbook:

``` yaml
- hosts: all
  tasks:
    - name: Mostrar senha por host
      debug:
        msg: "{{ inventory_hostname }} usa senha {{ db_password }}"
```

### Resposta 5
``` bash
ansible-vault rekey host_vars/web01.yml
```
### Resposta 6
```bash
ansible-vault encrypt_string 'token12345' --name 'app_token'
```

Playbook:

``` yaml
- hosts: all
  vars:
    app_token: !vault |
      $ANSIBLE_VAULT;1.1;AES256
      ...
  tasks:
    - debug:
        msg: "Token: {{ app_token }}"
```

### Resposta 7
```bash
#!/bin/bash
senha='secretaXYZ'
echo "$senha" > vault_pass.txt
chmod 600 vault_pass.txt

vault=$(ansible-vault encrypt_string "$senha" --name "api_secret" --vault-password-file vault_pass.txt)
echo "$vault" > group_vars/all.yml
```
ansible-playbook play.yml --vault-password-file vault_pass.txt

### Resposta 8
Template app.conf.j2:

``` jinja
[app]
secret = {{ api_secret }}
```
Playbook:

``` yaml
- hosts: all
  vars_files:
    - group_vars/all.yml
  tasks:
    - name: Gerar arquivo de config
      template:
        src: app.conf.j2
        dest: /tmp/app.conf
```

### Resposta 9
Tente executar um playbook com:

``` bash
ansible-playbook play.yml --vault-id dev@vault_prod.txt
```

A execução irá falhar, pois o Vault ID correto (dev) exige senha correta (armazenada em vault_dev.txt, não em vault_prod.txt).

### Resposta 10
Playbook:

``` yaml
- hosts: all
  vars_files:
    - group_vars/all.yml
  tasks:
    - name: Falhar se variável não definida
      fail:
        msg: "env_pass não definida. Abortando!"
      when: env_pass is not defined

    - name: Continuar se definida
      debug:
        msg: "Senha recebida: {{ env_pass }}"
```