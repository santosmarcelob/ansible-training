## Exercícios – Capítulo 2: Introdução ao Ansible

* * *

### Exercício 1: Inventário com Grupos Hierárquicos e Variáveis

Crie um inventário chamado `inventario.ini` que contenha:

*   Um grupo `web_europa` com `web01.eu` e `web02.eu`
*   Um grupo `web_america` com `web01.us`
*   Um grupo `todos_webs` com os dois grupos anteriores
*   Para `web01.eu`, defina a variável `ambiente=producao`
*   Para o grupo `todos_webs`, defina `ntp_server=ntp.techskills.org`     

* * *

### Exercício 2: Criação Condicional com Fatos

Crie um playbook `instalar_nginx_condicional.yml` que:

*   Instale o `nginx` **apenas se** o sistema operacional for Ubuntu **e** tiver pelo menos 2 CPUs

* * *

### Exercício 3: Exibir Tempo de Atividade de Cada Host

Crie um playbook `tempo_atividade.yml` que:

*   Use `ansible.builtin.shell` com `uptime -p`
*   Grave o resultado em arquivos locais `logs/uptime_<host>.log`     

* * *

### Exercício 4: Loop com Lista de Serviços

Crie um playbook `verificar_servicos.yml` que:

*   Verifique se `nginx`, `sshd` e `chronyd` estão ativos nos hosts
*   Use loop com o módulo `ansible.builtin.service_facts` + `debug`     

* * *

### Exercício 5: Uso de Filtros e Variáveis Customizadas

Crie um playbook `exibir_ambiente.yml` que:

*   Defina `ambiente=produção`
*   Mostre a string `"Implantando no ambiente: produção"` em caixa alta usando filtro `| upper`     

* * *

### Exercício 6: Tarefa Condicional Baseada em Variável

Crie um playbook `reiniciar_nginx.yml` que:

*   Só reinicia o nginx se a variável `nginx_ativo` for `true`     

* * *

### Exercício 7: Agrupamento Dinâmico com `group_by`

Crie um playbook `agrupar_por_os.yml` que:

*   Agrupe os hosts dinamicamente com base no sistema operacional detectado     

* * *

### Exercício 8: Uso de `tags` em múltiplas tarefas

Crie um playbook `servidor_tags.yml` com 3 tarefas:

1.  Instala o `nginx` (tag: `web`)
2.  Instala o `postgresql` (tag: `db`)
3.  Instala o `htop` (tag: `tools`)     

Execute com apenas a tag `tools`.

* * *

### Exercício 9: Estrutura de Inventário com `group_vars/`

Crie:

*   Um inventário com grupo `servidores_db`
*   Um arquivo `group_vars/servidores_db.yml` com a variável `db_port=5432`
*   Um playbook `mostrar_porta.yml` que exibe a porta do banco com `debug`     

* * *

### Exercício 10: Validação de Rede com `wait_for`

Crie um playbook `validar_porta.yml` que:

*   Usa `wait_for` para verificar se a porta 22 está aberta nos hosts
*   Define timeout de 3 segundos e exibe mensagem personalizada