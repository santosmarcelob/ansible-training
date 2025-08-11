# Respostas

## Resposta 1

```ini
[webcluster]
web01 ansible_port=2222
web02

[dbcluster]
db01 db_engine=mysql

[all:vars]
ansible_user=devops
```

## Resposta 2

```yaml
all:
  vars:
    ansible_user: devops
  children:
    webcluster:
      hosts:
        web01:
          ansible_port: 2222
        web02:
    dbcluster:
      hosts:
        db01:
          db_engine: mysql
```

## Resposta 3

```yaml
- hosts: all
  tasks:
    - name: Agrupar por zona
      group_by:
        key: "zona_{{ hostvars[inventory_hostname]['zona'] }}"
```

## Resposta 4
`group_vars/webcluster.yml`

```yaml
nginx_version: 1.20
```

`host_vars/db01.yml`

```yaml
replica: true
port: 3306
```

## Resposta 5

```ini
[webcluster]
web01
web02

[dyn_inventory]
! Script: dynamic_inventory.py (exemplo fictício com retorno JSON)

[all:children]
webcluster
dyn_inventory
```

## Resposta 6

group_vars/all.yml
```yaml
ambiente: default
```

group_vars/webcluster.yml
```yaml
ambiente: web
```

host_vars/web01.yml
```yaml
ambiente: individual
```

Verificação
```bash
ansible-inventory --host web01
```

Resultado: `ambiente: individual` (maior precedência: host > grupo > all)

## Resposta 7

```ini
[webcluster]
web01
web02

[dbcluster]
db01

[infraestrutura:children]
webcluster
dbcluster

[infraestrutura:vars]
timezone=UTC
```

## Resposta 8 – Variáveis nos grupos
```bash
ansible-inventory -i inventario_avancado.ini --graph > grafo.txt
```

## Resposta 9

```bash
plugin: yaml
hosts:
  web01:
    ansible_host: 192.168.1.10
  web02:
    ansible_host: 192.168.1.11
groups:
  webcluster:
    hosts:
      - web01
      - web02

```

## Resposta 10

host_vars/web01.yml
```yaml
tags:
  - frontend
  - produção
```

Playbook para filtrar

```yaml
- hosts: all
  tasks:
    - name: Mostrar hosts com tag 'produção'
      debug:
        msg: "Host {{ inventory_hostname }} é de produção"
      when: "'produção' in tags"
```