## Respostas – Agrupamento Pai-Filho no Ansible
### Exercício 1 – inventario.ini
``` ini
[webservers]
web1.local
web2.local

[dbservers]
db1.local
db2.local

[backend:children]
webservers
dbservers
``` 

### Exercício 2 – Variáveis e Precedência
group_vars/backend.yml

``` yaml
ambiente: producao
``` 
group_vars/webservers.yml

``` yaml
ambiente: teste
``` 
playbook.yml

``` yaml
- hosts: backend
  tasks:
    - name: Mostrar ambiente
      debug:
        msg: "Host {{ inventory_hostname }} está no ambiente {{ ambiente }}"
``` 
### Exercício 3 – Hierarquia + Comando
``` ini
[frontend]
web1.local

[backend]
web2.local
db1.local

[monitoramento]
nagios.local

[infraestrutura:children]
frontend
backend
monitoramento
``` 
``` bash
ansible-inventory -i inventario.ini --graph
``` 
### Exercício 4 – YAML + group_vars

inventario.yml

``` yaml
all:
  children:
    frontend:
      hosts:
        web1.local:
    backend:
      hosts:
        db1.local:
        web2.local:
    monitoramento:
      hosts:
        nagios.local:
    infraestrutura:
      children:
        frontend:
        backend:
        monitoramento:
``` 

group_vars/frontend.yml

``` yaml
ambiente: frontend
``` 
group_vars/backend.yml

``` yaml
ambiente: backend
``` 

group_vars/infraestrutura.yml

``` yaml
ambiente: infra
``` 

### Exercício 5 – Conflito de Variável

``` yaml
# group_vars/backend.yml
db_engine: mysql

# group_vars/dbservers.yml
db_engine: postgres
``` 

``` yaml
- hosts: dbservers
  tasks:
    - debug:
        var: db_engine
``` 

Resultado: postgres (maior precedência para o grupo mais específico).

### Exercício 6 – Sobreposição de variáveis com host em dois grupos
``` ini
[staging]
app1.local app_env=staging

[production]
app1.local app_env=production

[todos:children]
staging
production
``` 

``` bash
ansible-inventory --host app1.local
``` 
Resultado: Precedência depende da ordem dos grupos e do tipo de inventário (YAML ou INI). YAML pode ser mais previsível.

### Exercício 7 – Usando group_names
``` yaml
- hosts: web1.local
  tasks:
    - debug:
        var: group_names
``` 
Resultado: Exibe lista de todos os grupos aos quais web1.local pertence.

### Exercício 8 – Precedência de variável em 3 níveis
group_vars/infra.yml

``` yaml
timezone: UTC
``` 
group_vars/backend.yml

``` yaml
timezone: Europe/Lisbon
``` 

group_vars/dbservers.yml

``` yaml
timezone: America/Sao_Paulo
``` 

Resultado: db01.local usará America/Sao_Paulo

### Exercício 9 – Conflito entre dois filhos
``` ini
[web_internal]
web1.local web_role=internal

[web_external]
web1.local web_role=external

[web:children]
web_internal
web_external
``` 

``` bash
ansible -i inventario.ini -m debug -a "var=web_role" web1.local
``` 

Resultado: O último grupo definido pode sobrescrever variáveis.

### Exercício 10 – group_by por variável
``` yaml
- hosts: all
  vars:
    tipo: "{{ hostvars[inventory_hostname]['tipo'] | default('desconhecido') }}"
  tasks:
    - group_by:
        key: "tipo_{{ tipo }}"

- hosts: tipo_web
  tasks:
    - debug:
        msg: "Executando para servidores WEB"

- hosts: tipo_db
  tasks:
    - debug:
        msg: "Executando para bancos de dados"
``` 

host_vars/web1.local

``` yaml
tipo: web
``` 
host_vars/db1.local

``` yaml
tipo: db
``` 