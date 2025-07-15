# Capítulo 13: Templating com Jinja2 no Ansible

## Introdução

No Ansible, Jinja2 é o mecanismo de template utilizado para processar variáveis, expressões, estruturas condicionais e até mesmo gerar arquivos de configuração dinâmicos. Jinja2 é uma poderosa linguagem de templates baseada em Python que permite tornar seus playbooks e arquivos de configuração mais dinâmicos, reutilizáveis e inteligentes.

Este capítulo cobre os principais recursos do Jinja2 no contexto do Ansible, com foco em exemplos práticos.

---

## Onde o Jinja2 é usado no Ansible?

- No corpo dos playbooks (por exemplo: nomes de tarefas, `when`, `vars`, etc.)
- Em arquivos `.j2` usados com o módulo `template`
- Em arquivos de variáveis (group\_vars/host\_vars)

---

## Sintaxe Básica do Jinja2

### 1. Variáveis

```jinja
{{ nome_da_variavel }}
```

### 2. Filtros

```jinja
{{ lista | length }}
{{ nome | upper }}
{{ numero | int }}
```

### 3. Condicionais

```jinja
{% if variavel == 'valor' %}
Texto A
{% else %}
Texto B
{% endif %}
```

### 4. Loops

```jinja
{% for item in lista %}
- {{ item }}
{% endfor %}
```

---

## Utilizando o Módulo `template`

O módulo `template` permite renderizar arquivos `.j2` usando variáveis do Ansible.

### Exemplo:

``

```jinja
server {
  listen {{ porta }};
  server_name {{ dominio }};

  location / {
    proxy_pass http://{{ backend_host }}:{{ backend_port }};
  }
}
```

**Playbook:**

```yaml
- name: Gerar configuração NGINX
  hosts: webservers
  vars:
    porta: 80
    dominio: exemplo.com
    backend_host: 127.0.0.1
    backend_port: 8080
  tasks:
    - name: Gerar nginx.conf
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-enabled/default
```

---

## Filtros Mais Comuns no Jinja2 com Ansible

| Filtro      | Função                                     |
| ----------- | ------------------------------------------ |
| `default()` | Define valor padrão se a variável for nula |
| `join()`    | Junta itens de uma lista                   |
| `split()`   | Divide uma string                          |
| `upper()`   | Converte para maiúsculas                   |
| `lower()`   | Converte para minúsculas                   |
| `replace()` | Substitui valores                          |
| `unique()`  | Remove duplicados de uma lista             |
| `sort()`    | Ordena lista                               |
| `length`    | Tamanho da lista ou string                 |

### Exemplo com filtros:

```jinja
{% set lista = ['banana', 'banana', 'maçã'] %}
{{ lista | unique | join(', ') }}
```

---

## Condicionais e Loops Avançados

### Exemplo: Loop com Condicional

```jinja
{% for user in usuarios %}
{% if user.admin %}
- {{ user.nome }} (admin)
{% else %}
- {{ user.nome }}
{% endif %}
{% endfor %}
```

**Variável:**

```yaml
usuarios:
  - nome: Alice
    admin: true
  - nome: Bob
    admin: false
```

---

## Controle de Indentação e Espaços

Use `-` para remover espaços extras:

```jinja
{% for item in lista -%}
{{ item }}
{%- endfor %}
```

---

## Acessando Fatos e Variáveis do Ansible

```jinja
{{ ansible_facts['distribution'] }}
{{ inventory_hostname }}
{{ hostvars['outro_host']['ansible_default_ipv4']['address'] }}
```

---

## Uso com `lineinfile`, `copy` e outros módulos

Apesar do `template` ser o mais completo para gerar arquivos, o Jinja2 pode ser usado em quase qualquer campo de outros módulos:

```yaml
- name: Adicionar linha ao bashrc
  lineinfile:
    path: ~/.bashrc
    line: "export API_URL={{ api_url | default('http://localhost') }}"
```

---

## Template com Estrutura Complexa

``

```jinja
config:
  ambiente: {{ ambiente }}
  servidores:
  {% for servidor in servidores %}
    - nome: {{ servidor.nome }}
      ip: {{ servidor.ip }}
  {% endfor %}
```

**Variáveis:**

```yaml
ambiente: producao
servidores:
  - nome: web1
    ip: 10.0.0.10
  - nome: web2
    ip: 10.0.0.11
```

---

## Boas Práticas com Jinja2

- Use `set` dentro dos templates para simplificar expressões complexas
- Teste expressões com `debug:` antes de colocá-las em templates
- Prefira `default()` para evitar erros com variáveis indefinidas
- Evite lógicas de negócio complexas no template (faça no playbook)

---

## Checklist de Aproveitamento do Capítulo

```yaml
✅ Checklist do Aluno
- [ ] Usei `{{ variaveis }}` em tarefas e arquivos
- [ ] Apliquei filtros como `default`, `join`, `upper`
- [ ] Criei um arquivo `.j2` com loops e condicionais
- [ ] Usei o módulo `template` para gerar um arquivo
- [ ] Testei `hostvars` e `ansible_facts` dentro de template
```

---

## Desafio Final

1. Crie um playbook que gere um arquivo `/etc/motd` com um template contendo:

   - Nome do host
   - Data e hora atual
   - Distribuição Linux (usando `ansible_facts`)

2. Use um arquivo `.j2` para gerar o conteúdo dinâmico

3. Teste com diferentes hosts do seu inventário

**Dica:** use `ansible_date_time`, `ansible_facts['distribution']`, `inventory_hostname`

