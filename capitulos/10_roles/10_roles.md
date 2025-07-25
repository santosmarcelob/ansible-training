# Capítulo 10: Roles no Ansible

## O que são Roles e por que usá-las?

Conforme os playbooks crescem em complexidade, torna-se essencial organizar o código de maneira reutilizável, modular e escalável. As **roles** (ou "funções") são uma maneira padronizada de estruturar código no Ansible. Elas ajudam a separar lógicas de configuração em componentes reutilizáveis, facilitando a manutenção e a colaboração.

### Benefícios das Roles:

- Reutilização de código entre diferentes projetos ou playbooks.
- Organização clara e padronizada.
- Facilita testes e compartilhamento.
- Reduz a duplicação de configurações.

---

## Estrutura de uma Role

Uma role segue uma estrutura de diretórios definida pelo Ansible:

```
roles/
├── nginx/
│   ├── tasks/
│   │   └── main.yml
│   ├── handlers/
│   │   └── main.yml
│   ├── defaults/
│   │   └── main.yml
│   ├── vars/
│   │   └── main.yml
│   ├── files/
│   │   └── index.html
│   ├── templates/
│   │   └── nginx.conf.j2
│   └── meta/
│       └── main.yml
```

### Diretórios e suas Funções

- `tasks/`: tarefas principais da role. O arquivo `main.yml` será incluído automaticamente.
- `handlers/`: define os *handlers* usados por `notify`.
- `defaults/`: variáveis padrão, com menor precedência.
- `vars/`: variáveis obrigatórias ou sensíveis.
- `files/`: arquivos que podem ser copiados com o módulo `copy`.
- `templates/`: arquivos Jinja2 para uso com o módulo `template`.
- `meta/`: dependências e metadados da role.

---

## Criando uma Role na Prática

Você pode criar uma role manualmente ou usando o comando:

```bash
ansible-galaxy init roles/nginx
```

Isso gerará toda a estrutura necessária. A seguir, um exemplo prático para configurar o servidor **NGINX**.

### `roles/nginx/tasks/main.yml`

```yaml
- name: Instalar nginx
  apt:
    name: nginx
    state: present
  notify: Reiniciar nginx

- name: Copiar configuração personalizada
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Reiniciar nginx

- name: Copiar página HTML
  copy:
    src: index.html
    dest: /var/www/html/index.html
```

### `roles/nginx/handlers/main.yml`

```yaml
- name: Reiniciar nginx
  service:
    name: nginx
    state: restarted
```

### `roles/nginx/defaults/main.yml`

```yaml
server_port: 80
```

### `roles/nginx/templates/nginx.conf.j2`

```jinja
server {
    listen {{ server_port }};
    server_name localhost;
    location / {
        root /var/www/html;
        index index.html;
    }
}
```

### `roles/nginx/files/index.html`

```html
<h1>Servidor NGINX Gerenciado pelo Ansible</h1>
```

---

## Utilizando Roles em um Playbook

```yaml
# site.yml
- name: Configurar servidores web
  hosts: webservers
  become: yes
  roles:
    - nginx
```

Ao executar:

```bash
ansible-playbook -i inventory.yml site.yml
```

O Ansible buscará automaticamente a role `nginx` dentro da pasta `roles/`.

---

## Usando Variáveis com Roles

Se quiser sobrescrever uma variável de `defaults/main.yml`, defina no `host_vars`, `group_vars` ou diretamente no playbook:

```yaml
- name: Configurar com porta diferente
  hosts: webservers
  become: yes
  roles:
    - role: nginx
      vars:
        server_port: 8080
```

---

## Dependências entre Roles

A role pode declarar dependências no arquivo `meta/main.yml`:

```yaml
---
dependencies:
  - role: firewall
    vars:
      ports:
        - 80
        - 443
```

O Ansible irá automaticamente executar a role `firewall` antes da `nginx`.

---

## Roles com `include_role` e `import_role`

Você também pode chamar roles dentro de um `tasks:` normal:

```yaml
- name: Incluir dinamicamente
  include_role:
    name: nginx

- name: Incluir estaticamente
  import_role:
    name: nginx
```

**Diferança:**

- `import_role` é resolvido durante o parse (estático).
- `include_role` é resolvido em tempo de execução (dinâmico).

---

## Boas Práticas ao Criar Roles

- Crie roles reutilizáveis e independentes.
- Use `defaults/` para valores que podem ser sobrescritos.
- Coloque senhas e segredos no Vault.
- Escreva documentação no `README.md` da role.
- Nomeie suas roles com nomes claros (sem acentos, sem espaços).
- Evite hardcoded: use variáveis em `template`, `copy`, `tasks`.
- Use `ansible-lint` para validar sua role.

---

## Checklist de Aproveitamento do Capítulo

```yaml
✅ Checklist do Aluno
- [ ] Criei uma role com `ansible-galaxy init`
- [ ] Organizei tarefas, handlers, templates e arquivos
- [ ] Usei variáveis com `defaults` e sobrescrevi no playbook
- [ ] Declarei dependências em `meta/main.yml`
- [ ] Executei a role com `ansible-playbook`
- [ ] Testei `import_role` e `include_role`
```

---

## Desafio Final

Crie duas roles:

1. `firewall`: que abra portas usando `ufw` (Ubuntu) ou `firewalld` (RHEL).
2. `apache`: que instale e configure o Apache, com página inicial via `template`, e use `notify` para reiniciar o serviço.

Em `site.yml`, use ambas com dependência entre elas. Execute e teste tudo com:

```bash
ansible-playbook -i inventory.yml site.yml
```

