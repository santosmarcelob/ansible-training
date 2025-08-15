# Respostas — Exemplos de Código
### Exercício 1: Substituição simples com variável
Template (templates/boas_vindas.j2):

``` jinja
Bem-vindo ao servidor {{ inventory_hostname }}
```
Playbook:

``` yaml
- hosts: all
  tasks:
    - name: Gerar mensagem de boas-vindas
      template:
        src: templates/boas_vindas.j2
        dest: /tmp/boas_vindas.txt
```

### Exercício 2: Loop com lista
Variáveis:

``` yaml
usuarios:
  - Alice
  - Bob
  - Carol
```
Template (templates/lista_usuarios.j2):

``` jinja
Lista de usuários:
{% for user in usuarios %}
- {{ user }}
{% endfor %}
```

### Exercício 3: Condicional com variável
Variável:

``` yaml
ambiente: producao
```
Template (templates/ambiente.j2):

```jinja
{% if ambiente == 'producao' %}
Executando em ambiente de produção.
{% else %}
Executando em ambiente de teste.
{% endif %}
```

### Exercício 4: Filtro upper
Variável:

``` yaml
empresa_nome: techskills
```

Template (templates/empresa.j2):

``` jinja
EMPRESA: {{ empresa_nome | upper }}
```

### Exercício 5: Filtro default

Template (templates/api_config.j2):

``` jinja
API_URL={{ api_url | default('http://localhost') }}
```

### Exercício 6: Tabela com nome e IP
Variável:

``` yaml
servidores:
  - nome: web1
    ip: 10.0.0.10
  - nome: web2
    ip: 10.0.0.11
```

Template (templates/servidores.j2):

``` jinja
Servidores:
{% for s in servidores %}
- Nome: {{ s.nome }}
  IP: {{ s.ip }}
{% endfor %}
```

### Exercício 7: Uso de set
Variável:

``` yaml
usuario: marcelo
```

Template (templates/set_usuario.j2):

``` jinja
{% set nome_formatado = usuario | upper %}
Usuário: {{ nome_formatado }}
```

### Exercício 8: Fatos do Ansible
Template (templates/info_sistema.j2):

``` jinja
Distribuição: {{ ansible_facts['distribution'] }}
Data: {{ ansible_date_time.date }}
```

### Exercício 9: YAML formatado com indentação
Variáveis:

``` yaml
servidores:
  - nome: web1
    ip: 10.0.0.10
  - nome: web2
    ip: 10.0.0.11
```

Template (templates/infra.yaml.j2):

``` jinja
infra:
  servidores:
{% for s in servidores %}
    - nome: {{ s.nome }}
      ip: {{ s.ip }}
{% endfor %}
```

### Exercício 10: /etc/motd com hostname, data, distribuição
Template (templates/motd.j2):

``` jinja
Bem-vindo ao servidor {{ inventory_hostname }}
Data: {{ ansible_date_time.date }} {{ ansible_date_time.time }}
Distribuição: {{ ansible_facts['distribution'] }}
```

Playbook:

``` yaml
- hosts: all
  tasks:
    - name: Gerar motd personalizado
      template:
        src: templates/motd.j2
        dest: /etc/motd
```