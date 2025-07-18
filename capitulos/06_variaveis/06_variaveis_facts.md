# Capítulo 6: Variáveis e Fatos (Facts)

## Variáveis no Ansible: O Coração da Flexibilidade

No Ansible, **variáveis** são um dos conceitos mais poderosos e fundamentais para criar automações flexíveis, reutilizáveis e dinâmicas. Elas permitem que você armazene e reutilize valores em seus playbooks, inventários e roles, adaptando o comportamento da automação a diferentes ambientes, hosts ou situações sem a necessidade de reescrever o código.

### O que são Variáveis e Por que são Importantes?

Pense em variáveis como contêineres para dados. Em vez de codificar um valor diretamente em seu playbook (por exemplo, o nome de um pacote, um caminho de arquivo ou uma porta de serviço), você usa uma variável. Isso traz várias vantagens:

1.  **Reutilização:** Um único playbook pode ser usado para configurar múltiplos servidores com pequenas variações (por exemplo, diferentes versões de software, diferentes portas de escuta).
2.  **Flexibilidade:** Altere o comportamento de um playbook simplesmente modificando o valor de uma variável, sem tocar na lógica do playbook.
3.  **Legibilidade:** Playbooks se tornam mais limpos e fáceis de entender, pois os valores específicos são abstraídos em variáveis com nomes significativos.
4.  **Manutenibilidade:** Atualizações e ajustes são centralizados. Se um valor precisa ser alterado em vários lugares, você o altera apenas uma vez na definição da variável.
5.  **Adaptação a Ambientes:** Permite que o mesmo playbook seja usado em ambientes de desenvolvimento, staging e produção, cada um com suas próprias configurações específicas definidas via variáveis.

### Sintaxe de Variáveis

No Ansible, as variáveis são referenciadas usando a sintaxe Jinja2, que é `{{ nome_da_variavel }}`. Quando o Ansible executa um playbook, ele substitui essa referência pelo valor real da variável.

**Exemplo:**
```yaml
- name: Instalar pacote definido por variavel
  ansible.builtin.package:
    name: "{{ nome_do_pacote }}"
    state: present
```
Neste exemplo, `nome_do_pacote` é uma variável cujo valor será determinado em tempo de execução.

### Tipos de Variáveis

As variáveis no Ansible podem armazenar diferentes tipos de dados, assim como em linguagens de programação:

1.  **Strings (Cadeias de Caracteres):** Texto simples.
    ```yaml
    servidor_web: nginx
    caminho_log: /var/log/minha_app.log
    ```

2.  **Numbers (Números Inteiros ou Decimais):**
    ```yaml
    porta_http: 80
    max_conexoes: 1000
    ```

3.  **Booleans (Booleanos):** Valores `true` ou `false` (ou `yes`/`no`, `on`/`off`).
    ```yaml
    habilitar_ssl: true
    debug_mode: false
    ```

4.  **Lists (Listas/Arrays):** Uma coleção ordenada de itens.
    ```yaml
    pacotes_comuns:
      - git
      - vim
      - htop
    ```
    Ou em linha:
    ```yaml
    pacotes_comuns: ["git", "vim", "htop"]
    ```

5.  **Dictionaries (Dicionários/Mapas/Objetos):** Uma coleção de pares chave-valor.
    ```yaml
    config_db:
      host: localhost
      port: 5432
      user: admin
      password: "{{ vault_db_password }}"
    ```
    Para acessar valores em dicionários, use a notação de ponto ou colchetes:
    `{{ config_db.host }}` ou `{{ config_db['user'] }}`.

6.  **Variáveis Aninhadas:** Você pode combinar tipos de dados para criar estruturas complexas.
    ```yaml
    aplicacoes:
      - name: webapp
        port: 8080
        path: /var/www/webapp
      - name: api
        port: 5000
        path: /opt/api
    ```
    Para acessar o nome da primeira aplicação:
    `{{ aplicacoes[0].name }}`

