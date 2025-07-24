### Exercícios – Capítulo 9: Handlers

#### **1. Você está configurando um servidor com Nginx. Crie um playbook que:** 

*   Instale o Nginx
*   Copie dois arquivos de configuração diferentes
*   Reinicie o serviço **apenas uma vez**, se algum dos arquivos for alterado

#### **2. Modifique o playbook anterior para usar `listen`, permitindo que múltiplas tarefas notifiquem o mesmo handler por meio de um tópico.**

#### **3. Crie um playbook que:**

*   Atualize o arquivo `/etc/ssh/sshd_config` com um template
*   Notifique dois handlers: um para validar a configuração (`sshd -t`), e outro para reiniciar o SSH
*   Garanta que a validação ocorra antes do reinício     

#### **4. Você precisa reiniciar dois serviços diferentes (`nginx` e `php-fpm`) apenas se seus respectivos arquivos de configuração forem alterados. Implemente handlers separados com nomes descritivos e a notificação correta.**

#### **5. Crie um handler que:**

*   Só será chamado por um `notify` com o nome `"reiniciar_aplicacao"`
*   Reinicie o serviço `myapp`
*   Use `listen` em vez de `name`     

#### **6. Crie um cenário onde:**

*   Uma tarefa é executada, mas **não** resulta em mudança
*   Ela notifica um handler
*   Mostre que o handler **não será executado**     

#### **7. Você quer evitar múltiplos reinícios do mesmo serviço mesmo que várias tarefas o notifiquem. Simule esse cenário com três tarefas distintas que notificam o mesmo handler.**

#### **8. Implemente um handler que use `command: systemctl daemon-reexec` para reaplicar configurações do systemd. O handler deve ser idempotente.**

#### **9. Crie dois handlers com `listen` que reagem ao mesmo tópico, mas fazem ações diferentes. Demonstre como ambos são executados quando o tópico é notificado.**

#### **10. Crie um playbook onde:**

*   Três tarefas modificam arquivos de configuração
*   Cada uma notifica tópicos diferentes
*   Os handlers correspondentes devem ser executados na ordem correta: `reload`, `reexec`, `restart`