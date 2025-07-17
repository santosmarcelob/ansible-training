# Lista de Exercícios - Inventários Ansible

## Exercício 1:
Crie um inventário estático no formato INI com os seguintes grupos e hosts:

- **webservers**: `web1.local`, `web2.local`
- **databases**: `db1.local`

Defina a variável `ansible_user=ubuntu` para todos os hosts.

---

## Exercício 2:
Reescreva o inventário do exercício anterior no formato YAML.

---

## Exercício 3:
Adicione as seguintes variáveis de grupo no inventário YAML:

- Para **webservers**: `http_port: 8080`
- Para **databases**: `db_type: postgres`, `db_version: 15`

---

## Exercício 4:
Crie um arquivo `group_vars/webservers.yml` para definir as variáveis:

- `max_clients: 300`
- `firewall: true`

---

## Exercício 5:
Crie um arquivo `host_vars/db1.local.yml` com as seguintes variáveis específicas para o host:

```yaml
backup_enabled: true
ansible_port: 2222
```

---

## Exercício 6:
Utilizando `ansible-inventory`, visualize a estrutura de grupos do inventário criado e salve o resultado do gráfico em um arquivo `inventario.txt`.

---

## Exercício 7:
Crie um inventário com os seguintes grupos e subgrupos:

- **Grupo production** com filhos: `webservers`, `databases`
- **Grupo development** com filhos: `dev_web`, `dev_db`

Cada subgrupo deve conter pelo menos 1 host.

---

## Exercício 8:
Crie uma variável chamada `ambiente` com valor `producao` no grupo **production**, e `desenvolvimento` no grupo **development**.

---

## Exercício 9:
Use o comando `ansible-inventory` para listar todas as variáveis que se aplicam ao host `web1.local`.

---

## Exercício 10:
Adicione uma variável em `group_vars/all.yml` com o valor padrão:

```yaml
ansible_user: ansible_admin
```

Execute o comando para ver a saída completa em JSON do inventário.