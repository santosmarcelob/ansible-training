# Capítulo 7: Playbooks Ansible - Orquestrando a Automação

## O Formato Essencial de um Playbook

Playbooks são o coração da automação com Ansible. Eles são arquivos YAML que descrevem as tarefas que o Ansible deve executar em seus hosts gerenciados. Um playbook é uma lista de um ou mais "plays", e cada play é uma lista de tarefas a serem executadas em um conjunto específico de hosts.

### Estrutura Básica de um Playbook

Um playbook Ansible começa com três hífens (`---`), indicando o início de um documento YAML. Cada play é um item de lista, e suas propriedades são definidas por pares chave-valor.

```yaml
---
- name: Nome descritivo do Play (ex: Configurar Servidores Web)
  hosts: grupo_de_hosts_ou_host_individual # Onde este play sera executado
  become: true # Opcional: eleva privilegios (sudo/root)
  gather_facts: true # Opcional: coleta fatos sobre os hosts (padrao: true)
  vars:
    # Variaveis especificas para este play
    minha_variavel: valor

  tasks:
    # Lista de tarefas a serem executadas neste play
    - name: Nome descritivo da Tarefa 1
      modulo_ansible:
        parametro1: valor1
        parametro2: valor2

    - name: Nome descritivo da Tarefa 2
      outro_modulo:
        parametro_a: valor_a
```

**Componentes Chave:**

*   **`---`**: Indica o início de um documento YAML.
*   **`- name:`**: Um nome descritivo para o play ou para a tarefa. É altamente recomendado para clareza e para facilitar a depuração, pois este nome aparece na saída da execução do playbook.
*   **`hosts:`**: Define em quais hosts (ou grupos de hosts) este play será executado. Pode ser `all`, um nome de grupo (ex: `webservers`), um nome de host (ex: `server1.example.com`), ou uma combinação (ex: `webservers:!dev`).
*   **`become:`**: (Opcional) Define se o Ansible deve elevar privilégios (equivalente a `sudo` ou `runas`) para executar as tarefas neste play. O valor padrão é `false`.
*   **`gather_facts:`**: (Opcional) Controla se o Ansible deve coletar fatos sobre os hosts antes de executar as tarefas. O padrão é `true`. Pode ser desabilitado para otimização se os fatos não forem necessários.
*   **`vars:`**: (Opcional) Uma seção para definir variáveis que são específicas para este play. Essas variáveis têm precedência sobre variáveis de inventário e `group_vars`/`host_vars`.
*   **`tasks:`**: Uma lista de tarefas a serem executadas neste play. Cada tarefa é um item de lista e consiste em um nome (`name:`) e a chamada de um módulo Ansible.
*   **`modulo_ansible:`**: O nome do módulo Ansible a ser executado (ex: `ansible.builtin.package`, `ansible.builtin.service`).
*   **`parametro:`**: Parâmetros específicos para o módulo, que controlam seu comportamento (ex: `name: nginx`, `state: present`).

### Exemplo de Playbook Básico

Este playbook simples instala o Nginx e garante que o serviço esteja rodando em todos os servidores web definidos no inventário.

```yaml
---
- name: Configurar Servidor Web Nginx
  hosts: webservers
  become: true
  tasks:
    - name: Instalar pacote Nginx
      ansible.builtin.package:
        name: nginx
        state: present
        update_cache: yes

    - name: Garantir que o servico Nginx esteja rodando e habilitado
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

Este formato básico é a espinha dorsal de todos os playbooks Ansible, e a partir dele, podemos construir automações mais complexas e sofisticadas.



## Múltiplos Plays no Mesmo Playbook

Um único arquivo de playbook pode conter múltiplos plays. Isso é útil quando você precisa executar diferentes conjuntos de tarefas em diferentes grupos de hosts, ou quando há uma sequência lógica de operações que envolvem diferentes alvos ou privilégios.

Cada play é executado em ordem, de cima para baixo. O Ansible completará todas as tarefas do primeiro play antes de passar para o segundo play, e assim por diante.

### Exemplo de Playbook com Múltiplos Plays

Considere um cenário onde você precisa:
1.  Configurar servidores web (instalar Nginx, copiar arquivos).
2.  Configurar servidores de banco de dados (instalar PostgreSQL, criar usuário).

Você pode fazer isso em um único playbook com dois plays:

```yaml
---
- name: Play 1 - Configurar Servidores Web
  hosts: webservers
  become: true
  tasks:
    - name: Instalar Nginx
      ansible.builtin.package:
        name: nginx
        state: present
        update_cache: yes

    - name: Copiar pagina inicial
      ansible.builtin.copy:
        content: "<h1>Bem-vindo ao Servidor Web!</h1>"
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'

    - name: Garantir que Nginx esteja rodando
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

