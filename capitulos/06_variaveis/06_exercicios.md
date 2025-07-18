# Exercícios – Capítulo 6: Variáveis e Fatos

##
1. Crie um playbook que use uma variável chamada nome_do_servico definida dentro da seção vars: e instale esse serviço usando o módulo package.

##
2. Modifique o exercício anterior para que a variável nome_do_servico seja passada pela linha de comando com -e, e não esteja definida no playbook.

##
3. Crie um playbook que defina uma lista de pacotes em uma variável chamada lista_pacotes e instale todos os pacotes dessa lista.

##
4. Crie uma variável config com as chaves porta e ambiente. Exiba essas informações em uma mensagem formatada com o módulo debug.

##
5. Crie uma variável chamada mensagem_host no arquivo host_vars do host web1, e exiba essa variável no playbook com o módulo debug.

##
6. Crie um playbook que exiba o sistema operacional e o endereço IP padrão do host usando ansible_facts.

##
7. Crie um playbook que instale apache2 se o sistema for da família Debian e httpd se for da família RedHat, utilizando ansible_facts.os_family.

##
8. Crie uma variável porta_http no group_vars do grupo webservers. Em um playbook, exiba essa variável. Depois, execute o playbook sobrescrevendo o valor via -e.

##
9. Crie um playbook que execute o comando uptime, registre a saída em uma variável e exiba essa saída com o módulo debug.

##
10. Crie um playbook que tenha gather_facts: false, e mesmo assim tente acessar ansible_facts.hostname. Use ignore_errors: true para evitar falha na execução.

