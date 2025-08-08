# Capítulo 15: Ansible Vault – Protegendo Dados Sensíveis

## Introdução

Ao trabalhar com automação de infraestrutura, é comum lidar com informações sensíveis como senhas, tokens de API, chaves privadas e dados de conexão. O **Ansible Vault** permite **criptografar** esses dados diretamente nos arquivos do Ansible, garantindo que apenas pessoas autorizadas possam acessá-los.

Este capítulo aborda tudo o que você precisa saber sobre o Ansible Vault, com foco prático para proteger seus playbooks e variáveis.

---

## O Que é o Ansible Vault?

O Ansible Vault permite criptografar arquivos YAML inteiros ou apenas variáveis específicas dentro deles. Os arquivos criptografados podem ser versionados no Git sem expor informações confidenciais.

---

## Comandos Básicos do Ansible Vault

### 1. Criar um arquivo criptografado:

```bash
ansible-vault create segredo.yml
```

### 2. Editar um arquivo criptografado:

```bash
ansible-vault edit segredo.yml
```

### 3. Criptografar um arquivo existente:

```bash
ansible-vault encrypt vars.yml
```

### 4. Descriptografar um arquivo:

```bash
ansible-vault decrypt vars.yml
```

### 5. Alterar a senha de um arquivo:

```bash
ansible-vault rekey vars.yml
```

---

## Exemplo: Variável Criptografada

### Criando arquivo `group_vars/all/vault.yml`:

```bash
ansible-vault create group_vars/all/vault.yml
```

Conteúdo (criptografado):

```yaml
api_key: supersecreta123
```

Playbook:

```yaml
- name: Usando variável protegida
  hosts: all
  vars_files:
    - group_vars/all/vault.yml
  tasks:
    - name: Mostrar chave
      debug:
        msg: "Chave: {{ api_key }}"
```

Execução:

```bash
ansible-playbook playbook.yml --ask-vault-pass
```

---

## Como Usar Senhas sem Interação

### 1. Criar arquivo com a senha:

```bash
echo 'minhasenha' > vault_pass.txt
chmod 600 vault_pass.txt
```

### 2. Usar nos comandos:

```bash
ansible-playbook playbook.yml --vault-password-file vault_pass.txt
```

Ou configurar no `ansible.cfg`:

```ini
[defaults]
vault_password_file = vault_pass.txt
```

---

## Criptografar Apenas Variáveis

Você pode criptografar só os valores das variáveis (inline):

```bash
ansible-vault encrypt_string 'supersecreta123' --name 'api_key'
```

Saída:

```yaml
api_key: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          65396531643436653832613164393365...
```

Esse bloco pode ser colado diretamente em `group_vars/all.yml` ou qualquer outro arquivo YAML.

---

## Vault IDs (múltiplas senhas)

Você pode usar múltiplas senhas para diferentes arquivos:

```bash
ansible-playbook playbook.yml \
  --vault-id dev@vault_dev.txt \
  --vault-id prod@vault_prod.txt
```

No YAML:

```yaml
some_var: !vault |
          $ANSIBLE_VAULT;1.2;AES256;dev
          313139643030393436326238...
```

---

## Boas Práticas com Vault

- Nunca armazene senhas reais em texto plano
- Use `vault_pass.txt` apenas em ambientes seguros e nunca versionados
- Organize seus arquivos criptografados em `group_vars/` ou `host_vars/`
- Prefira `encrypt_string` para variáveis isoladas
- Evite descriptografar arquivos por completo desnecessariamente
- Mantenha backups das senhas (rekey não funciona sem a original)

---

## Exemplo Completo com Senha Criptografada

### Estrutura:

```
meu_projeto/
├── ansible.cfg
├── vault_pass.txt
├── group_vars/
│   └── all.yml
├── playbook.yml
```

### group\_vars/all.yml:

```yaml
api_key: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          6238303132613661...
```

### playbook.yml:

```yaml
- name: Teste com Vault
  hosts: all
  tasks:
    - name: Mostrar variável secreta
      debug:
        msg: "{{ api_key }}"
```

### ansible.cfg:

```ini
[defaults]
vault_password_file = vault_pass.txt
```

Execução:

```bash
ansible-playbook playbook.yml
```

---

## Checklist de Aproveitamento do Capítulo

```yaml
✅ Checklist do Aluno
- [ ] Criei um arquivo Vault com `create` ou `encrypt`
- [ ] Editei arquivos protegidos com `edit`
- [ ] Usei variáveis criptografadas em um playbook
- [ ] Automatizei o uso da senha com `vault_password_file`
- [ ] Usei `encrypt_string` para proteger variáveis específicas
- [ ] Testei múltiplos Vault IDs
```

---

## Desafio Final

1. Crie uma variável `db_password` protegida com `ansible-vault encrypt_string`
2. Salve em `group_vars/database.yml`
3. Crie um playbook que conecta ao banco simulando o uso dessa senha (ex: usar `debug:` com a senha)
4. Configure o `ansible.cfg` para usar `vault_password_file`
5. Execute o playbook e valide que a senha está protegida