- name: Play 2 - Configurar Servidores de Banco de Dados
  hosts: databases
  become: true
  tasks:
    - name: Instalar PostgreSQL
      ansible.builtin.package:
        name: postgresql
        state: present
        update_cache: yes

    - name: Garantir que PostgreSQL esteja rodando
      ansible.builtin.service:
        name: postgresql
        state: started
        enabled: true

    - name: Criar usuario de banco de dados (exemplo simplificado)
      ansible.builtin.command: createuser -s -U postgres myappuser
      args:
        creates: /var/lib/postgresql/data/pg_hba.conf # Exemplo de idempotencia
      # Nota: Em um cenario real, voce usaria o modulo community.postgresql.postgresql_user
```

**Observações:**
*   Cada play tem seu próprio `name`, `hosts`, `become` e lista de `tasks`.
*   O Ansible executará todas as tarefas do "Play 1" nos `webservers` e, somente após a conclusão bem-sucedida, passará para o "Play 2" e executará suas tarefas nos `databases`.

Usar múltiplos plays no mesmo playbook é uma forma eficaz de agrupar automações relacionadas que operam em diferentes partes da sua infraestrutura ou que exigem diferentes contextos de execução (como diferentes usuários ou privilégios).



## O Parâmetro `hosts`: Definindo o Alvo da Automação

O parâmetro `hosts` em um play é fundamental, pois ele define em quais hosts ou grupos de hosts as tarefas daquele play serão executadas. A flexibilidade do `hosts` permite direcionar suas automações de forma muito granular.

### Formas de Usar `hosts`

1.  **Todos os Hosts:**
    ```yaml
    hosts: all
    ```
    Executa o play em todos os hosts definidos no inventário.

2.  **Um Grupo Específico:**
    ```yaml
    hosts: webservers
    ```
    Executa o play em todos os hosts que são membros do grupo `webservers`.

3.  **Múltiplos Grupos:**
    ```yaml
    hosts: webservers:databases
    ```
    Executa o play em hosts que são membros do grupo `webservers` OU do grupo `databases`.

4.  **Interseção de Grupos (AND):**
    ```yaml
    hosts: webservers:&production
    ```
    Executa o play apenas em hosts que são membros do grupo `webservers` E do grupo `production`.

5.  **Exclusão de Grupos (NOT):**
    ```yaml
    hosts: all:!databases
    ```
    Executa o play em todos os hosts, EXCETO aqueles que são membros do grupo `databases`.

6.  **Um Host Específico:**
    ```yaml
    hosts: server1.example.com
    ```
    Executa o play apenas no host `server1.example.com`.

7.  **Variáveis:**
    Você pode usar variáveis para definir o valor de `hosts`, o que é útil para tornar playbooks mais dinâmicos.
    ```yaml
    - name: Configurar ambiente dinamico
      hosts: "{{ target_hosts }}"
      vars:
        target_hosts: dev_servers
      tasks:
        - name: Exibir nome do host
          ansible.builtin.debug:
            msg: "Configurando {{ inventory_hostname }} no ambiente {{ target_hosts }}"
    ```

### Boas Práticas para `hosts`

*   **Seja Específico:** Sempre que possível, direcione seus plays para o menor conjunto de hosts necessário. Isso reduz o risco de alterações indesejadas e acelera a execução.
*   **Use Grupos:** Evite listar hosts individuais diretamente no `hosts` de um playbook, a menos que seja para uma tarefa muito específica e pontual. Prefira usar grupos para manter a flexibilidade e a manutenibilidade.
*   **Considere a Precedência:** Lembre-se que o parâmetro `--limit` na linha de comando sempre terá precedência sobre o `hosts` definido no playbook, permitindo que você restrinja ainda mais o alvo da execução.

O uso eficaz do parâmetro `hosts` é crucial para garantir que suas automações Ansible sejam executadas nos alvos corretos, com precisão e segurança.



## Check Mode e Diff Mode: Testando sem Efetivar Mudanças

Uma das grandes vantagens do Ansible é a capacidade de testar seus playbooks antes de aplicá-los de fato à sua infraestrutura. Isso é feito através do **Check Mode** (também conhecido como "dry run") e do **Diff Mode**, que permitem visualizar as alterações que seriam feitas sem realmente executá-las ou ver as diferenças exatas nos arquivos.

### Check Mode (`--check`)

O Check Mode permite que você execute um playbook e veja quais alterações *seriam* feitas nos hosts gerenciados, sem realmente efetivá-las. A maioria dos módulos Ansible é compatível com o Check Mode, o que significa que eles reportarão `changed` se uma alteração fosse necessária, mas não a aplicarão.

**Como Usar:**
Adicione a opção `--check` (ou `-C`) ao comando `ansible-playbook`:

```bash
ansible-playbook meu_playbook.yml --check
```

**Exemplo:**
Considere um playbook que instala um pacote e copia um arquivo:

**`install_and_copy.yml`:**
```yaml
---
- name: Instalar Pacote e Copiar Arquivo
  hosts: webservers
  become: true
  tasks:
    - name: Instalar Nginx
      ansible.builtin.package:
        name: nginx
        state: present

    - name: Copiar arquivo de configuracao
      ansible.builtin.copy:
        src: files/nginx.conf
        dest: /etc/nginx/nginx.conf
