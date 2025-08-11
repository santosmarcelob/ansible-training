## Respostas dos Exercícios – Fundamentos de YAML no Ansible

* * *

### Exercício 1

``` yaml
vars:
  usuarios:
    alice: { uid: 1001, grupo: dev, shell: /bin/bash }
    bob: { uid: 1002, grupo: qa, shell: /bin/zsh }

tasks:
  - name: Criar usuários
    user:
      name: "{{ item.key }}"
      uid: "{{ item.value.uid }}"
      group: "{{ item.value.grupo }}"
      shell: "{{ item.value.shell }}"
    loop: "{{ usuarios | dict2items }}"
``` 
* * *

### Exercício 2

``` yaml
vars:
  aplicacoes:
    - nome: app1
      versao: 1.0
      ambiente: producao
    - nome: app2
      versao: 2.0
      ambiente: dev

tasks:
  - name: Mostrar apps em produção
    debug:
      msg: "{{ item.nome }} versão {{ item.versao }}"
    loop: "{{ aplicacoes }}"
    when: item.ambiente == 'producao'
```

* * *

### Exercício 3

``` yaml
tasks:
  - name: Agrupar por ambiente
    group_by:
      key: "env_{{ hostvars[inventory_hostname]['env'] }}"
```

* * *

### Exercício 4

``` yaml
vars:
  manutencao: "{{ manutencao_input | default(false) }}"

tasks:
  - name: Executar se manutenção ativa
    debug:
      msg: "Ambiente em manutenção"
    when: manutencao | bool
```

* * *

### Exercício 5

``` yaml
vars:
  nginx_config: |
    server {
        listen 80;
        server_name {{ server_name }};
        root {{ root_dir }};
    }

tasks:
  - name: Criar config nginx
    template:
      src: templates/nginx.conf.j2
      dest: /etc/nginx/sites-available/default
```

* * *

### Exercício 6

``` yaml
vars:
  grupos:
    - nome: dev
      usuarios:
        - alice
        - carol
    - nome: qa
      usuarios:
        - bob

tasks:
  - name: Adicionar usuários a grupos
    user:
      name: "{{ item.1 }}"
      groups: "{{ item.0.nome }}"
    loop: "{{ grupos | subelements('usuarios') }}"
```

* * *

### Exercício 7

``` yaml
vars:
  pacotes_prod: [nginx, mysql]
  pacotes_dev: [vim, htop]
  todos_pacotes: "{{ pacotes_prod + pacotes_dev }}"

tasks:
  - debug:
      msg: "{{ todos_pacotes | join(', ') }}"
```

* * *

### Exercício 8

``` yaml
vars:
  porta: "8080"
  porta_real: "{{ porta | int }}"

tasks:
  - debug:
      msg: "Porta (str): {{ porta }} | Porta convertida (int): {{ porta_real }}"
```

* * *

### Exercício 9

**vars/ambiente.yml**

``` yaml
nome: producao
url: https://api.techskills.org
status: online
```

**Playbook**

``` yaml
- hosts: localhost
  vars_files:
    - vars/ambiente.yml
  tasks:
    - debug:
        msg: "Ambiente {{ nome }} ({{ status }}) disponível em {{ url }}"
```

* * *

### Exercício 10

``` yaml
vars:
  infraestrutura:
    - host: web01
      comentarios: |
        Servidor de testes para frontend.
      servicos:
        - nome: nginx
          porta: 80
          status: ativo
        - nome: redis
          porta: 6379
          status: inativo

tasks:
  - name: Exibir serviços ativos
    debug:
      msg: "Host {{ item.host }} - Serviço {{ servico.nome }} na porta {{ servico.porta }}"
    loop: "{{ infraestrutura }}"
    loop_control:
      label: "{{ item.host }}"
    vars:
      servicos_ativos: "{{ item.servicos | selectattr('status', 'equalto', 'ativo') | list }}"
    with_subelements:
      - "{{ infraestrutura }}"
      - servicos_ativos
```