## Lista de Exercícios — Capítulo 11: Strategies no Ansible

* * *

### **Exercício 1 – Teste de Strategies**

Crie um playbook chamado `test_strategy.yml` que:

* *   Execute 3 tarefas:
*     
*     1. 1.  Aguarde 5 segundos.
*     1.     
*     1. 2.  Mostre o nome do host com `debug`.
*     1.     
*     1. 3.  Copie um arquivo `README.txt` para `/tmp/README.txt`.
*     1.     
* *   Teste esse playbook com cada uma das 3 strategies: `linear`, `free`, `host_pinned`.
*     
* *   Cronometre o tempo total em cada execução.
*     

* * *

### **Exercício 2 – Estratégia definida no ansible.cfg**

Crie um arquivo `ansible.cfg` com a seguinte configuração:

ini

CopiarEditar

`[defaults] strategy = host_pinned`

Depois, execute o playbook do Ex. 1 **sem definir strategy no playbook** e verifique qual strategy é usada.

* * *

### **Exercício 3 – Atualização em lotes**

Crie um playbook chamado `update_batch.yml` que:

* *   Utilize a strategy `free`
*     
* *   Aplique `serial: 2`
*     
* *   Atualize os pacotes dos hosts (use o módulo `apt` ou `yum` conforme o sistema)
*     

* * *

### **Exercício 4 – Comportamento com falha**

Crie um playbook com:

* *   strategy: `free`
*     
* *   diretiva `any_errors_fatal: true`
*     
* *   Uma tarefa que falha propositalmente em um dos hosts (`command: /bin/false`)
*     
* *   Observe o que acontece com os demais hosts.
*     

* * *

### **Exercício 5 – Comparação com e sem strategy**

Execute um mesmo playbook de 3 tarefas:

* *   Com strategy omitida (usa padrão: `linear`)
*     
* *   Com `strategy: free`
*     
* *   Com `strategy: host_pinned`
*     
* *   Documente o comportamento e diferenças observadas entre os modos.
*     

* * *

### **Exercício 6 – Strategy dinâmica via variável de ambiente**

Execute um playbook **sem strategy definida** usando:

bash

CopiarEditar

`ANSIBLE_STRATEGY=free ansible-playbook -i inventory.yml test_strategy.yml`

Depois altere para:

bash

CopiarEditar

`ANSIBLE_STRATEGY=linear ...`

Compare os tempos e logs.

* * *

### **Exercício 7 – Criando uma strategy customizada**

Crie um plugin de strategy personalizada chamado `custom_banner.py`, que:

* *   Mostre a mensagem "Executando minha strategy personalizada!" no início.
*     
* *   Baseie-se na strategy `linear`.
*     

Configure o `ansible.cfg` para usar o plugin.

* * *

### **Exercício 8 – Uso de `strategy` com `include_tasks`**

Crie um playbook que:

*   Use `strategy: free`
*   Use `include_tasks` para incluir um arquivo `tasks/tasks.yml` que contenha 2 tarefas demoradas.     

Observe se o comportamento de strategy se mantém no arquivo incluído.

* * *

### **Exercício 9 – Uso de `serial` com `linear`**

Crie um playbook chamado `serial_linear.yml` que:

*   Use `strategy: linear`
*   Use `serial: 2`
*   Realize qualquer tarefa simples (ex: `ping`) para verificar a execução em lotes de 2 hosts.     

* * *

### **Exercício 10 – Benchmark**

Monte uma tabela com os tempos de execução dos playbooks nos seguintes contextos:

*   `strategy: linear`
*   `strategy: free`
*   `strategy: host_pinned`
*   `serial: 2`
*   `any_errors_fatal: true`
    

Analise e escreva uma conclusão sobre qual strategy foi mais eficiente no seu ambiente.