```

Se você executar com `--check`:

```bash
ansible-playbook -i inventario.ini install_and_copy.yml --check
```

**Saída Esperada (se Nginx não estiver instalado e o arquivo for diferente):**
```
PLAY [Instalar Pacote e Copiar Arquivo] ****************************************

TASK [Gathering Facts] *********************************************************
ok: [webserver01.example.com]

TASK [Instalar Nginx] **********************************************************
changed: [webserver01.example.com] # would have changed

TASK [Copiar arquivo de configuracao] ******************************************
changed: [webserver01.example.com] # would have changed

PLAY RECAP *********************************************************************
webserver01.example.com : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Observe o `changed: [webserver01.example.com] # would have changed`. Isso indica que o Ansible *teria* feito uma alteração, mas não a fez devido ao Check Mode.

### Diff Mode (`--diff`)

O Diff Mode, geralmente usado em conjunto com o Check Mode, mostra as diferenças exatas que seriam aplicadas aos arquivos de texto (como arquivos de configuração) nos hosts gerenciados. Isso é incrivelmente útil para revisar alterações antes de confirmá-las.

**Como Usar:**
Adicione a opção `--diff` (ou `-D`) ao comando `ansible-playbook`. É comum usá-lo com `--check`:

```bash
ansible-playbook meu_playbook.yml --check --diff
```

**Exemplo:**
Se o playbook `install_and_copy.yml` fosse executado com `--check --diff` e o arquivo `files/nginx.conf` fosse diferente do `/etc/nginx/nginx.conf` existente no servidor, a saída incluiria:

```
--- /etc/nginx/nginx.conf	(file before changes)
+++ /etc/nginx/nginx.conf	(file after changes)
@@ -1,5 +1,5 @@
 # Este e o arquivo de configuracao do Nginx
-user www-data;
+user nginx;
 worker_processes auto;
 error_log /var/log/nginx/error.log;
 pid /run/nginx.pid;
```

**Observações:**
*   O Diff Mode funciona melhor com módulos que manipulam arquivos de texto (como `copy`, `template`, `lineinfile`, `blockinfile`).
*   Nem todos os módulos suportam o Diff Mode, mas a maioria dos módulos de gerenciamento de configuração o faz.

O Check Mode e o Diff Mode são ferramentas indispensáveis para garantir a segurança e a previsibilidade das suas automações Ansible, permitindo que você valide suas mudanças antes de impactar os sistemas em produção.



## Verificação de Sintaxe e `ansible-lint`: Garantindo a Qualidade do Código

Antes de executar seus playbooks em ambientes de produção, é crucial garantir que eles estejam sintaticamente corretos e sigam as melhores práticas. O Ansible oferece ferramentas para isso: a verificação de sintaxe embutida e a ferramenta `ansible-lint`.

### Verificação de Sintaxe (`ansible-playbook --syntax-check`)

O comando `ansible-playbook` possui uma opção `--syntax-check` (ou `-C` se não for usado com `--check` para dry run) que verifica se o seu playbook está sintaticamente correto em YAML e se a estrutura do Ansible é válida. Ele não executa nenhuma tarefa nos hosts, apenas analisa o arquivo.