Compreender esses tipos de variáveis é crucial para modelar suas configurações de forma eficaz e aproveitar ao máximo a flexibilidade do Ansible.



## Fontes de Variáveis: Onde o Ansible Encontra Seus Dados

O Ansible é incrivelmente flexível na forma como você pode definir e carregar variáveis. Elas podem vir de diversos lugares, e entender essas fontes é fundamental para gerenciar suas configurações de forma eficaz. As principais fontes de variáveis incluem:

### 1. Inventário

O inventário é o local mais comum para definir variáveis que são específicas para hosts ou grupos de hosts. Conforme vimos no Capítulo 4, você pode definir variáveis diretamente no arquivo de inventário (INI ou YAML).

**Exemplo (INI):**
```ini
[webservers]
web1.example.com http_port=80
web2.example.com http_port=443

[databases:vars]
db_user=admin
db_password=supersecret
```

**Exemplo (YAML):**
```yaml
all:
  children:
    webservers:
      hosts:
        web1.example.com:
          http_port: 80
        web2.example.com:
          http_port: 443
      vars:
        web_server_type: nginx
    databases:
      hosts:
        db1.example.com:
      vars:
        db_user: admin
        db_password: supersecret
```

### 2. `group_vars/` e `host_vars/`

Para uma organização mais limpa e escalável, especialmente em projetos maiores, o Ansible permite que você defina variáveis em arquivos separados dentro dos diretórios `group_vars/` e `host_vars/`. Esses diretórios devem estar no mesmo nível do seu arquivo de inventário ou do seu `ansible.cfg`.

*   **`group_vars/<nome_do_grupo>.yml` (ou `.json`):** Variáveis definidas aqui se aplicam a todos os hosts que são membros do `<nome_do_grupo>`.
*   **`host_vars/<nome_do_host>.yml` (ou `.json`):** Variáveis definidas aqui se aplicam apenas ao `<nome_do_host>` específico.

**Exemplo de Estrutura de Diretórios:**
```
meu_projeto_ansible/
├── inventory.yml
├── group_vars/
│   ├── webservers.yml
│   └── databases.yml
├── host_vars/
│   ├── web1.example.com.yml
│   └── db1.example.com.yml
└── playbooks/
    └── site.yml
```

**Conteúdo de `group_vars/webservers.yml`:**
```yaml
max_connections: 1000
log_level: info
```

**Conteúdo de `host_vars/web1.example.com.yml`:**
```yaml
custom_message: "Bem-vindo ao Webserver 1!"
```

### 3. Variáveis de Playbook (`vars`)

Você pode definir variáveis diretamente dentro de um playbook, na seção `vars:`. Essas variáveis são válidas apenas para o playbook em que são definidas.

```yaml
---
- name: Exemplo de Variaveis de Playbook
  hosts: all
  vars:
    app_name: MinhaAplicacao
    app_version: 1.0.0
  tasks:
    - name: Exibir nome e versao da aplicacao
      ansible.builtin.debug:
        msg: "Aplicacao: {{ app_name }}, Versao: {{ app_version }}"
```

### 4. Variáveis de Role (`defaults/main.yml`, `vars/main.yml`)

Quando você organiza seu código em roles (que veremos em um capítulo futuro), as variáveis podem ser definidas dentro da estrutura da role:

*   **`roles/<nome_da_role>/defaults/main.yml`:** Contém valores padrão para variáveis. Essas variáveis têm a menor precedência e podem ser facilmente sobrescritas por outras fontes.
*   **`roles/<nome_da_role>/vars/main.yml`:** Contém variáveis que são específicas para a role e que não devem ser facilmente sobrescritas. Têm uma precedência maior que as variáveis `defaults`.

### 5. Variáveis de Linha de Comando (`-e` ou `--extra-vars`)

Você pode passar variáveis diretamente na linha de comando usando a opção `-e` ou `--extra-vars`. Essas variáveis têm a **maior precedência** e sobrescrevem qualquer outra definição de variável.

