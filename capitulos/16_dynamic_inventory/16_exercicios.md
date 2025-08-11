## Exercícios – Capítulo 16: Inventário Dinâmico no Ansible

* * *

### **Exercício 1**

Crie um script Python chamado `inventario_custom.py` que retorne dois grupos: `web` com dois IPs fictícios e `db` com um IP. Faça com que o grupo `web` tenha uma variável `porta: 80`.

* * *

### **Exercício 2**

Torne o script do exercício 1 executável e valide sua saída usando `ansible-inventory`.

* * *

### **Exercício 3**

Use o plugin oficial `aws_ec2` para criar um inventário dinâmico que filtre apenas instâncias com a tag `Ambiente=dev`.

* * *

### **Exercício 4**

Crie um `playbook.yml` que utilize o grupo `tag_Ambiente_dev` proveniente do inventário da AWS para instalar o `nginx`.

* * *

### **Exercício 5**

Configure o arquivo `ansible.cfg` para apontar diretamente para um inventário dinâmico via plugin.

* * *

### **Exercício 6**

Utilize o plugin `docker_containers` para listar todos os contêineres Docker ativos e os agrupe por `image`.

* * *

### **Exercício 7**

Crie um playbook que rode apenas em contêineres Docker do tipo `nginx`, e registre em log o nome e o IP de cada um usando `hostvars`.

* * *

### **Exercício 8**

Use o comando `ansible-inventory --graph` para visualizar a hierarquia de grupos do seu inventário Docker dinâmico.

* * *

### **Exercício 9**

Utilize `hostvars` dentro de um template `.j2` para gerar um relatório de hosts vindo do inventário dinâmico (nome + IP).

* * *

### **Exercício 10**

Escreva um script `validate_inventory.py` que verifica se o inventário dinâmico gerado contém pelo menos 1 host com a chave `ansible_host`.