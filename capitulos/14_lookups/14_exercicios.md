## Exercícios — Capítulo 14: Lookups no Ansible

* * *

### **Exercício 1: Leitura de Arquivo**

Utilize o lookup `file` para ler o conteúdo de um arquivo chamado `mensagem.txt` e exibir via `debug`.

* * *

### **Exercício 2: Variável de Ambiente**

Utilize o lookup `env` para buscar o nome do usuário atual e exibir com `debug`.

* * *

### **Exercício 3: Execução de Comando**

Utilize o lookup `pipe` para obter a data atual com `date` e exibi-la com `debug`.

* * *

### **Exercício 4: Criação de Senha Segura**

Utilize o lookup `password` para criar uma senha aleatória de 12 caracteres e aplicar a um novo usuário.

* * *

### **Exercício 5: Acesso Dinâmico a Variáveis**

Dado o dicionário:

```yaml
user_joao: admin 
user_maria: dev
```

Use o lookup `vars` para exibir dinamicamente a permissão de `user_maria`.

* * *

### **Exercício 6: Leitura de Vários Arquivos com Loop**

Considere que você possui um arquivo `lista.txt` com três nomes de arquivos. Utilize `lookup('file')` com `splitlines()` em um loop para exibir o conteúdo de cada um.

* * *

### **Exercício 7: Leitura de CSV**

Dado um arquivo `usuarios.csv` com:

``` pgsql

joao,admin 
maria,dev
```
Use `lookup('csvfile')` para obter o papel do usuário `joao`.

* * *

### **Exercício 8: Uso em Template `.j2`**

Crie um arquivo `.j2` que exibe:

*   O conteúdo de `/etc/motd` via `lookup('file')`
*   A data atual via `lookup('pipe', 'date')`     

* * *

### **Exercício 9: Lookup em `lineinfile`**

Adicione uma linha no `.bashrc` com a variável de ambiente `HOME` usando `lookup('env', 'HOME')`.

* * *

### **Exercício 10: Desafio Final**

Crie um playbook que:

1.  Lê um arquivo `.env` com variáveis no formato `CHAVE=VALOR`
2.  Usa `lookup('file')` + `splitlines()` para iterar sobre cada linha e adicioná-la em `/etc/environment`
3.  Registra no arquivo `/var/log/deploy.log` a data atual usando `lookup('pipe', 'date')`