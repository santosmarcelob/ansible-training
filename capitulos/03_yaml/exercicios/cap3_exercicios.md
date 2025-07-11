
# Exercícios – Fundamentos de YAML no Ansible

1. Crie um playbook chamado `vars_simples.yml` que defina três variáveis: `app_name`, `version` e `enable_logs`. Use o módulo `debug` para exibir seus valores.

2. Crie uma lista chamada `pacotes_basicos` contendo `htop`, `curl`, `vim` e exiba cada item com uma tarefa em loop.

3. Escreva um dicionário com informações de um servidor (`hostname`, `ip`, `env`) e use o módulo `debug` para exibir cada valor separadamente.

4. Crie uma estrutura com dois usuários (`alice` e `bob`) contendo `uid` e `shell`. Itere sobre a lista criando os usuários com o módulo `user`.

5. Crie uma variável chamada `servidores_web`, contendo uma lista de nomes de servidores (ex: `web01`, `web02`, `web03`) e use um loop para exibir mensagens de deploy.

6. Use `dict2items` para iterar sobre um dicionário chamado `servicos` com portas e habilitação, e exiba os serviços habilitados.

7. Crie um bloco de texto literal (`|`) com uma configuração de Nginx simples e grave em um arquivo com o módulo `copy`.

8. Use um bloco dobrado (`>`) para escrever uma mensagem multilinha que será convertida em uma linha única e grave-a com o módulo `copy`.

9. Crie uma variável `valores_testes` contendo exemplos de todos os tipos YAML: string, número, booleano, null e data.

10. Crie um playbook com uma lista chamada `apps` contendo dicionários com `nome` e `versao`, e use o módulo `debug` para imprimir os dados.

11. Escreva um dicionário `config_app` com subchaves como `log_dir`, `port` e `enabled`, e use essas variáveis no módulo `debug`.

12. Crie uma estrutura com um dicionário aninhado contendo dois serviços: `ssh` e `http`, com `port` e `status`.

13. Gere um erro proposital de indentação e tente rodar o playbook para visualizar o erro de sintaxe.

14. Crie um arquivo YAML com uma lista de grupos e associe usuários a esses grupos usando loops.

15. Use filtros como `| lower` e `| join(',')` em tarefas para transformar os valores antes de exibir.

16. Crie uma variável com um valor `null` e condicione a execução de uma tarefa à presença de valor (`when`).

17. Crie uma variável `deploy` com valor `yes` e condicione a execução de uma tarefa à ativação desse valor booleano.

18. Defina um IP como string e use aspas para evitar erro de interpretação.

19. Crie comentários explicativos em pelo menos três blocos de um playbook YAML.

20. Crie um playbook chamado `estrutura_complexa.yml` que combina lista, dicionários aninhados e blocos de texto.