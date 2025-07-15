# Capítulo 14: Lookups no Ansible

## Introdução

Os **lookups** no Ansible são uma poderosa ferramenta para buscar dados externos durante a execução dos playbooks. Com eles, você pode acessar informações fora do seu inventário ou de variáveis definidas — como arquivos locais, senhas seguras, entradas de DNS, variáveis de ambiente e muito mais.

Lookups são avaliados no **control node** (a máquina que executa o Ansible) e não no host remoto. Eles são muito utilizados em tarefas dinâmicas, templates e variáveis.

---

## Sintaxe Geral

```jinja
{{ lookup('plugin', 'argumento') }}
```

Ou em YAML:

```yaml
vars:
  conteudo: "{{ lookup('file', '/etc/versao') }}"
```

Você também pode usar `lookup()` em loops com `with_` ou `loop:`.

---

## Principais Plugins de Lookup

| Plugin     | Descrição                            |
| ---------- | ------------------------------------ |
| `file`     | Lê conteúdo de um arquivo local      |
| `env`      | Busca variável de ambiente           |
| `pipe`     | Executa um comando e captura a saída |
| `password` | Gera/salva senhas criptografadas     |
| `csvfile`  | Lê valores de arquivos CSV           |
| `ini`      | Lê valores de arquivos INI           |
| `dns`      | Realiza resolução DNS                |
| `vars`     | Acessa variáveis dinamicamente       |
| `dig`      | Usa o comando dig para obter DNS     |

---

## Exemplos Práticos

### 1. `file`: Conteúdo de um arquivo

```yaml
- name: Ler conteúdo de arquivo
  debug:
    msg: "Arquivo contém: {{ lookup('file', './mensagem.txt') }}"
```

### 2. `env`: Variável de ambiente do control node

```yaml
- name: Obter usuário local
  debug:
    msg: "Usuário atual: {{ lookup('env', 'USER') }}"
```

### 3. `pipe`: Executar comando local e capturar saída

```yaml
- name: Obter nome do host local
  debug:
    msg: "Hostname: {{ lookup('pipe', 'hostname') }}"
```

### 4. `password`: Criar senha segura

```yaml
- name: Gerar senha criptografada
  user:
    name: app
    password: "{{ lookup('password', 'senhas/app.pass chars=ascii_letters,digits length=15') | password_hash('sha512') }}"
```

### 5. `csvfile`: Buscar valor em CSV

**Arquivo **``**:**

```
joao,admin
maria,dev
```

```yaml
- name: Obter grupo do usuário
  debug:
    msg: "Grupo: {{ lookup('csvfile', 'maria file=usuarios.csv delimiter=,') }}"
```

### 6. `dns`: Resolver IP

```yaml
- name: Resolver domínio
  debug:
    msg: "IP do site: {{ lookup('dns', 'example.com') }}"
```

---

## Lookup com Loops

Você pode combinar `lookup()` com `loop:` ou `with_` para múltiplas entradas:

```yaml
- name: Ler vários arquivos
  debug:
    msg: "{{ item }}"
  loop: "{{ lookup('file', 'arquivos/lista.txt').splitlines() }}"
```

Ou:

```yaml
- name: Iterar com lookup
  debug:
    msg: "Item: {{ item }}"
  with_items: "{{ lookup('file', 'dados.txt').split(',') }}"
```

---

## Lookup vs Query

- `lookup()` retorna **apenas uma string** ou lista de strings.
- `query()` retorna **estrutura de dados mais rica** (usado quando você espera listas ou dicionários).

### Exemplo com `query()`:

```yaml
- name: Ler múltiplos arquivos
  debug:
    msg: "{{ item }}"
  loop: "{{ query('file', ['a.txt', 'b.txt']) }}"
```

---

## Lookup Dinâmico de Variáveis

Você pode usar `lookup('vars', 'nome_variavel')` para acessar variáveis dinamicamente:

```yaml
vars:
  user_joao: admin
  user_maria: dev

- name: Mostrar permissão de Maria
  debug:
    msg: "{{ lookup('vars', 'user_maria') }}"
```

---

## Uso em Templates

Você pode usar `lookup` dentro de arquivos `.j2`:

```jinja
Mensagem: {{ lookup('file', '/etc/motd') }}
Data: {{ lookup('pipe', 'date') }}
```

---

## Boas Práticas com Lookups

- Sempre trate exceções com `default()` para evitar erros em tempo de execução
- Use `query()` quando esperar listas/dicionários
- Evite usar `lookup` em tarefas que rodarão em múltiplos hosts se os dados são locais ao control node
- Prefira `hostvars`, `vars` e `group_vars` para dados que mudam por host

---

## Checklist de Aproveitamento do Capítulo

```yaml
✅ Checklist do Aluno
- [ ] Usei `lookup('file')`, `lookup('env')` e `lookup('pipe')`
- [ ] Combinei lookup com `loop:` ou `with_items:`
- [ ] Usei `lookup('vars')` para acessar variáveis dinamicamente
- [ ] Criei uma senha segura com `lookup('password')`
- [ ] Usei `lookup` dentro de um template `.j2`
```

---

## Desafio Final

1. Crie um arquivo `.env` com variáveis de configuração (ex: `API_KEY=XYZ123`)
2. Use `lookup('file')` e `splitlines()` para extrair as variáveis e injetar no `/etc/environment`
3. Crie um template `.j2` que usa `lookup('pipe', 'date')` para registrar a data de implantação

**Dica extra:** explore outros plugins com `ansible-doc -t lookup -l`

