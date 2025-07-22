### Exercícios – Playbooks Ansible

#### **Exercício 1:**

Crie um playbook com dois plays:

*   O primeiro play deve instalar e iniciar o serviço `nginx` nos hosts do grupo `webservers`, mas apenas se a distribuição for `Debian`.
*   O segundo play deve instalar e iniciar o serviço `firewalld` nos hosts do grupo `databases`, mas apenas se a distribuição for `RedHat`.

* * *

#### **Exercício 2:**

Crie um playbook que:

*   Instale os pacotes `htop`, `vim`, `curl` apenas se eles ainda não estiverem presentes no sistema.
*   Capture a saída da instalação e exiba quantos pacotes foram instalados com um `debug`.

* * *

#### **Exercício 3:**

Crie um playbook que tenha um play que:

*   Utilize uma variável `custom_target` definida por linha de comando (via `--extra-vars`) para decidir qual grupo de hosts será usado.
*   Execute um ping nesses hosts e exiba `msg: "Conectado com sucesso ao {{ inventory_hostname }}"` caso o ping retorne com sucesso.     

* * *

#### **Exercício 4:**

Escreva um playbook que:

*   Gere uma sequência de diretórios `/opt/teste1`, `/opt/teste2`, ... até `/opt/teste10`.
*   Use `loop` com `lookup('sequence', ...)` para criar os diretórios.     

* * *

#### **Exercício 5:**

Implemente um playbook com as seguintes tarefas:

*   Execute o comando `uptime`, registre a saída.
*   Se o valor de carga média for superior a 1.00, exiba um alerta com `debug`.     

* * *

#### **Exercício 6:**

Crie um playbook com duas tarefas que:

*   A primeira usa `template` para renderizar um arquivo `/etc/mensagem.j2` para `/etc/mensagem.txt`.
*   A segunda só deve ser executada **se o conteúdo do arquivo foi modificado** (i.e., se `changed == true`).     

* * *

#### **Exercício 7:**

Crie um playbook que:

*   Crie usuários com base na lista de dicionários abaixo:

```yaml
usuarios:
  - nome: joao
    shell: /bin/bash
  - nome: maria
    shell: /bin/zsh
```

*   Use `loop` com dicionários e filtros para definir os parâmetros dinamicamente.     

* * *

#### **Exercício 8:**

Crie um playbook que:

*   Leia o conteúdo de um arquivo `users.txt` onde cada linha é um nome de usuário.
*   Para cada linha, crie um usuário no sistema.

* * *

#### **Exercício 9:**

Escreva um playbook que:

*   Instale `nginx`, copie um template com variáveis, reinicie o serviço.
*   Use `--check` e `--diff` no terminal para validar a execução antes de aplicar.     

* * *

#### **Exercício 10:**

Crie um playbook com múltiplos plays:

*   Primeiro play para instalar e configurar o `nginx` nos webservers.
*   Segundo play para criar um banco no `PostgreSQL` nos hosts `databases`, **somente se o serviço estiver ativo**.