```bash
ansible-playbook my_playbook.yml -e "ambiente=producao db_port=5432"
```
Ou para passar um arquivo YAML de variáveis:
```bash
ansible-playbook my_playbook.yml -e @prod_vars.yml
```

### 6. Variáveis Registradas (`register`)

A saída de uma tarefa pode ser capturada em uma variável usando a palavra-chave `register`. Essa variável pode então ser usada em tarefas subsequentes dentro do mesmo play.

```yaml
- name: Obter saida do comando uptime
  ansible.builtin.command: uptime
  register: uptime_output

- name: Exibir saida do uptime
  ansible.builtin.debug:
    msg: "{{ uptime_output.stdout }}"
```

### 7. Variáveis de Fatos (Facts)

O Ansible coleta automaticamente informações sobre os hosts gerenciados (chamados de "fatos"). Esses fatos são variáveis que podem ser usadas em seus playbooks. Veremos mais sobre fatos na próxima seção.

### 8. Variáveis Mágicas

O Ansible fornece algumas variáveis "mágicas" que são predefinidas e contêm informações úteis sobre a execução do playbook ou sobre o ambiente. Exemplos incluem `hostvars`, `group_names`, `inventory_hostname`, `playbook_dir`, entre outros.

Com tantas fontes de variáveis, é essencial entender a ordem em que o Ansible as processa para evitar surpresas. Isso nos leva ao próximo tópico: a precedência de variáveis.



## Precedência de Variáveis: Quem Ganha a Batalha?

Com tantas fontes possíveis para variáveis, é natural que haja conflitos quando a mesma variável é definida em múltiplos lugares. O Ansible resolve esses conflitos seguindo uma ordem estrita de **precedência de variáveis**. Entender essa ordem é crucial para depurar playbooks e garantir que suas configurações se comportem como esperado.

A regra geral é que variáveis definidas em fontes mais específicas ou mais próximas da execução da tarefa têm maior precedência e sobrescrevem variáveis definidas em fontes mais genéricas ou distantes. A ordem de precedência (do menos prioritário para o mais prioritário) é a seguinte:

1.  **Variáveis de Role Padrão (`defaults/main.yml`):** As variáveis com a menor precedência. Destinadas a fornecer valores padrão que podem ser facilmente sobrescritos.
2.  **Variáveis de Inventário (`inventory.ini` ou `inventory.yml`):** Variáveis definidas diretamente no arquivo de inventário.
3.  **Variáveis de `group_vars/all`:** Variáveis definidas no arquivo `group_vars/all.yml` (ou `all.json`), que se aplicam a todos os hosts.
4.  **Variáveis de `group_vars/<nome_do_grupo>`:** Variáveis definidas em arquivos específicos de grupo (ex: `group_vars/webservers.yml`). Se um host pertence a múltiplos grupos, as variáveis desses grupos são mescladas, e a ordem de mesclagem pode ser influenciada pela ordem alfabética dos nomes dos grupos ou pela ordem de definição no inventário (para grupos de grupos).
5.  **Variáveis de `host_vars/<nome_do_host>`:** Variáveis definidas em arquivos específicos de host (ex: `host_vars/server1.example.com.yml`). Têm precedência sobre as variáveis de grupo.
6.  **Variáveis de Role (`vars/main.yml`):** Variáveis definidas dentro da estrutura de uma role. Têm precedência sobre as variáveis de inventário e `group_vars`/`host_vars` (exceto as definidas em `host_vars` para o host específico).
7.  **Variáveis de Playbook (`vars:`):** Variáveis definidas na seção `vars:` de um playbook. Sobrescrevem a maioria das variáveis de inventário e role.
8.  **Variáveis de Linha de Comando (`-e` ou `--extra-vars`):** Variáveis passadas diretamente na linha de comando. Têm a maior precedência de todas, sobrescrevendo qualquer outra definição.

### Exemplo de Precedência

Vamos considerar um cenário onde a variável `app_port` é definida em vários lugares:

*   **`roles/my_app/defaults/main.yml`:**
    ```yaml
    app_port: 8080
    ```
