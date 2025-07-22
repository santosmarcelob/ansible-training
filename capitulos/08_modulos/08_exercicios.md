## Exercícios — Capítulo 8: Módulos Ansible

### **1. Crie uma tarefa que utilize `ansible.builtin.copy` para copiar um arquivo local chamado `motd` para `/etc/motd`, mas **apenas se** ele for diferente do arquivo remoto.**

* * *

### **2. Crie uma tarefa com `ansible.builtin.file` que:**

*   Crie o diretório `/opt/app/logs`
*   Defina permissões `0750`
*   Proprietário como `appuser`
*   Grupo como `adm`

* * *

### **3. Escreva uma tarefa com `ansible.builtin.package` que instale `curl`, `vim` e `net-tools`, independentemente do sistema operacional (Debian ou RedHat-like), e **sem duplicar código**.**

* * *

### **4. Crie uma tarefa que reinicie o serviço `nginx` **somente** se o arquivo `/etc/nginx/nginx.conf` for alterado.**

* * *

### **5. Use `ansible.builtin.template` para gerar um arquivo `/etc/myapp.conf` com base em um template `myapp.conf.j2` e passando uma variável chamada `port`.**

* * *

### **6. Crie uma tarefa que use `ansible.builtin.shell` para verificar se a porta 22 está ouvindo usando o comando `ss -tuln | grep :22`, e registre a saída para exibição posterior.**

* * *

### **7. Crie um bloco de tarefas em que o arquivo `/etc/fstab` seja copiado para `/backup/fstab.bkp` **apenas se** ele ainda não existir no destino. Use `creates`.**

* * *

### **8. Crie uma tarefa que use `ansible.builtin.command` para executar `hostname -f` e exiba a saída com `debug`.**

* * *

### **9. Escreva uma tarefa usando `ansible.builtin.service` para garantir que o serviço `cron` esteja rodando **e habilitado** no boot, em qualquer sistema.**

* * *

### **10. Use `ansible.builtin.debug` para exibir a distribuição e versão do sistema operacional coletada automaticamente.**