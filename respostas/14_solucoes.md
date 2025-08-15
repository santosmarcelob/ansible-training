# Respostas — Exemplos de Código
### Exercício 1: file
``` yaml
- name: Ler mensagem do arquivo
  hosts: localhost
  tasks:
    - name: Exibir conteúdo do arquivo
      debug:
        msg: "{{ lookup('file', 'mensagem.txt') }}"
```

### Exercício 2: env
``` yaml
- name: Mostrar usuário local
  hosts: localhost
  tasks:
    - debug:
        msg: "Usuário atual: {{ lookup('env', 'USER') }}"
```

### Exercício 3: pipe
``` yaml
- name: Mostrar data atual
  hosts: localhost
  tasks:
    - debug:
        msg: "Data: {{ lookup('pipe', 'date') }}"
```

### Exercício 4: password + user
``` yaml
- name: Criar usuário com senha segura
  hosts: localhost
  tasks:
    - user:
        name: app
        password: "{{ lookup('password', 'senhas/app.pass chars=ascii_letters length=12') | password_hash('sha512') }}"
```

### Exercício 5: vars
``` yaml
- name: Acessar variáveis dinamicamente
  hosts: localhost
  vars:
    user_joao: admin
    user_maria: dev
  tasks:
    - debug:
        msg: "Permissão de Maria: {{ lookup('vars', 'user_maria') }}"
```

### Exercício 6: Loop com splitlines()
Arquivo lista.txt:

``` txt
arquivo1.txt
arquivo2.txt
arquivo3.txt
```

``` yaml
- name: Loop para ler arquivos listados
  hosts: localhost
  tasks:
    - name: Exibir conteúdo dos arquivos
      debug:
        msg: "{{ lookup('file', item) }}"
      loop: "{{ lookup('file', 'lista.txt').splitlines() }}"
```

### Exercício 7: csvfile
Arquivo usuarios.csv:

``` pgsql
joao,admin
maria,dev
```
``` yaml
- name: Obter papel de usuário do CSV
  hosts: localhost
  tasks:
    - debug:
        msg: "João é: {{ lookup('csvfile', 'joao file=usuarios.csv delimiter=,') }}"
```

### Exercício 8: Template com Lookups
Arquivo templates/info.j2:

``` jinja
MOTD: {{ lookup('file', '/etc/motd') }}
Data de execução: {{ lookup('pipe', 'date') }}
```

Playbook:

``` yaml
- name: Gerar template com motd e data
  hosts: localhost
  tasks:
    - template:
        src: templates/info.j2
        dest: /tmp/info.txt
```

### Exercício 9: lookup em lineinfile
``` yaml
- name: Adicionar linha ao .bashrc
  hosts: localhost
  tasks:
    - lineinfile:
        path: ~/.bashrc
        line: "export HOME_PATH={{ lookup('env', 'HOME') }}"
```

### Exercício 10: Desafio Final
Arquivo .env:

``` ini
API_KEY=XYZ123
DEBUG=true
```

Playbook:

``` yaml
- name: Aplicar variáveis do .env e registrar data
  hosts: localhost
  tasks:
    - name: Adicionar variáveis ao environment
      lineinfile:
        path: /etc/environment
        line: "{{ item }}"
        create: yes
      loop: "{{ lookup('file', '.env').splitlines() }}"

    - name: Registrar data de implantação
      copy:
        content: "Deploy em {{ lookup('pipe', 'date') }}\n"
        dest: /var/log/deploy.log
        force: no
```