**Como Usar:**
```bash
ansible-playbook meu_playbook.yml --syntax-check
```

**Exemplo:**
Se você tiver um erro de indentação ou um erro de sintaxe YAML, o `--syntax-check` irá identificá-lo:

**`bad_syntax.yml`:**
```yaml
---
- name: Play com erro de sintaxe
  hosts: all
  tasks:
    - name: Tarefa com indentacao errada
    ansible.builtin.debug:
        msg: "Isso vai falhar"
```

**Execução:**
```bash
ansible-playbook bad_syntax.yml --syntax-check
```

**Saída (exemplo de erro):**
```
ERROR! We were unable to read either as JSON nor YAML, these are the errors we got from each:
JSON: No JSON object could be decoded

Syntax Error while loading YAML. (bad_syntax.yml)

The error appears to be in 'bad_syntax.yml': line 6, column 5, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

    - name: Tarefa com indentacao errada
    ansible.builtin.debug:
    ^
```

Se o playbook estiver sintaticamente correto, a saída será simples e indicará sucesso:

```bash
ansible-playbook good_syntax.yml --syntax-check

playbook: good_syntax.yml
```

### `ansible-lint`: Garantindo Boas Práticas e Estilo

Enquanto `--syntax-check` verifica a validade do YAML e da estrutura básica do Ansible, o `ansible-lint` vai além, verificando se seus playbooks seguem as melhores práticas, padrões de estilo e identificando possíveis problemas de segurança ou eficiência. É uma ferramenta de linter para código Ansible.

**Instalação:**
```bash
pip install ansible-lint
```

**Como Usar:**
Simplesmente execute `ansible-lint` no diretório do seu playbook ou especifique o arquivo:

```bash
ansible-lint meu_playbook.yml
```

**Exemplo de Regras Verificadas pelo `ansible-lint`:**
*   **`no-free-form`:** Evita o uso de comandos free-form em módulos como `command` ou `shell`.
*   **`no-tabs`:** Garante que você não esteja usando tabs para indentação (apenas espaços).
*   **`no-changed-when`:** Sugere o uso de `changed_when` para módulos `command` ou `shell`.
*   **`var-naming`:** Verifica padrões de nomes de variáveis.
*   **`yaml`:** Valida a sintaxe YAML.

**Exemplo de Saída do `ansible-lint`:**
```bash
ansible-lint my_bad_playbook.yml

WARNING: Listing 1 violation(s) that are not errors (i.e., they can be ignored):

my_bad_playbook.yml:6: no-free-form: Don't use command module with a free-form command. Use 'cmd' parameter instead. (command-instead-of-shell)

Read more about this rule at: https://ansible-lint.readthedocs.io/rules/command_instead_of_shell/

Finished with 0 failures, 1 warning(s) on 1 files.
```

**Benefícios do `ansible-lint`:**
*   **Qualidade do Código:** Ajuda a manter um código limpo, consistente e fácil de ler.
*   **Identificação de Problemas:** Detecta problemas potenciais antes que eles causem falhas em tempo de execução.
*   **Segurança:** Pode identificar padrões que podem levar a vulnerabilidades de segurança.
*   **Colaboração:** Garante que todos na equipe sigam as mesmas convenções de codificação.

Integrar `--syntax-check` e `ansible-lint` em seu fluxo de trabalho de desenvolvimento de playbooks é uma prática recomendada para garantir a robustez e a qualidade de suas automações Ansible.



## Condicionais (`when`): Tomando Decisões em Playbooks

Um dos pilares da lógica de programação é a capacidade de tomar decisões e executar diferentes blocos de código com base em certas condições. No Ansible, isso é feito principalmente através da palavra-chave `when`.

O `when` permite que você defina uma condição para uma tarefa. Se a condição for verdadeira, a tarefa será executada; caso contrário, ela será ignorada. Isso torna seus playbooks mais inteligentes e adaptáveis a diferentes cenários e estados de hosts.

### Sintaxe Básica de `when`

A condição `when` é uma expressão Jinja2 que é avaliada em tempo de execução no host gerenciado. Se a expressão resultar em `True`, a tarefa é executada. Se resultar em `False`, a tarefa é pulada.