*   **`group_vars/webservers.yml`:**
    ```yaml
    app_port: 80
    ```
*   **`host_vars/web1.example.com.yml`:**
    ```yaml
    app_port: 8000
    ```
*   **`my_playbook.yml`:**
    ```yaml
    --- 
    - name: Deploy da Aplicacao
      hosts: webservers
      vars:
        app_port: 9000
      roles:
        - my_app
      tasks:
        - name: Exibir porta da aplicacao
          ansible.builtin.debug:
            msg: "A porta da aplicacao e: {{ app_port }}"
    ```

*   **Execução com `-e`:**
    ```bash
    ansible-playbook my_playbook.yml -e "app_port=7000"
    ```

**Resultados:**
*   Se `web1.example.com` for o host alvo e o playbook for executado **sem** `-e`, a porta será `9000` (variável do playbook tem precedência sobre `host_vars`).
*   Se o playbook for executado **com** `-e "app_port=7000"`, a porta será `7000` (variável de linha de comando tem a maior precedência).
*   Se a variável `app_port` não fosse definida no playbook nem na linha de comando, mas estivesse em `host_vars/web1.example.com.yml`, o valor seria `8000`.
*   Se não estivesse em `host_vars` mas em `group_vars/webservers.yml`, o valor seria `80`.
*   E se não estivesse em nenhuma das anteriores, mas apenas em `roles/my_app/defaults/main.yml`, o valor seria `8080`.

Compreender essa hierarquia é fundamental para evitar comportamentos inesperados e para projetar playbooks que sejam robustos e previsíveis em diferentes cenários.



## Fatos (Facts) em Ansible: Conhecendo Seus Hosts

Além das variáveis que você define explicitamente, o Ansible tem a capacidade de coletar automaticamente informações detalhadas sobre os hosts gerenciados. Essas informações são chamadas de **Fatos (Facts)**. Os fatos são dados dinâmicos sobre o sistema remoto, como sistema operacional, interfaces de rede, memória, CPU, discos, e muito mais.

### Como os Fatos são Coletados?

Por padrão, quando um playbook é executado, a primeira coisa que o Ansible faz é executar uma tarefa implícita chamada `Gathering Facts`. Esta tarefa utiliza o módulo `ansible.builtin.setup` (ou `setup` de forma abreviada) para se conectar ao host remoto e coletar uma vasta gama de informações sobre ele. Essas informações são então armazenadas como variáveis especiais, prefixadas com `ansible_facts.`, e ficam disponíveis para uso em qualquer tarefa subsequente no playbook.

Você pode ver todos os fatos coletados para um host executando um comando ad-hoc:

```bash
ansible <nome_do_host> -m ansible.builtin.setup
```

Ou, dentro de um playbook, usando o módulo `debug`:

```yaml
---
- name: Exibir todos os fatos de um host
  hosts: seu_host
  gather_facts: true # O padrao e true, mas e bom explicitar
  tasks:
    - name: Exibir fatos
      ansible.builtin.debug:
        var: ansible_facts
```

### Fatos Comuns e Seus Usos

Os fatos fornecem uma riqueza de informações que podem ser usadas para tomar decisões em seus playbooks, tornando-os mais inteligentes e adaptáveis. Alguns dos fatos mais comumente utilizados incluem:

*   **Informações do Sistema Operacional:**
    *   `ansible_facts.distribution`: Nome da distribuição (e.g., `Ubuntu`, `CentOS`, `RedHat`).
    *   `ansible_facts.distribution_version`: Versão da distribuição (e.g., `20.04`, `7.9`).
    *   `ansible_facts.os_family`: Família do sistema operacional (e.g., `Debian`, `RedHat`, `Suse`).
    *   `ansible_facts.kernel`: Versão do kernel.
    *   `ansible_facts.hostname`: Nome do host.
    *   `ansible_facts.fqdn`: Nome de domínio totalmente qualificado.

