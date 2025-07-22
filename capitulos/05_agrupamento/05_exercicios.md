# Exercícios

* * *

### Exercício 1:

Crie um inventário INI com os grupos `webservers` e `dbservers`, e um grupo `backend` que contenha os dois grupos como filhos. Adicione ao menos dois hosts por grupo.

* * *

### Exercício 2:

Adicione uma variável `ambiente=producao` ao grupo `backend` e sobrescreva com `ambiente=teste` no grupo `webservers`. Em um playbook, exiba o valor de `ambiente` para cada host.

* * *

### Exercício 3:

Crie um grupo `infraestrutura` com os filhos `frontend`, `backend` e `monitoramento`. Adicione hosts fictícios a cada grupo. Use `ansible-inventory --graph` para visualizar a hierarquia.

* * *

### Exercício 4:

Crie um inventário no formato YAML que contenha os mesmos grupos e subgrupos do exercício anterior. Defina variáveis em `group_vars/` com valores diferentes para `ambiente` por grupo.

* * *

### Exercício 5:

Configure `group_vars/backend.yml` com a variável `db_engine=mysql` e `group_vars/dbservers.yml` com `db_engine=postgres`. Em um playbook, exiba qual engine está sendo usada por cada host.

* * *

### Exercício 6:

Crie um inventário com os grupos `staging` e `production`, e um grupo pai chamado `todos`. Atribua um host em comum (`app1.local`) a ambos os grupos filhos e verifique qual variável prevalece, definindo `app_env=staging` e `app_env=production`.

* * *

### Exercício 7:

Adicione o host `web1.local` aos grupos `webservers`, `frontend` e `production`. Crie um playbook que exiba todos os grupos aos quais esse host pertence usando `group_names`.

* * *

### Exercício 8:

Implemente uma hierarquia com 3 níveis:

*   `infra`
*   `backend`
*   `dbservers`

E defina a variável `timezone=UTC` em `infra`, `timezone=Europe/Lisbon` em `backend`, e `timezone=America/Sao_Paulo` em `dbservers`. Verifique qual valor será usado por um host `db01.local`.

* * *

### Exercício 9:

Crie uma estrutura em que um host pertence a **dois grupos filhos** de um mesmo **grupo pai**, e defina variáveis conflitantes nos dois filhos. Use `ansible -m debug` para demonstrar qual grupo teve precedência.

* * *

### Exercício 10:

Utilize `group_by` em um playbook para agrupar dinamicamente os hosts com base em uma variável `tipo`. Depois, itere sobre cada novo grupo criado (`tipo_web`, `tipo_db`, etc.) para aplicar tarefas diferentes.