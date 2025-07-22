# Exercícios

##
1. Escreva um playbook chamado instala_web.yml que:
   - Instale o pacote nginx em todos os hosts do grupo web.
   - Garanta que o serviço nginx esteja habilitado e rodando.

##
2. Crie um playbook chamado reinicia_servico.yml que:
    - Execute apenas no host server1.
    - Reinicie o serviço ssh apenas se a variável reiniciar_ssh for verdadeira.

##
3. Crie um playbook cria_usuarios.yml que:
    - Crie os usuários ana, carlos e joao, com shell /bin/bash, usando loop.

##
4. Escreva um playbook chamado config_db.yml que:
    - Execute no grupo databases.
    - Instale o pacote postgresql.
    - Registre a saída da instalação em uma variável.
    - Exiba a saída com debug.

##
5. Crie um playbook copiar_config.yml que:
    - Copie o arquivo nginx.conf localizado na pasta files/ local para /etc/nginx/nginx.conf no host remoto.
    - Mostre o diff da mudança (dica: modo de execução, não modifique o playbook).

##
6. Escreva um playbook condicional.yml que:
    - Instale o pacote httpd apenas se a distribuição for CentOS.

##
7. Crie um playbook multi_play.yml que tenha:
    - Primeiro play para instalar nginx no grupo webservers.
    - Segundo play para instalar postgresql no grupo dbservers.

##
8. Crie um playbook verifica_porta.yml que:
    - Execute um comando para listar portas em uso com ss -tuln.
    - Registre a saída e exiba com debug.

##
9. Crie um playbook loop_dict.yml que:
    - Configure 3 serviços (nginx, sshd, cron) usando loop com lookup('dict', ...).

##
10. Crie um playbook valida_sintaxe.yml com qualquer conteúdo válido.
    - Em seguida, diga qual comando deve ser usado para verificar a sintaxe sem executar o playbook.