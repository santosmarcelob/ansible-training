## Exercícios – Capítulo 15: Ansible Vault

* * *

### **Exercício 1**

Crie um arquivo `group_vars/all.yml` com a variável `api_key` criptografada usando `ansible-vault encrypt_string`, e use-a em um playbook para exibir o valor com `debug:`.

* * *

### **Exercício 2**

Crie dois arquivos criptografados com Vault IDs distintos:

*   `group_vars/dev.yml` com Vault ID `dev`
*   `group_vars/prod.yml` com Vault ID `prod`     

Use ambos em um playbook, de acordo com o ambiente-alvo.

* * *

### **Exercício 3**

Configure o arquivo `ansible.cfg` para usar automaticamente um arquivo de senha Vault (`vault_pass.txt`). Em seguida, execute um playbook sem precisar informar a senha manualmente.

* * *

### **Exercício 4**

Simule o uso de variáveis criptografadas por host criando:

*   `host_vars/web01.yml` com a senha do banco
*   `host_vars/web02.yml` com a mesma variável, mas valor diferente     

As duas devem ser criptografadas com Vault. Exiba as variáveis com `debug:` por host.

* * *

### **Exercício 5**

Utilize `ansible-vault rekey` para alterar a senha de um arquivo criptografado.

* * *

### **Exercício 6**

Implemente um playbook que usa a variável `app_token` criptografada com `encrypt_string` diretamente no `vars:` inline no playbook.

* * *

### **Exercício 7**

Crie um pipeline básico em shell que automatize:

1.  Criação de arquivo criptografado via `encrypt_string`
2.  Inclusão no arquivo `group_vars/all.yml`
3.  Execução do playbook com a senha carregada via `--vault-password-file`     

* * *

### **Exercício 8**

Crie um template `.j2` que usa uma variável criptografada (`api_secret`) e gera um arquivo de configuração.

* * *

### **Exercício 9**

Simule um ambiente com múltiplos Vault IDs. Crie um playbook que falha caso o Vault ID correto não seja usado (teste de segurança).

* * *

### **Exercício 10**

Escreva um playbook que leia variáveis criptografadas e só continue a execução se a variável `env_pass` estiver definida (use `fail:` com `when:`).