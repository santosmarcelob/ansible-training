# Capítulo 16: Inventário Dinâmico no Ansible

## Introdução

Inventários estáticos funcionam bem para ambientes pequenos e estáveis. No entanto, quando lidamos com infraestrutura dinâmica — como VMs em nuvem, contêineres efêmeros, ou ambientes de múltiplos provedores — manter um inventário manual torna-se inviável. Para isso, o Ansible oferece suporte a **Inventários Dinâmicos**, que extraem os hosts automaticamente de fontes externas como AWS, Azure, GCP, vSphere, bancos de dados, APIs e outros.

---

## Conceito de Inventário Dinâmico

O Ansible espera que um inventário dinâmico seja:

- Um **script ou binário executável**,
- Que retorne um JSON válido com a estrutura dos hosts, grupos e variáveis.

Ele pode ser escrito em qualquer linguagem (Python, Bash, etc.), ou ser um plugin fornecido oficialmente pela comunidade.

---

## Formatos Suportados

### 1. Script Executável

Você pode escrever seu próprio script que retorna JSON com a estrutura de hosts.

### 2. Plugin de Inventário Dinâmico (forma recomendada)

Desde o Ansible 2.8, os plugins são o método preferido. Eles são mais simples de configurar e fáceis de reutilizar.

---

## Exemplo 1: Script Python Simples

### `inventario_dinamico.py`

```python
#!/usr/bin/env python3
import json

hosts = {
    "webservers": {
        "hosts": ["192.168.1.10", "192.168.1.11"],
        "vars": {
            "http_port": 80
        }
    },
    "_meta": {
        "hostvars": {
            "192.168.1.10": {"ansible_user": "ubuntu"},
            "192.168.1.11": {"ansible_user": "ubuntu"}
        }
    }
}
print(json.dumps(hosts))
```

### Permitir execução:

```bash
chmod +x inventario_dinamico.py
```

### Rodar manualmente:

```bash
./inventario_dinamico.py
```

### Usar com Ansible:

```bash
ansible-inventory -i ./inventario_dinamico.py --list
```

---

## Exemplo 2: Plugin Dinâmico da AWS (EC2)

O Ansible fornece um plugin pronto para EC2.

### 1. Instalar dependências:

```bash
pip install boto boto3 botocore
```

### 2. Estrutura esperada:

```
inventario_aws/
├── aws_ec2.yml
└── ansible.cfg
```

### 3. Arquivo `aws_ec2.yml`:

```yaml
plugin: amazon.aws.aws_ec2
regions:
  - us-east-1
keyed_groups:
  - key: tags.Name
    prefix: "tag_"
hostnames:
  - public-ip-address
filters:
  instance-state-name: running
```

### 4. Configuração no `ansible.cfg`:

```ini
[defaults]
inventory = ./inventario_aws/aws_ec2.yml
```

### 5. Executar:

```bash
ansible-inventory --list
```

---

## Exemplo 3: Plugin do Docker

### Arquivo `inventory_docker.yml`:

```yaml
plugin: community.docker.docker_containers
strict: False
```

### Requisitos:

```bash
ansible-galaxy collection install community.docker
pip install docker
```

---

## Estrutura Esperada do JSON

```json
{
  "web": {
    "hosts": ["host1", "host2"],
    "vars": {"var1": "value"}
  },
  "_meta": {
    "hostvars": {
      "host1": {"ansible_host": "10.0.0.1"}
    }
  }
}
```

---

## Integração com Playbooks

```yaml
- name: Playbook com inventário dinâmico
  hosts: tag_WebServer
  tasks:
    - name: Mostrar IP
      debug:
        msg: "{{ inventory_hostname }}"
```

---

## Validando e Testando Inventários Dinâmicos

### 1. Visualizar estrutura:

```bash
ansible-inventory -i meu_inventario.py --list
```

### 2. Testar execução:

```bash
ansible -i inventario_dinamico.py all -m ping
```

### 3. Ver gráfico de grupos:

```bash
ansible-inventory -i inventario_dinamico.py --graph
```

---

## Dicas e Boas Práticas

- Armazene variáveis no bloco `_meta -> hostvars` para melhor desempenho
- Teste localmente antes de usar no CI/CD
- Use `filters` para limitar resultados (ex: EC2 `instance-state-name: running`)
- Evite inventários que demoram muito para gerar
- Combine com `host_vars/` e `group_vars/` quando necessário

---

## Checklist de Aproveitamento do Capítulo

```yaml
✅ Checklist do Aluno
- [ ] Executei um inventário dinâmico via script
- [ ] Usei o plugin `aws_ec2` com credenciais válidas
- [ ] Listei a saída com `ansible-inventory --list`
- [ ] Integrei inventário dinâmico com um playbook real
- [ ] Utilizei `hostvars` em uma tarefa dinâmica
```

---

## Desafio Final

1. Crie um inventário dinâmico usando o plugin `aws_ec2` ou `docker_containers`
2. Filtre apenas instâncias com a tag `Ambiente=dev`
3. Crie um playbook que instala o `nginx` nesses hosts
4. Valide a execução com `ansible-inventory --graph`
5. Use `hostvars` para mostrar o nome e IP de cada máquina

---

Inventários dinâmicos tornam o Ansible ainda mais poderoso em ambientes modernos e em constante mudança. Combinando essa técnica com práticas sólidas de automação, você terá uma base escalável e resiliente para seus projetos.

