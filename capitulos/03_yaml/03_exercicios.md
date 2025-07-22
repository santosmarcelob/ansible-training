## Exercícios - Fundamentos de YAML no Ansible

* * *
### Exercício 1: Loop com Dicionário de Dicionários

Crie uma variável chamada `usuarios`, onde cada chave é um nome de usuário e os valores são dicionários com `uid`, `grupo` e `shell`. Itere sobre esse dicionário e use `ansible.builtin.user` para criar os usuários com seus atributos.

* * *

### Exercício 2: Lista de Aplicações por Ambiente

Crie uma variável `aplicacoes` contendo dicionários com `nome`, `versao` e `ambiente`. Exiba apenas os aplicativos com `ambiente: producao` usando um loop com condição `when`.

* * *

### Exercício 3: Agrupamento Dinâmico com `group_by`

Dada uma lista de servidores com variáveis `env=dev`, `env=staging`, ou `env=prod`, use o módulo `group_by` para agrupá-los dinamicamente em grupos com base no ambiente.

* * *

### Exercício 4: Condicional com Filtros YAML e Booleanos

Crie uma variável `manutencao` com valores possíveis: `yes`, `no`, `null`. Crie uma tarefa que só é executada quando `manutencao` for `yes` (de forma booleana). Use `default(false)` para evitar erro.

* * *

### Exercício 5: Templates com Blocos Literais e Variáveis

Crie uma variável `nginx_config` que use bloco literal (`|`) com placeholders como `{{ server_name }}` e `{{ root_dir }}`. Grave o conteúdo renderizado usando o módulo `template`.

* * *

### Exercício 6: Iteração com `subelements`

Crie uma variável `grupos` contendo uma lista de grupos, cada um com sua lista de usuários. Use `subelements` para iterar sobre todos os usuários e adicioná-los ao seu respectivo grupo com o módulo `user`.

* * *

### Exercício 7: Combinação de Variáveis com Filtros e `join`

Crie uma variável `pacotes_prod` e outra `pacotes_dev`, e combine-as dinamicamente em uma nova lista `todos_pacotes`. Exiba a lista resultante em uma única string separada por vírgulas usando `| join(', ')`.

* * *

### Exercício 8: Conversão de Tipos e Validação

Crie uma variável `porta` como string (`"8080"`) e outra chamada `porta_real` que converte essa string para número usando `| int`. Use `debug` para mostrar o tipo e valor de cada uma.

* * *

### Exercício 9: Importação de Variáveis Externas

Crie um playbook que importe um arquivo `vars/ambiente.yml` contendo variáveis do ambiente (`nome`, `url`, `status`), e use essas variáveis em uma mensagem formatada com `debug`.

* * *

### Exercício 10: Estrutura Complexa com Itens Aninhados e Blocos

Crie uma variável `infraestrutura` contendo uma lista de dicionários com:

*   `host`
*   `servicos` (lista de dicionários com `nome`, `porta`, `status`)
*   `comentarios` (bloco literal)     

Use `loop` para exibir os serviços ativos de cada host, ignorando os `status: inativo`.

directly from Word or other rich text sources.