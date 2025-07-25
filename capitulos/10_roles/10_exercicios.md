### Exercícios – Roles no Ansible

#### **1.** Crie uma estrutura de role chamada `mysql` com os diretórios corretos. Dentro dela, crie o `tasks/main.yml` que:

*   Instale o pacote `mysql-server`
*   Inicie o serviço `mysql`
*   Notifique o handler `reiniciar mysql`     

#### **2.** No handler da role `mysql`, crie uma tarefa que reinicie o serviço `mysql`.

#### **3.** Na role `mysql`, defina no `defaults/main.yml` a variável `mysql_port` com valor `3306` e utilize essa variável em um template `my.cnf.j2`.

#### **4.** Crie um playbook `site.yml` que utilize a role `mysql` e sobrescreva a variável `mysql_port` para `3307`.

#### **5.** Crie uma role `firewall` com um arquivo `meta/main.yml` que permita seu uso como dependência. Adicione como dependência dela a role `common`.

#### **6.** Crie um exemplo de `include_role` e `import_role` dentro de um playbook. A role pode ser fictícia chamada `backup`.

#### **7.** Explique a diferença prática entre `defaults/main.yml` e `vars/main.yml` em uma role e em qual usar variáveis que devem sempre prevalecer.

#### **8.** Modifique uma role `webapp` para que use um arquivo `index.html` localizado em `files/index.html` e utilize o módulo `copy` para colocá-lo em `/var/www/html`.

#### **9.** Dentro de uma role `apache`, use `template` para gerar um arquivo `apache.conf` baseado em uma variável `listen_port`. Essa variável deve ser definida em `defaults/main.yml`.

#### **10.** No `site.yml`, inclua a role `apache` e sobrescreva a variável `listen_port` para `8081`, além de aplicar a role apenas aos hosts do grupo `webservers`.