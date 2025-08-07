## Exercícios — Capítulo 13: Templating com Jinja2 no Ansible

* * *

### **Exercício 1: Substituição simples com variável**

Crie um template `.j2` que gere um arquivo contendo a frase:  
`Bem-vindo ao servidor {{ inventory_hostname }}`  
Use o módulo `template` para gerar o arquivo `/tmp/boas_vindas.txt`.

* * *

### **Exercício 2: Loop simples com lista**

Crie um template que liste os nomes de uma lista chamada `usuarios`.  
O resultado deve ser salvo em `/tmp/lista_usuarios.txt`.

* * *

### **Exercício 3: Condicional com variáveis**

Crie um template que mostre uma mensagem diferente para ambientes `producao` e `teste`, baseada na variável `ambiente`.

* * *

### **Exercício 4: Uso de filtros**

Crie um template que transforme a string `empresa_nome` em letras maiúsculas e salve no arquivo `/tmp/empresa.txt`.

* * *

### **Exercício 5: Filtro `default`**

Crie uma linha com a URL da API usando `{{ api_url | default('http://localhost') }}` e salve em `/tmp/api_config.txt`.

* * *

### **Exercício 6: Tabela com dados**

Crie um template que gere uma tabela com os campos `nome` e `ip` da lista `servidores`.

* * *

### **Exercício 7: Uso de `set` dentro do template**

Crie um template que use `{% set nome_formatado = usuario | upper %}` e mostre `Usuário: {{ nome_formatado }}`.

* * *

### **Exercício 8: Acesso a fatos do Ansible**

Gere um template que use `ansible_facts['distribution']` e `ansible_date_time.date` para gerar um cabeçalho em `/tmp/info_sistema.txt`.

* * *

### **Exercício 9: Template com indentação correta**

Crie um YAML formatado usando template, onde os servidores são listados com indentação adequada.

* * *

### **Exercício 10: Desafio Final**

Crie um playbook que gere um `/etc/motd` com um template contendo:

* *   Hostname
*     
* *   Data e hora atual
*     
* *   Distribuição Linux
*