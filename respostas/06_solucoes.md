# Respostas – Exercícios - Variáveis e Facts
### Exercício 1 – Precedência de Variáveis

``` yaml
# group_vars/all.yml
timezone: "UTC"

# group_vars/web.yml
timezone: "America/Sao_Paulo"

# host_vars/web1.yml
timezone: "Europe/Lisbon"

# playbook.yml
- hosts: web1
  tasks:
    - debug:
        var: timezone
``` 

Resultado: Europe/Lisbon (host > group > all)

### Exercício 2 – set_fact com cacheable
``` yaml
- hosts: all
  tasks:
    - name: Setar fato persistente
      set_fact:
        custom_role: "web"
      cacheable: true
``` 
Para ler depois:

``` yaml
- hosts: all
  tasks:
    - debug:
        var: custom_role
``` 
Requer fact_caching habilitado em ansible.cfg.

### Exercício 3 – Coletar apenas algumas facts
``` yaml
- hosts: all
  tasks:
    - name: Coletar facts limitados
      setup:
        gather_subset:
          - network
          - hardware
      register: rede_facts

    - name: Salvar em arquivo local
      copy:
        content: "{{ rede_facts | to_nice_json }}"
        dest: "/tmp/facts_rede.json"
``` 

### Exercício 4 – Usando hostvars
``` yaml
- hosts: monitor
  tasks:
    - name: Exibir IPs de todos os hosts
      debug:
        msg: >
          {% for h in groups['all'] %}
            {{ h }} => {{ hostvars[h]['ansible_facts']['default_ipv4']['address'] }}
          {% endfor %}
``` 

### Exercício 5 – Condicional com ansible_distribution
``` yaml
- hosts: all
  tasks:
    - name: Definir timezone com base no SO
      set_fact:
        timezone: >-
          {% if ansible_distribution == "Ubuntu" %}
            Europe/London
          {% elif ansible_distribution == "CentOS" %}
            America/New_York
          {% else %}
            UTC
          {% endif %}

    - debug:
        var: timezone
``` 

### Exercício 6 – Tipos e Precedência
``` yaml
# group_vars/all.yml
variavel_string: "valor1"
variavel_bool: false

# group_vars/web.yml
variavel_string: "valor2"

# defaults/main.yml (em role)
variavel_string: "valor3"

# Linha de comando:
# ansible-playbook playbook.yml -e "variavel_string=valor_final"

# Resultado: valor_final tem maior precedência
``` 
### Exercício 7 – Dicionário de usuários
``` yaml
# group_vars/all.yml
usuarios:
  alice:
    uid: 1001
    grupo: dev
    shell: /bin/bash
  bob:
    uid: 1002
    grupo: ops
    shell: /bin/zsh
``` 

``` yaml
- hosts: all
  tasks:
    - name: Criar usuários
      user:
        name: "{{ item.key }}"
        uid: "{{ item.value.uid }}"
        group: "{{ item.value.grupo }}"
        shell: "{{ item.value.shell }}"
      loop: "{{ usuarios | dict2items }}"
``` 
### Exercício 8 – Condicional para gather_facts
``` yaml
- hosts: all
  gather_facts: false
  vars:
    coletar_fatos: true
  tasks:
    - name: Coletar fatos apenas se solicitado
      setup:
      when: coletar_fatos

    - debug:
        var: ansible_facts.hostname
``` 

### Exercício 9 – Uso de combine
``` yaml
- hosts: all
  vars:
    conf_base:
      porta: 80
      modo: "http"
    conf_extra:
      porta_ssl: 443
      modo_ssl: "https"

  tasks:
    - name: Mesclar dicionários
      set_fact:
        config_final: "{{ conf_base | combine(conf_extra) }}"

    - debug:
        var: config_final
``` 

### Exercício 10 – Variáveis por distribuição
``` yaml
- hosts: all
  tasks:
    - name: Setar repositório conforme distribuição
      set_fact:
        repo: "{{ 'deb http://repo.debian.org stable main' if ansible_distribution == 'Debian' else 'yum.repo.centos.org' }}"

    - debug:
        msg: "Repositório: {{ repo }}"
``` 