*   **Informações de Rede:**
    *   `ansible_facts.interfaces`: Lista de todas as interfaces de rede.
    *   `ansible_facts.default_ipv4.address`: Endereço IP da interface de rede padrão.
    *   `ansible_facts.default_ipv4.gateway`: Gateway padrão.
    *   `ansible_facts.default_ipv4.network`: Rede padrão.

*   **Informações de Hardware:**
    *   `ansible_facts.memtotal_mb`: Memória total em MB.
    *   `ansible_facts.processor_count`: Número de CPUs lógicas.
    *   `ansible_facts.mounts`: Informações sobre sistemas de arquivos montados.
    *   `ansible_facts.devices`: Informações sobre dispositivos de bloco.

**Exemplo de Uso de Fatos em Playbook:**

```yaml
---
- name: Configurar Servidor Baseado no OS
  hosts: all
  become: true
  tasks:
    - name: Instalar Apache no Debian/Ubuntu
      ansible.builtin.package:
        name: apache2
        state: present
      when: ansible_facts.os_family == "Debian"

    - name: Instalar Nginx no RedHat/CentOS
      ansible.builtin.package:
        name: nginx
        state: present
      when: ansible_facts.os_family == "RedHat"

    - name: Exibir informacoes de rede
      ansible.builtin.debug:
        msg: "IP do host {{ ansible_facts.hostname }}: {{ ansible_facts.default_ipv4.address }}"
```

Neste exemplo, o playbook decide qual pacote de servidor web instalar (`apache2` ou `nginx`) com base no fato `ansible_facts.os_family`, tornando o playbook portátil entre diferentes distribuições Linux.

### Desabilitando a Coleta de Fatos (`gather_facts: false`)

Embora a coleta de fatos seja extremamente útil, ela adiciona um pequeno overhead de tempo ao início de cada execução de playbook, pois o Ansible precisa se conectar a cada host e coletar essas informações. Em cenários onde você tem um grande número de hosts e não precisa de nenhuma informação de fato para as tarefas do seu playbook, você pode desabilitar a coleta de fatos para acelerar a execução.

Para desabilitar a coleta de fatos para um play inteiro, adicione `gather_facts: false` ao seu play:

```yaml
---
- name: Playbook sem coleta de fatos
  hosts: all
  gather_facts: false # Desabilita a coleta de fatos para este play
  tasks:
    - name: Apenas um comando simples que nao precisa de fatos
      ansible.builtin.command: echo "Hello, world!"
```

**Quando desabilitar a coleta de fatos?**

*   Quando você está executando tarefas muito simples que não dependem de nenhuma informação do sistema remoto (por exemplo, apenas copiando um arquivo estático, executando um comando trivial).
*   Em ambientes com milhares de hosts, onde o tempo de coleta de fatos pode se tornar significativo.
*   Quando você já tem as informações necessárias de outra fonte (por exemplo, de um inventário dinâmico que já fornece todos os dados relevantes como variáveis).

**Considerações:**

*   Se você desabilitar `gather_facts` e, posteriormente, uma tarefa tentar usar uma variável `ansible_facts.`, o playbook falhará, pois essa variável não estará disponível.
*   Você pode coletar fatos seletivamente usando `gather_subset` (por exemplo, `gather_subset: network` para coletar apenas fatos de rede) ou `fact_caching` para armazenar fatos coletados e reutilizá-los em execuções futuras, o que pode ser uma alternativa mais eficiente do que desabilitar completamente a coleta de fatos em alguns casos.

O uso inteligente de fatos e a compreensão de quando e como coletá-los (ou não) são habilidades essenciais para escrever playbooks Ansible eficientes e robustos.



## Exemplos Práticos de Variáveis e Fatos

Vamos agora consolidar o entendimento sobre variáveis e fatos com exemplos práticos que demonstram como usá-los em seus playbooks Ansible.

### Exemplo 1: Variáveis de Inventário e `group_vars`/`host_vars`

Vamos criar uma estrutura de diretórios e arquivos para demonstrar o uso de variáveis de inventário, `group_vars` e `host_vars`.