```yaml
- name: Instalar pacote apenas no Ubuntu
  ansible.builtin.package:
    name: htop
    state: present
  when: ansible_facts.distribution == "Ubuntu"
```

Neste exemplo, a tarefa de instalar `htop` só será executada se o fato `ansible_facts.distribution` do host for igual a "Ubuntu".

### Usando Fatos (Facts) em Condicionais

Os fatos coletados pelo Ansible (discutidos no Capítulo 6) são frequentemente usados em condições `when`, pois fornecem informações dinâmicas sobre o sistema.

```yaml
- name: Reiniciar servico Nginx se a porta 80 estiver em uso
  ansible.builtin.service:
    name: nginx
    state: restarted
  when: ansible_facts.tcp_ports.80 is defined and ansible_facts.tcp_ports.80 | length > 0

- name: Criar diretorio apenas se nao existir
  ansible.builtin.file:
    path: /opt/minha_app
    state: directory
  when: not ansible_facts.exists("/opt/minha_app") # Exemplo conceitual, use o modulo file com state: directory para idempotencia
```

### Múltiplas Condições

Você pode combinar múltiplas condições usando operadores lógicos `and` (e) e `or` (ou).

```yaml
- name: Instalar pacote apenas em servidores web de producao
  ansible.builtin.package:
    name: apache2
    state: present
  when:
    - "webservers" in group_names
    - ambiente == "producao"

- name: Reiniciar servico se for Ubuntu OU Debian
  ansible.builtin.service:
    name: myapp
    state: restarted
  when: ansible_facts.distribution == "Ubuntu" or ansible_facts.distribution == "Debian"
```

**Observações:**
*   Para múltiplas condições `and`, você pode listá-las em linhas separadas (como no primeiro exemplo acima), e o Ansible as tratará como `and` implícito.
*   Para condições `or`, você deve usar explicitamente o operador `or`.
*   É possível usar parênteses para agrupar condições complexas: `when: (condicao1 and condicao2) or condicao3`.

### Condicionais com Variáveis

Variáveis definidas em qualquer fonte (inventário, `group_vars`, `host_vars`, `vars` do playbook, etc.) também podem ser usadas em condições `when`.

```yaml
- name: Habilitar SSL se a variavel for true
  ansible.builtin.template:
    src: ssl_config.j2
    dest: /etc/nginx/conf.d/ssl.conf
  when: enable_ssl is defined and enable_ssl | bool

- name: Executar tarefa apenas se o ambiente for desenvolvimento
  ansible.builtin.debug:
    msg: "Executando tarefa especifica para desenvolvimento."
  when: ambiente == "desenvolvimento"
```

### `when` e `changed_when` / `failed_when`

Além do `when` para controlar a execução de tarefas, o Ansible oferece `changed_when` e `failed_when` para controlar o estado de `changed` ou `failed` de uma tarefa, respectivamente. Isso é particularmente útil para módulos `command` ou `shell` que não são inerentemente idempotentes.

*   **`changed_when`:** Define uma condição para que uma tarefa seja marcada como `changed`. Se a condição for verdadeira, a tarefa é `changed`; caso contrário, é `ok`. O padrão é que a tarefa seja `changed` se o comando retornar um código de saída diferente de zero ou se a saída padrão ou de erro não estiver vazia.
    ```yaml
    - name: Executar script e marcar como changed apenas se a saida contiver "UPDATE"
      ansible.builtin.shell: /opt/meu_script.sh
      register: script_output
      changed_when: "UPDATE" in script_output.stdout
    ```

*   **`failed_when`:** Define uma condição para que uma tarefa seja marcada como `failed`. Se a condição for verdadeira, a tarefa falha. Isso é útil para tratar saídas de erro específicas como falhas, mesmo que o comando retorne um código de saída zero.
    ```yaml
    - name: Verificar status do servico e falhar se nao estiver rodando
      ansible.builtin.command: systemctl is-active myapp
      register: service_status
      failed_when: "inactive" in service_status.stdout
    ```

O uso inteligente de condicionais permite que você crie playbooks altamente flexíveis e robustos, capazes de se adaptar a uma variedade de situações e estados de sistema.



## Loops: Automatizando Tarefas Repetitivas

Em automação, é muito comum precisar executar a mesma tarefa várias vezes, mas com diferentes conjuntos de dados. Por exemplo, instalar uma lista de pacotes, criar múltiplos usuários, ou configurar vários arquivos. No Ansible, isso é feito usando **loops**.

