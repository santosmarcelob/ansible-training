# Respostas dos Exercícios
### Resposta 1 – inventario_custom.py
``` python
#!/usr/bin/env python3
import json

data = {
    "web": {
        "hosts": ["192.168.0.10", "192.168.0.11"],
        "vars": {"porta": 80}
    },
    "db": {
        "hosts": ["192.168.0.20"]
    },
    "_meta": {
        "hostvars": {
            "192.168.0.10": {"ansible_user": "ubuntu"},
            "192.168.0.11": {"ansible_user": "ubuntu"},
            "192.168.0.20": {"ansible_user": "postgres"}
        }
    }
}
print(json.dumps(data))
```
### Resposta 2
```bash
chmod +x inventario_custom.py
```
ansible-inventory -i ./inventario_custom.py --list

### Resposta 3 – aws_ec2.yml
``` yaml
plugin: amazon.aws.aws_ec2
regions:
  - us-east-1
filters:
  tag:Ambiente: dev
keyed_groups:
  - key: tags.Ambiente
    prefix: tag_Ambiente_
hostnames:
  - public-ip-address
```
Instalar dependências:

```bash
pip install boto boto3 botocore
```

### Resposta 4 – playbook.yml
``` yaml
- name: Instalar nginx em instâncias dev
  hosts: tag_Ambiente_dev
  become: yes
  tasks:
    - name: Instalar nginx
      ansible.builtin.package:
        name: nginx
        state: present
```

### Resposta 5 – ansible.cfg
``` ini
[defaults]
inventory = ./inventario_aws/aws_ec2.yml
```
### Resposta 6 – inventory_docker.yml
``` yaml
plugin: community.docker.docker_containers
strict: false
keyed_groups:
  - key: image
    prefix: image_
```
Instalar requisitos:

```bash
ansible-galaxy collection install community.docker
pip install docker
```

### Resposta 7 – playbook_nginx.yml
``` yaml
- name: Registrar info dos containers nginx
  hosts: image_nginx
  gather_facts: no
  tasks:
    - name: Mostrar IP e nome
      debug:
        msg: "Container: {{ inventory_hostname }}, IP: {{ hostvars[inventory_hostname]['ansible_host'] }}"
```

### Resposta 8
``` bash
ansible-inventory -i inventory_docker.yml --graph
```

### Resposta 9 – relatorio.j2
``` jinja
Relatório de Hosts:

{% for host in groups['all'] %}
- Nome: {{ host }}
  IP: {{ hostvars[host]['ansible_host'] }}
{% endfor %}
```
Playbook para gerar:

``` yaml
- hosts: all
  gather_facts: no
  tasks:
    - name: Criar relatório
      template:
        src: relatorio.j2
        dest: /tmp/relatorio_hosts.txt
```

### Resposta 10 – validate_inventory.py
``` python
#!/usr/bin/env python3
import subprocess
import json
import sys

output = subprocess.check_output(["ansible-inventory", "-i", "./inventario_custom.py", "--list"])
inventory = json.loads(output)

hostvars = inventory.get("_meta", {}).get("hostvars", {})

valid = any("ansible_host" in v for v in hostvars.values())

if valid:
    print("Inventário OK – pelo menos 1 host com ansible_host")
    sys.exit(0)
else:
    print("Nenhum host com ansible_host encontrado")
    sys.exit(1)
```