**Estrutura de Diretórios:**
```
curso_ansible/
├── inventory.ini
├── group_vars/
│   ├── webservers.yml
│   └── all.yml
├── host_vars/
│   └── web01.example.com.yml
└── playbooks/
    └── display_vars.yml
```

**`inventory.ini`:**
```ini
[webservers]
web01.example.com
web02.example.com

[databases]
db01.example.com

[all:vars]
ansible_user=ansible_admin
```

**`group_vars/all.yml`:**
```yaml
company_name: "Minha Empresa"
ambiente_padrao: "desenvolvimento"
```

**`group_vars/webservers.yml`:**
```yaml
app_type: "Web Application"
http_port: 80
```

**`host_vars/web01.example.com.yml`:**
```yaml
http_port: 8080 # Sobrescreve a porta do grupo webservers
server_role: "Primary Web Server"
```

**`playbooks/display_vars.yml`:**
```yaml
---
- name: Exibir Variaveis de Diferentes Fontes
  hosts: all
  gather_facts: false
  tasks:
    - name: Exibir variaveis gerais
      ansible.builtin.debug:
        msg: |
          Host: {{ inventory_hostname }}
          Usuario Ansible: {{ ansible_user }}
          Nome da Empresa: {{ company_name }}
          Ambiente Padrao: {{ ambiente_padrao }}

    - name: Exibir variaveis de webserver (se aplicavel)
      ansible.builtin.debug:
        msg: |
          Tipo de App: {{ app_type | default('N/A') }}
          Porta HTTP: {{ http_port | default('N/A') }}
          Funcao do Servidor: {{ server_role | default('N/A') }}
      when: "webservers" in group_names
```

**Como Executar:**
```bash
ansible-playbook -i inventory.ini playbooks/display_vars.yml
```

**Saída Esperada (para `web01.example.com`):**
```
TASK [Exibir variaveis gerais] *************************************************
ok: [web01.example.com] => {
    "msg": "Host: web01.example.com\nUsuario Ansible: ansible_admin\nNome da Empresa: Minha Empresa\nAmbiente Padrao: desenvolvimento"
}

TASK [Exibir variaveis de webserver (se aplicavel)] ****************************
ok: [web01.example.com] => {
    "msg": "Tipo de App: Web Application\nPorta HTTP: 8080\nFuncao do Servidor: Primary Web Server"
}
```

**Observações:**
*   `ansible_user` é do `inventory.ini` (`[all:vars]`).
*   `company_name` e `ambiente_padrao` são de `group_vars/all.yml`.
*   `app_type` é de `group_vars/webservers.yml`.
*   `http_port` é `8080` (de `host_vars/web01.example.com.yml`), sobrescrevendo `80` (de `group_vars/webservers.yml`), demonstrando a precedência.
*   `server_role` é de `host_vars/web01.example.com.yml`.

### Exemplo 2: Precedência de Variáveis com `vars` do Playbook e Linha de Comando

Vamos usar o mesmo inventário, mas focar em como as variáveis definidas no playbook e na linha de comando podem sobrescrever outras fontes.

**`playbooks/precedence_test.yml`:**
```yaml
---
- name: Testar Precedencia de Variaveis
  hosts: webservers
  gather_facts: false
  vars:
    http_port: 9000 # Variavel definida no playbook
    app_env: "staging" # Nova variavel de playbook
  tasks:
    - name: Exibir porta HTTP e ambiente
      ansible.builtin.debug:
        msg: |
          Host: {{ inventory_hostname }}
          Porta HTTP: {{ http_port }}
          Ambiente da Aplicacao: {{ app_env }}
```

**Como Executar:**

1.  **Execução Padrão (com `http_port` de `host_vars` ou `group_vars`):**
    ```bash
    ansible-playbook -i inventory.ini playbooks/precedence_test.yml
    ```
    *   Para `web01.example.com`, `http_port` será `9000` (do playbook, sobrescrevendo `8080` de `host_vars`).
    *   Para `web02.example.com`, `http_port` será `9000` (do playbook, sobrescrevendo `80` de `group_vars`).
    *   `app_env` será `staging` para ambos.