O Ansible oferece várias maneiras de implementar loops, sendo a mais moderna e recomendada a palavra-chave `loop`. Historicamente, `with_items`, `with_file`, `with_dict`, entre outros, eram usados, e embora ainda funcionem, `loop` é a forma unificada e preferencial.

### O Básico do `loop`

O `loop` itera sobre uma lista de itens. Para cada item na lista, a tarefa é executada, e o item atual está disponível através da variável mágica `item`.

```yaml
- name: Instalar uma lista de pacotes
  ansible.builtin.package:
    name: "{{ item }}"
    state: present
  loop:
    - git
    - vim
    - htop
    - curl
```

Neste exemplo, o módulo `ansible.builtin.package` será executado quatro vezes, uma para cada pacote na lista.

### Iterando sobre Listas de Dicionários

É muito comum iterar sobre listas onde cada item é um dicionário, permitindo que você passe múltiplos parâmetros para cada iteração.

```yaml
- name: Criar usuarios com propriedades especificas
  ansible.builtin.user:
    name: "{{ item.name }}"
    state: present
    shell: "{{ item.shell | default("/bin/bash") }}"
    groups: "{{ item.groups | default([]) | join(",") }}"
  loop:
    - { name: alice, shell: /bin/zsh, groups: ["sudo", "users"] }
    - { name: bob, groups: ["users"] }
    - { name: charlie, shell: /bin/sh }
```

Neste caso, `item.name`, `item.shell` e `item.groups` são usados para acessar as chaves de cada dicionário. O filtro `default` é usado para fornecer valores padrão caso uma chave não esteja presente no dicionário.

### Loops com `lookup` (Antigo `with_*`)

O `loop` pode ser combinado com plugins de `lookup` para replicar a funcionalidade dos antigos `with_*`.

*   **`lookup('file', ...)` (equivalente a `with_file`):** Lê o conteúdo de um arquivo linha por linha e itera sobre cada linha.

    ```yaml
    - name: Criar arquivos com conteudo de uma lista
      ansible.builtin.copy:
        content: "{{ item }}"
        dest: "/tmp/file_{{ loop.index }}.txt"
      loop: "{{ lookup("file", "/path/to/my_list_of_lines.txt").splitlines() }}"
    ```
    Onde `/path/to/my_list_of_lines.txt` contém:
    ```
    Primeira linha de conteudo
    Segunda linha de conteudo
    Terceira linha de conteudo
    ```

*   **`lookup('dict', ...)` (equivalente a `with_dict`):** Itera sobre os pares chave-valor de um dicionário.

    ```yaml
    - name: Configurar servicos com portas especificas
      ansible.builtin.service:
        name: "{{ item.key }}"
        state: started
        enabled: true
      loop: "{{ lookup("dict", {"nginx": 80, "apache": 443}) }}"
      # Dentro do loop, item.key sera o nome do servico e item.value sera a porta
    ```

*   **`lookup('sequence', ...)` (equivalente a `with_sequence`):** Gera uma sequência de números.

    ```yaml
    - name: Criar 5 diretorios numerados
      ansible.builtin.file:
        path: "/opt/dir_{{ item }}"
        state: directory
      loop: "{{ lookup("sequence", start=1, end=5) }}"
    ```

### Loops Aninhados (`loop_control`)

Para loops aninhados (um loop dentro de outro), você pode usar `loop_control` para renomear a variável `item` do loop interno, evitando conflitos.

```yaml
- name: Criar arquivos em multiplos ambientes
  ansible.builtin.file:
    path: "/var/www/{{ env_item }}/{{ file_item }}.conf"
    state: touch
  loop: "{{ ["dev", "prod"] }}"
  loop_control:
    loop_var: env_item
  vars:
    files_to_create: ["app", "db"]
  tasks:
    - name: Criar arquivos para cada ambiente
      ansible.builtin.file:
        path: "/var/www/{{ env_item }}/{{ file_item }}.conf"
        state: touch
      loop: "{{ files_to_create }}"
      loop_control:
        loop_var: file_item
```

**Observações:**
*   A variável `loop_var` é usada para definir um nome personalizado para a variável de loop para evitar que o `item` do loop interno sobrescreva o `item` do loop externo.
*   O uso de loops é fundamental para a automação em escala, permitindo que você aplique configurações ou execute tarefas em múltiplos itens de forma concisa e eficiente.



