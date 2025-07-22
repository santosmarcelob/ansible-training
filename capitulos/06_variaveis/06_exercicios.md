# Exercícios – Variáveis e Facts no Ansible

### Exercício 1:

Defina uma variável `timezone` em três locais diferentes: `group_vars/all.yml`, `group_vars/web.yml` e `host_vars/web1.yml`. Escreva um playbook que exiba o valor final da variável `timezone` para `web1`.

* * *

### Exercício 2:

Crie um playbook que defina um fato personalizado `custom_role` com `set_fact` e o torne persistente com `cacheable: true`. Em seguida, leia esse fato no próximo playbook executado.

* * *

### Exercício 3:

Use o módulo `ansible.builtin.setup` para coletar apenas as `interfaces de rede` e o `hostname`. Salve a saída em um arquivo local `facts_rede.json`.

* * *

### Exercício 4:

Crie um playbook que use `hostvars` para exibir a variável `ansible_facts.default_ipv4.address` de todos os hosts em um único host (por exemplo, `monitor`).

* * *

### Exercício 5:

Utilizando `jinja2` e `ansible_facts`, crie uma estrutura condicional que defina um valor para `timezone` baseado no `ansible_distribution`.

* * *

### Exercício 6:

Defina variáveis com tipos diferentes (`boolean`, `string`, `lista`, `dicionário`) usando `vars`, `defaults`, `group_vars` e `extra_vars`. Execute um playbook que mostre a precedência de cada tipo.

* * *

### Exercício 7:

Crie uma estrutura em `group_vars` que contenha um dicionário `usuarios` com subdados como `uid`, `grupo` e `shell`. Itere sobre os dados para criar usuários nos hosts.

* * *

### Exercício 8:

Desabilite `gather_facts` no início do playbook. Em uma tarefa condicional, colete os fatos com `setup` apenas quando uma variável `coletar_fatos` for verdadeira.

* * *

### Exercício 9:

Use `combine()` para mesclar dois dicionários em tempo de execução com `set_fact`. Use a saída para gerar um novo arquivo de configuração.

* * *

### Exercício 10:

Crie um `playbook` que, ao detectar que o host é da distribuição `Debian`, adicione uma nova variável de repositório; e, se for `RedHat`, adicione outro repositório diferente.