2.  **Execução com `-e` (extra-vars):**
    ```bash
    ansible-playbook -i inventory.ini playbooks/precedence_test.yml -e "http_port=7000 app_env=production"
    ```
    *   Para ambos os hosts, `http_port` será `7000` e `app_env` será `production` (variáveis da linha de comando têm a maior precedência).

### Exemplo 3: Usando Fatos (Facts) em Playbooks

Este playbook demonstra como acessar e usar fatos coletados pelo Ansible.

**`playbooks/use_facts.yml`:**
```yaml
---
- name: Usar Fatos do Sistema
  hosts: all
  gather_facts: true # Garante que os fatos sejam coletados
  tasks:
    - name: Exibir informacoes basicas do sistema
      ansible.builtin.debug:
        msg: |
          Hostname: {{ ansible_facts.hostname }}
          FQDN: {{ ansible_facts.fqdn }}
          Sistema Operacional: {{ ansible_facts.distribution }} {{ ansible_facts.distribution_version }}
          Familia do OS: {{ ansible_facts.os_family }}
          Arquitetura: {{ ansible_facts.architecture }}
          Total de RAM: {{ ansible_facts.memtotal_mb }} MB
          Numero de CPUs: {{ ansible_facts.processor_count }}

    - name: Exibir endereco IP padrao
      ansible.builtin.debug:
        msg: "O endereco IP padrao e: {{ ansible_facts.default_ipv4.address }}"
      when: ansible_facts.default_ipv4 is defined

    - name: Instalar pacote baseado na familia do OS
      ansible.builtin.package:
        name: "{{ 'apache2' if ansible_facts.os_family == 'Debian' else 'httpd' }}"
        state: present
      become: true

    - name: Exibir informacoes de interfaces de rede (apenas para webservers)
      ansible.builtin.debug:
        var: ansible_facts.interfaces
      when: "webservers" in group_names
```

**Como Executar:**
```bash
ansible-playbook -i inventory.ini playbooks/use_facts.yml
```

**Explicação:**
*   `gather_facts: true` é explicitamente definido para garantir a coleta de fatos.
*   O módulo `debug` é usado para exibir vários fatos do sistema.
*   Uma condicional `when` é usada para exibir o IP padrão apenas se o fato `default_ipv4` estiver definido.
*   O nome do pacote a ser instalado (`apache2` ou `httpd`) é escolhido dinamicamente com base em `ansible_facts.os_family`, usando uma expressão Jinja2.
*   As informações de interfaces de rede são exibidas apenas para hosts no grupo `webservers`.

### Exemplo 4: Desabilitando a Coleta de Fatos

Este playbook demonstra como desabilitar a coleta de fatos para um play, o que pode ser útil para otimização em cenários específicos.

**`playbooks/no_facts.yml`:**
```yaml
---
- name: Playbook sem Coleta de Fatos
  hosts: all
  gather_facts: false # Desabilita a coleta de fatos para este play
  tasks:
    - name: Executar um comando simples que nao depende de fatos
      ansible.builtin.command: echo "Esta tarefa nao precisa de fatos do sistema."

    - name: Tentar usar um fato (isso falhara!)
      ansible.builtin.debug:
        msg: "O hostname e: {{ ansible_facts.hostname }}"
      ignore_errors: true # Para que o playbook continue apos o erro
```

**Como Executar:**
```bash
ansible-playbook -i inventory.ini playbooks/no_facts.yml
```

**Saída Esperada:**
*   A primeira tarefa será executada com sucesso.
*   A segunda tarefa (`Tentar usar um fato`) falhará, pois `ansible_facts.hostname` não estará disponível, e o Ansible reportará um erro (a menos que `ignore_errors: true` seja usado, como no exemplo, para demonstrar o comportamento sem parar a execução).

Esses exemplos ilustram a flexibilidade e o poder das variáveis e fatos no Ansible, permitindo que você crie automações altamente adaptáveis e inteligentes para sua infraestrutura.

