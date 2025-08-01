## Exercícios Práticos — Capítulo 12: Error Handling no Ansible

* * *

### **Exercício 1: Ignorar Falha**

Crie um playbook com uma tarefa que execute `/bin/false`, mas que não interrompa o playbook. Em seguida, exiba uma mensagem de continuação.

* * *

### **Exercício 2: Personalizar falha com `failed_when`**

Crie uma tarefa que execute `echo "ALERTA: Aviso não crítico"` e só considere a tarefa como falha se a palavra `ERRO` estiver na saída.

* * *

### **Exercício 3: Usar `block`, `rescue` e `always`**

Crie um playbook com um `block` que falha, executando:

*   `command: /bin/false`
*   Um `rescue` exibindo mensagem de fallback
*   Um `always` exibindo "Execução finalizada"     

* * *

### **Exercício 4: Interromper com `fail`**

Crie uma verificação para parar o playbook se a variável `meu_parametro` não estiver definida.

* * *

### **Exercício 5: Usar `assert`**

Crie um playbook que afirme que o sistema operacional é do tipo Debian.

* * *

### **Exercício 6: Usar `register` + `when` com falha**

Execute uma tarefa que tenta instalar um pacote inexistente com `apt`. Capture a saída com `register` e exiba uma mensagem condicional se houver falha.

* * *

### **Exercício 7: Verificar `stderr` com `debug`**

Crie uma tarefa com `shell` que falhe e registre a saída. Depois, mostre o `stderr` com um `debug`.

* * *

### **Exercício 8: Parar todos com `any_errors_fatal`**

Crie um playbook onde uma falha em qualquer host interrompa todos os outros.

* * *

### **Exercício 9: Controlar falhas com `max_fail_percentage`**

Crie um playbook com `serial: 2` e `max_fail_percentage: 50`, contendo tarefas que falham.

* * *

### **Exercício 10: Desafio Final**

Crie um playbook que:

*   Tente instalar dois pacotes (um real e um inexistente)
*   Use `register` e `block` com `rescue`
*   Use `assert` para verificar a existência de um arquivo
*   Finalize com `debug` dentro de `always`