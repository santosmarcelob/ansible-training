# Respostas dos Exercícios

### Exercício 1 – inventario.ini

```ini
[web_europa]
web01.eu ambiente=producao
web02.eu

[web_america]
web01.us

[todos_webs:children]
web_europa
web_america

[todos_webs:vars]
ntp_server=ntp.techskills.org
```

### Exercício 2 – instalar_nginx_condicional.yml

```yaml
- hosts: all
  become: true
  tasks:
    - name: Instalar nginx se for Ubuntu com >=2 CPUs
      package:
        name: nginx
        state: present
      when: ansible_facts['distribution'] == 'Ubuntu' and ansible_facts['processor_cores'] >= 2
```

### Exercício 3 – tempo_atividade.yml
```yaml
- hosts: all
  tasks:
    - name: Obter uptime
      shell: uptime -p
      register: resultado

    - name: Salvar localmente
      copy:
        content: "{{ resultado.stdout }}"
        dest: "logs/uptime_{{ inventory_hostname }}.log"
      delegate_to: localhost
```

### Exercício 4 – verificar_servicos.yml
```yaml
- hosts: all
  tasks:
    - name: Coletar fatos dos serviços
      service_facts:

    - name: Verificar serviços
      debug:
        msg: "{{ item }} está {{ services[item].state }}"
      loop:
        - nginx
        - sshd
        - chronyd
      when: item in services
```

### Exercício 5 – exibir_ambiente.yml
```yaml
- hosts: localhost
  vars:
    ambiente: produção
  tasks:
    - debug:
        msg: "Implantando no ambiente: {{ ambiente | upper }}"
```

### Exercício 6 – reiniciar_nginx.yml
```yaml
- hosts: all
  become: true
  vars:
    nginx_ativo: true
  tasks:
    - name: Reiniciar nginx se ativo
      service:
        name: nginx
        state: restarted
      when: nginx_ativo
```

### Exercício 7 – agrupar_por_os.yml
```yaml
- hosts: all
  tasks:
    - name: Agrupar por OS
      group_by:
        key: "os_{{ ansible_facts['distribution'] | lower }}"
```

### Exercício 8 – servidor_tags.yml
```yaml
- hosts: all
  become: true
  tasks:
    - name: Instalar nginx
      package:
        name: nginx
        state: present
      tags: web

    - name: Instalar postgresql
      package:
        name: postgresql
        state: present
      tags: db

    - name: Instalar htop
      package:
        name: htop
        state: present
      tags: tools
```
Execução parcial:
```bash
ansible-playbook servidor_tags.yml --tags tools
```

### Exercício 9 – Estrutura

inventario.ini

```ini
[servidores_db]
db01
``` 

group_vars/servidores_db.yml

```yaml
db_port: 5432
``` 

mostrar_porta.yml

```yaml
- hosts: servidores_db
  tasks:
    - debug:
        msg: "Porta do banco de dados: {{ db_port }}"
```

### Exercício 10 – validar_porta.yml
```yaml
- hosts: all
  tasks:
    - name: Verificar porta 22
      wait_for:
        port: 22
        timeout: 3

    - name: Exibir mensagem
      debug:
        msg: "Porta SSH 22 acessível em {{ inventory_hostname }}"
```