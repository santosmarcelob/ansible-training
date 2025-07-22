### Exercício 1: Inventário INI com Variáveis por Host, Grupo e Herança

Crie um inventário `inventario_avancado.ini` com:

*   Grupo `webcluster` com hosts `web01`, `web02`
*   Grupo `dbcluster` com host `db01`
*   Variável `ansible_user=devops` no grupo `[all:vars]`
*   Variável `ansible_port=2222` apenas para `web01`
*   Variável `db_engine=mysql` apenas para `db01`     

* * *

### Exercício 2: Inventário YAML com Estrutura Hierárquica

Crie o equivalente do exercício anterior no formato YAML com herança entre grupos e hosts, chamado `inventario_avancado.yml`.

* * *

### Exercício 3: Crie um Grupo Dinâmico Personalizado com `group_by`

Em um playbook, agrupe hosts dinamicamente com base na variável `zona` definida como `interna` ou `externa`.

* * *

### Exercício 4: Estrutura de Inventário com `group_vars` e `host_vars` Separados

Configure os seguintes arquivos:

*   `group_vars/webcluster.yml`: `nginx_version: 1.20`
*   `host_vars/db01.yml`: `replica: true`, `port: 3306`     

* * *

### Exercício 5: Uso de Inventário Misto (estático INI + dinâmico via script)

Integre um inventário `ini` com um inventário dinâmico fictício (ex: script `.py`) que retorna JSON com mais hosts.

* * *

### Exercício 6: Variáveis com Precedência e Override

Crie uma variável `ambiente`:

*   Em `group_vars/all.yml` com valor `default`
*   Em `group_vars/webcluster.yml` com valor `web`
*   Em `host_vars/web01.yml` com valor `individual`     

Use `ansible-inventory --host web01` para verificar qual valor prevalece.

* * *

### Exercício 7: Crie uma Hierarquia de Grupos com `[children]` e `[vars]`

*   Grupo `infraestrutura` com filhos `webcluster`, `dbcluster`
*   Variável comum em `[infraestrutura:vars]` → `timezone: UTC`     

* * *

### Exercício 8: Listar Grupos e Hosts com `ansible-inventory`

Use `ansible-inventory --graph` e redirecione a saída para `grafo.txt`.

* * *

### Exercício 9: Criar Inventário com Métodos Alternativos (script YAML externo via `inventory_plugins`)

Configure um `inventory.yml` com o plugin `yaml` nativo para listar hosts e grupos.

* * *

### Exercício 10: Usar Tags de Hosts via variáveis personalizadas

Adicione tags personalizadas por host, como:

```yaml
tags:
  - frontend
  - produção
```
Use um playbook para filtrar e exibir apenas hosts com `produção`.