## `register`: Capturando e Reutilizando Saídas de Tarefas

Em muitos cenários de automação, você precisará que uma tarefa execute uma ação e, em seguida, que a próxima tarefa utilize a saída ou o resultado dessa ação. O Ansible fornece a palavra-chave `register` para esse propósito. Com `register`, você pode capturar a saída de qualquer tarefa em uma variável, que pode então ser usada em tarefas subsequentes, condicionais, loops ou para depuração.

### Como Usar `register`

Basta adicionar `register: nome_da_variavel` a qualquer tarefa. A saída completa da tarefa (incluindo `stdout`, `stderr`, `rc` (return code), `changed`, `failed`, etc.) será armazenada nessa variável.

```yaml
- name: Obter informacoes do sistema com o comando uname
  ansible.builtin.command: uname -a
  register: uname_output

- name: Exibir a saida padrao do comando uname
  ansible.builtin.debug:
    msg: "Saida do uname: {{ uname_output.stdout }}"

- name: Exibir o codigo de retorno do comando uname
  ansible.builtin.debug:
    msg: "Codigo de retorno: {{ uname_output.rc }}"

- name: Exibir se a tarefa mudou algo
  ansible.builtin.debug:
    msg: "A tarefa mudou algo: {{ uname_output.changed }}"
```

**Propriedades Comuns da Variável Registrada:**
*   `stdout`: A saída padrão do comando (string).
*   `stderr`: A saída de erro padrão do comando (string).
*   `rc`: O código de retorno do comando (inteiro). `0` geralmente indica sucesso.
*   `stdout_lines`: A saída padrão como uma lista de linhas.
*   `stderr_lines`: A saída de erro padrão como uma lista de linhas.
*   `changed`: Um booleano indicando se a tarefa resultou em uma alteração no sistema remoto.
*   `failed`: Um booleano indicando se a tarefa falhou.
*   `skipped`: Um booleano indicando se a tarefa foi pulada.

### Usando Saídas Registradas em Condicionais

É muito comum usar o resultado de uma tarefa registrada para controlar a execução de tarefas subsequentes.

```yaml
- name: Verificar se o servico Nginx esta ativo
  ansible.builtin.command: systemctl is-active nginx
  register: nginx_status
  ignore_errors: true # Ignora erro se o servico nao estiver ativo

- name: Reiniciar Nginx se nao estiver ativo
  ansible.builtin.service:
    name: nginx
    state: restarted
  when: nginx_status.rc != 0 or "inactive" in nginx_status.stdout
```

Neste exemplo, a tarefa de reiniciar o Nginx só será executada se o comando `systemctl is-active nginx` retornar um código de erro diferente de zero ou se a saída contiver a palavra "inactive".

### Usando Saídas Registradas em Loops

Você pode iterar sobre partes da saída de uma tarefa registrada, especialmente quando a saída é uma lista ou uma estrutura de dados complexa.

```yaml
- name: Listar arquivos em /etc
  ansible.builtin.command: ls -1 /etc
  register: etc_files

- name: Exibir cada arquivo em /etc
  ansible.builtin.debug:
    msg: "Arquivo: {{ item }}"
  loop: "{{ etc_files.stdout_lines }}"
```

### `with_*` e `register`

Embora `loop` seja a forma preferencial para loops, os antigos `with_*` (como `with_items`, `with_file`, etc.) ainda são amplamente utilizados e funcionam bem com `register`. A lógica é a mesma: a saída de cada iteração do loop é registrada na variável, e você pode acessá-la.

```yaml
- name: Executar comando para cada item e registrar saida
  ansible.builtin.command: echo "Processando {{ item }}"
  register: process_output
  loop:
    - item1
    - item2
    - item3

- name: Exibir saida de cada processamento
  ansible.builtin.debug:
    msg: "Saida para {{ item.item }}: {{ item.stdout }}"
  loop: "{{ process_output.results }}"
```

Quando você registra a saída de uma tarefa que está dentro de um loop, a variável registrada (`process_output` neste caso) conterá uma lista de dicionários, onde cada dicionário representa o resultado de uma iteração do loop. A chave `item.item` dentro do loop subsequente refere-se ao item original que foi processado naquela iteração.

O `register` é uma ferramenta poderosa para criar playbooks dinâmicos e adaptáveis, permitindo que você reaja a informações coletadas em tempo real durante a execução da automação.

