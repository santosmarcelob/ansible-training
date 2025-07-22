# Exercícios – Capítulo 5: Agrupamento e Relação Pai-Filho

## 

1. Crie um inventário INI com os seguintes grupos e hosts:
    - Grupo webservers: web1.local, web2.local
    - Grupo databases: db1.local
    - Grupo pai production que agrupa webservers e databases.

##
2. Defina variáveis de ambiente para production no formato INI:
    - ambiente=producao
    - backup_strategy=full

##
3. Crie um inventário YAML equivalente ao do exercício 1, com os mesmos grupos e variáveis herdadas.

##
4. Crie um playbook chamado show_env.yml que imprima o nome do host, o ambiente e a estratégia de backup herdada de seu grupo pai.

##
5. Crie um grupo development que contenha os grupos:
    - dev_web: devweb1.local
    - dev_db: devdb1.local

E defina as variáveis:
    - ambiente=desenvolvimento
    - backup_strategy=incremental

##
6. Modifique o playbook show_env.yml para que imprima uma mensagem diferente caso o host pertença ao grupo development.

##
7. Crie um inventário com variáveis diferentes para webservers e databases. Por exemplo:
    - webservers: http_port=80
    - databases: db_port=5432

Faça um playbook que imprima a porta configurada.

##
8. Use o comando ansible-inventory para gerar o grafo da hierarquia do inventário em YAML.

##
9. Execute um playbook apenas no grupo webservers, mesmo que ele seja filho de production.

##
10. Escreva um playbook que instale o pacote htop apenas nos servidores do grupo production.