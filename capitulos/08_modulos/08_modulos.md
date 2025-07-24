# Capítulo 8: Módulos Ansible

## O que são Módulos Ansible e Sua Função

No coração de cada tarefa que o Ansible executa está um **Módulo**. Pense nos módulos como as ferramentas que o Ansible usa para interagir com seus hosts gerenciados. Cada módulo é uma unidade de código autônoma, projetada para realizar uma função específica, como instalar um pacote, gerenciar um serviço, copiar um arquivo, ou executar um comando.

Quando você escreve um playbook, você está essencialmente instruindo o Ansible a usar módulos específicos com determinados parâmetros para alcançar um estado desejado em seus sistemas. O Ansible se encarrega de transportar o módulo para o host remoto, executá-lo e, em seguida, remover o módulo após a conclusão da tarefa. Essa abordagem "push-based" e "agentless" é uma das razões pelas quais o Ansible é tão popular.

### Função dos Módulos:

*   **Abstração:** Módulos abstraem a complexidade das operações de baixo nível. Em vez de escrever comandos shell específicos para cada sistema operacional (por exemplo, `apt install` para Debian, `yum install` para RedHat), você usa um módulo genérico como `ansible.builtin.package`, e o Ansible se encarrega de usar o gerenciador de pacotes correto.
*   **Idempotência:** A maioria dos módulos Ansible é projetada para ser idempotente. Isso significa que eles verificam o estado atual do sistema antes de fazer qualquer alteração. Se o estado desejado já foi alcançado, o módulo não fará nada, mas reportará sucesso. Isso garante que seus playbooks podem ser executados repetidamente sem causar efeitos colaterais indesejados.
*   **Padronização:** Módulos fornecem uma interface padronizada para interagir com diferentes sistemas e serviços, tornando seus playbooks mais consistentes e fáceis de manter.
*   **Relatório de Estado:** Módulos retornam informações detalhadas sobre o resultado de sua execução, incluindo se alguma alteração foi feita (`changed`) ou se o estado já estava conforme (`ok`).

### Módulos Built-in vs. Coleções

Historicamente, todos os módulos vinham empacotados com o Ansible. Com o tempo, a quantidade de módulos cresceu exponencialmente, levando à introdução do conceito de **Coleções**.

*   **Módulos Built-in:** São os módulos que vêm com a instalação principal do Ansible. Eles são considerados os módulos "core" e são mantidos pela equipe do Ansible. Muitos deles estão sob o namespace `ansible.builtin` (por exemplo, `ansible.builtin.package`, `ansible.builtin.service`).
*   **Coleções:** São uma forma de empacotar e distribuir módulos, plugins e roles de forma independente do lançamento principal do Ansible. Coleções podem ser desenvolvidas pela comunidade, por fornecedores (como Red Hat, Cisco, VMware) ou por terceiros. Elas permitem que o Ansible seja estendido e atualizado de forma mais modular.

Para usar um módulo de uma coleção, você geralmente precisa especificar o nome completo da coleção, como `community.general.ufw` ou `ansible.posix.firewalld`. Se o módulo for do namespace `ansible.builtin`, você pode omitir `ansible.builtin.` (por exemplo, `package` em vez de `ansible.builtin.package`).

### Estrutura de um Módulo (Parâmetros e Estado)

Cada módulo tem um conjunto de parâmetros que você pode usar para controlar seu comportamento. A documentação de cada módulo detalha esses parâmetros, seus tipos e seus valores aceitáveis.

**Exemplo de Parâmetros de Módulo:**
```yaml
- name: Instalar pacote Nginx
  ansible.builtin.apt:
    name: nginx       # Parâmetro: nome do pacote
    state: present    # Parâmetro: estado desejado (present, absent, latest)
    update_cache: yes # Parâmetro: atualizar cache de pacotes
```

*   **`name`:** (Não é um parâmetro do módulo, mas da tarefa) Um nome descritivo para a tarefa, útil para logs.
*   **`ansible.builtin.apt`:** O nome do módulo a ser executado.
*   **`name` (parâmetro do módulo):** O nome do pacote a ser gerenciado.
*   **`state` (parâmetro do módulo):** Define o estado desejado do pacote. Valores comuns incluem `present` (instalado), `absent` (removido), `latest` (última versão disponível).
*   **`update_cache` (parâmetro do módulo):** Um booleano que indica se o cache de pacotes deve ser atualizado antes da operação.

Ao usar um módulo, você sempre deve consultar sua documentação para entender todos os parâmetros disponíveis e como eles afetam o comportamento do módulo. Isso garante que você esteja usando o módulo de forma eficaz e segura.



## Módulos Comuns e Seus Casos de Uso

O Ansible possui centenas de módulos, cada um projetado para uma tarefa específica. Conhecer os módulos mais comuns e seus casos de uso é fundamental para começar a automatizar com eficácia. Abaixo, detalhamos alguns dos módulos mais frequentemente utilizados:

### 1. `ansible.builtin.package` (ou `apt`, `yum`, `dnf`, `apk`, etc.)

**Função:** Gerencia pacotes de software em sistemas operacionais. Este é um módulo genérico que, por baixo dos panos, utiliza o gerenciador de pacotes apropriado para o sistema operacional do host (por exemplo, `apt` para Debian/Ubuntu, `yum` ou `dnf` para Red Hat/CentOS, `apk` para Alpine).

**Parâmetros Comuns:**
*   `name`: Nome do pacote ou lista de pacotes.
*   `state`: Estado desejado do pacote (`present`, `absent`, `latest`, `installed`).
*   `update_cache`: (Booleano) Se `yes`, atualiza o cache do gerenciador de pacotes antes da operação.

**Casos de Uso:** Instalar, remover, atualizar ou garantir a presença de pacotes de software.

**Exemplo:**
```yaml
- name: Instalar Nginx e Git
  ansible.builtin.package:
    name:
      - nginx
      - git
    state: present
    update_cache: yes
```

### 2. `ansible.builtin.service`

**Função:** Gerencia serviços em sistemas operacionais (iniciar, parar, reiniciar, recarregar, habilitar no boot).

**Parâmetros Comuns:**
*   `name`: Nome do serviço.
*   `state`: Estado desejado do serviço (`started`, `stopped`, `restarted`, `reloaded`).
*   `enabled`: (Booleano) Se `yes`, o serviço será habilitado para iniciar no boot do sistema.

**Casos de Uso:** Garantir que um serviço esteja rodando, parar um serviço, reiniciar um serviço após uma atualização de configuração.

**Exemplo:**
```yaml
- name: Garantir que o Nginx esteja rodando e habilitado
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

### 3. `ansible.builtin.file`

**Função:** Gerencia arquivos, diretórios e links simbólicos. Permite criar, remover, alterar permissões, proprietários e grupos.

**Parâmetros Comuns:**
*   `path`: Caminho completo do arquivo ou diretório.
*   `state`: Estado desejado (`absent`, `directory`, `file`, `link`, `touch`).
*   `mode`: Permissões do arquivo/diretório (formato octal, e.g., `0644`).
*   `owner`: Proprietário do arquivo/diretório.
*   `group`: Grupo do arquivo/diretório.

**Casos de Uso:** Criar diretórios para aplicações, definir permissões em arquivos de configuração, remover arquivos temporários.

**Exemplo:**
```yaml
- name: Criar diretorio para logs da aplicacao
  ansible.builtin.file:
    path: /var/log/minha_aplicacao
    state: directory
    mode: '0755'
    owner: www-data
    group: www-data

- name: Remover arquivo de configuracao antigo
  ansible.builtin.file:
    path: /etc/nginx/sites-enabled/default
    state: absent
```

### 4. `ansible.builtin.copy`

**Função:** Copia arquivos do nó de controle para os hosts gerenciados.

**Parâmetros Comuns:**
*   `src`: Caminho do arquivo ou diretório no nó de controle.
*   `dest`: Caminho de destino no host gerenciado.
*   `owner`, `group`, `mode`: Permissões e propriedade do arquivo copiado.
*   `content`: Conteúdo direto a ser escrito no arquivo de destino (alternativa a `src`).

**Casos de Uso:** Distribuir arquivos de configuração, scripts, ou qualquer outro arquivo estático.

**Exemplo:**
```yaml
- name: Copiar arquivo de configuracao do Nginx
  ansible.builtin.copy:
    src: files/nginx.conf
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'

- name: Criar arquivo de mensagem com conteudo direto
  ansible.builtin.copy:
    content: |-
      Bem-vindo ao servidor web!
      Esta mensagem foi gerada pelo Ansible.
    dest: /var/www/html/index.html
    owner: www-data
    group: www-data
    mode: '0644'
```

### 5. `ansible.builtin.template`

**Função:** Gera arquivos nos hosts gerenciados a partir de templates Jinja2. Permite inserir variáveis e lógica condicional no conteúdo do arquivo.

**Parâmetros Comuns:**
*   `src`: Caminho do arquivo de template (`.j2`) no nó de controle.
*   `dest`: Caminho de destino no host gerenciado.
*   `owner`, `group`, `mode`: Permissões e propriedade do arquivo gerado.

**Casos de Uso:** Gerar arquivos de configuração dinâmicos (por exemplo, `nginx.conf` com portas variáveis, `my.cnf` com configurações de banco de dados específicas do ambiente).

**Exemplo:**
```yaml
# Conteudo de templates/nginx.conf.j2:
# server {
#     listen {{ http_port }};
#     server_name {{ ansible_fqdn }};
#     location / {
#         root /var/www/html;
#         index index.html;
#     }
# }

- name: Gerar arquivo de configuracao do Nginx a partir de template
  ansible.builtin.template:
    src: templates/nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
  vars:
    http_port: 8080 # Esta variavel sera usada no template
```

### 6. `ansible.builtin.debug`

**Função:** Exibe mensagens durante a execução do playbook. Extremamente útil para depuração e para exibir o valor de variáveis.

**Parâmetros Comuns:**
*   `msg`: A mensagem a ser exibida.
*   `var`: O nome de uma variável cujo valor deve ser exibido.

**Casos de Uso:** Verificar o valor de variáveis, confirmar o fluxo de execução, exibir informações importantes para o usuário.

**Exemplo:**
```yaml
- name: Exibir o nome do sistema operacional
  ansible.builtin.debug:
    msg: "O sistema operacional deste host é {{ ansible_facts.os_family }}."

- name: Exibir todas as variaveis de fato
  ansible.builtin.debug:
    var: ansible_facts
```

### 7. `ansible.builtin.command` e `ansible.builtin.shell`

**Função:** Executam comandos no host gerenciado.

*   **`command`:** Executa um comando simples, sem processamento de shell (sem pipes, redirecionamentos, variáveis de ambiente, etc.). Mais seguro e idempotente por padrão.
*   **`shell`:** Executa comandos através de um shell (como `/bin/sh`), permitindo o uso de pipes, redirecionamentos, variáveis de ambiente e outras funcionalidades de shell. Mais flexível, mas menos seguro e mais propenso a problemas de idempotência.

**Parâmetros Comuns:**
*   `cmd`: O comando a ser executado.
*   `chdir`: Diretório onde o comando será executado.
*   `creates`: O comando só será executado se o arquivo especificado não existir.
*   `removes`: O comando só será executado se o arquivo especificado existir.

**Casos de Uso:** Executar comandos que não possuem um módulo Ansible dedicado, ou para tarefas muito específicas que exigem funcionalidades de shell.

**Exemplo:**
```yaml
- name: Executar comando simples (command)
  ansible.builtin.command:
    cmd: hostname -f

- name: Executar comando com pipe (shell)
  ansible.builtin.shell:
    cmd: ps aux | grep nginx
  register: nginx_process

- name: Exibir saida do comando shell
  ansible.builtin.debug:
    var: nginx_process.stdout_lines
```

**Importante:** Sempre prefira usar um módulo Ansible específico em vez de `command` ou `shell` quando um módulo apropriado existir. Módulos são mais seguros, mais fáceis de usar e garantem idempotência. Use `command` ou `shell` apenas como último recurso.

Esses são apenas alguns dos módulos mais utilizados. A vasta biblioteca de módulos do Ansible é um dos seus maiores pontos fortes, permitindo automatizar quase qualquer tarefa de TI.



## Como Encontrar e Usar a Documentação de Módulos

Com centenas de módulos disponíveis, saber como encontrar e interpretar a documentação é uma habilidade essencial para qualquer usuário de Ansible. A documentação oficial é a sua melhor amiga para entender o propósito de um módulo, seus parâmetros, exemplos de uso e o que ele retorna.

### 1. Documentação Online Oficial

A fonte mais completa e atualizada da documentação do Ansible está online. Você pode acessá-la através do site oficial do Ansible:

*   **Docs Ansible:** [https://docs.ansible.com/ansible/latest/collections/index.html](https://docs.ansible.com/ansible/latest/collections/index.html)

Neste site, você pode navegar pelas coleções e módulos. Cada página de módulo fornece:

*   **Synopsis:** Uma breve descrição do que o módulo faz.
*   **Parameters:** Uma lista detalhada de todos os parâmetros aceitos pelo módulo, incluindo:
    *   `name`: O nome do parâmetro.
    *   `type`: O tipo de dado esperado (string, boolean, integer, list, dict).
    *   `required`: Se o parâmetro é obrigatório (`true`) ou opcional (`false`).
    *   `default`: O valor padrão do parâmetro, se houver.
    *   `choices`: Uma lista de valores aceitáveis para o parâmetro, se aplicável.
    *   `description`: Uma explicação detalhada do propósito do parâmetro.
*   **Notes:** Informações adicionais, como dependências ou comportamentos específicos.
*   **Examples:** Exemplos práticos de como usar o módulo em um playbook, o que é extremamente útil para aprender.
*   **Return Values:** Uma descrição dos valores que o módulo pode retornar após a execução, útil para registrar ou usar em tarefas subsequentes.

### 2. Usando `ansible-doc` na Linha de Comando

Para acesso rápido à documentação de um módulo diretamente do seu terminal, você pode usar o comando `ansible-doc`. Isso é particularmente útil quando você não tem acesso à internet ou prefere trabalhar no terminal.

**Sintaxe:**
```bash
ansible-doc <nome_do_modulo>
```

**Exemplos:**

*   **Para o módulo `ansible.builtin.apt`:**
    ```bash
    ansible-doc ansible.builtin.apt
    ```
    Ou, de forma abreviada, se o módulo for `ansible.builtin`:
    ```bash
    ansible-doc apt
    ```

*   **Para um módulo de coleção (ex: `community.general.ufw`):**
    ```bash
    ansible-doc community.general.ufw
    ```

O `ansible-doc` exibirá a documentação completa do módulo, incluindo sinopse, parâmetros, exemplos e valores de retorno, diretamente no seu terminal. Você pode usar as teclas de navegação do `less` (setas, Page Up/Down, `q` para sair) para ler o conteúdo.

### Dicas para Usar a Documentação:

*   **Comece pela Sinopse:** Entenda rapidamente o que o módulo faz.
*   **Verifique os Parâmetros Obrigatórios:** Certifique-se de fornecer todos os parâmetros marcados como `required: true`.
*   **Explore os Exemplos:** Os exemplos são a melhor forma de ver o módulo em ação e entender como seus parâmetros são usados em cenários reais.
*   **Entenda os Valores de Retorno:** Se você precisar usar a saída de um módulo em tarefas subsequentes (por exemplo, registrar a saída de um comando), consulte a seção `Return Values` para saber o que esperar.
*   **Use a Busca:** Tanto no site quanto no `ansible-doc`, você pode pesquisar por palavras-chave para encontrar módulos relevantes para a tarefa que você deseja automatizar.

Dominar a arte de consultar a documentação é um diferencial para se tornar um usuário proficiente de Ansible, permitindo que você explore a vasta gama de funcionalidades da ferramenta de forma autônoma e eficiente.



## Exemplos Práticos de Módulos

Vamos agora consolidar o conhecimento sobre os módulos Ansible com exemplos práticos. Cada exemplo mostrará como usar um módulo específico em um playbook, ilustrando seus parâmetros e o resultado esperado.

### Exemplo 1: Gerenciamento de Pacotes (`ansible.builtin.package`)

Este playbook instala o `htop` e garante que o `unzip` esteja na versão mais recente em hosts baseados em Debian/Ubuntu.

```yaml
---
- name: Gerenciar Pacotes
  hosts: webservers
  become: true
  tasks:
    - name: Instalar htop
      ansible.builtin.package:
        name: htop
        state: present

    - name: Garantir que unzip esteja na versao mais recente
      ansible.builtin.package:
        name: unzip
        state: latest
```

### Exemplo 2: Gerenciamento de Serviços (`ansible.builtin.service`)

Este playbook garante que o serviço `nginx` esteja rodando e habilitado para iniciar no boot.

```yaml
---
- name: Gerenciar Servicos
  hosts: webservers
  become: true
  tasks:
    - name: Garantir que o servico Nginx esteja rodando e habilitado
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

### Exemplo 3: Gerenciamento de Arquivos e Diretórios (`ansible.builtin.file`)

Este playbook cria um diretório, define permissões e remove um arquivo.

```yaml
---
- name: Gerenciar Arquivos e Diretorios
  hosts: webservers
  become: true
  tasks:
    - name: Criar diretorio para aplicacao
      ansible.builtin.file:
        path: /opt/minha_aplicacao
        state: directory
        mode: '0755'
        owner: www-data
        group: www-data

    - name: Remover arquivo temporario antigo
      ansible.builtin.file:
        path: /tmp/arquivo_antigo.txt
        state: absent
```

### Exemplo 4: Copiando Arquivos (`ansible.builtin.copy`)

Este playbook copia um arquivo de configuração local para o servidor remoto e cria um arquivo com conteúdo direto.

```yaml
---
- name: Copiar Arquivos
  hosts: webservers
  become: true
  tasks:
    - name: Copiar arquivo de configuracao customizado
      ansible.builtin.copy:
        src: /path/to/local/config.conf
        dest: /etc/minha_aplicacao/config.conf
        owner: root
        group: root
        mode: '0644'

    - name: Criar arquivo de boas-vindas com conteudo direto
      ansible.builtin.copy:
        content: |-
          Bem-vindo ao servidor!
          Este arquivo foi criado pelo Ansible.
        dest: /var/www/html/bem_vindo.txt
        owner: www-data
        group: www-data
        mode: '0644'
```

### Exemplo 5: Gerando Arquivos com Templates (`ansible.builtin.template`)

Este playbook gera um arquivo de configuração Nginx usando um template Jinja2, permitindo que variáveis sejam inseridas dinamicamente.

**Conteúdo de `templates/nginx.conf.j2`:**
```jinja2
server {
    listen {{ http_port | default(80) }};
    server_name {{ ansible_fqdn }};

    location / {
        root /var/www/html;
        index index.html;
    }

    {% if enable_ssl is defined and enable_ssl %}
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/{{ ansible_fqdn }}.crt;
    ssl_certificate_key /etc/nginx/ssl/{{ ansible_fqdn }}.key;
    {% endif %}
}
```

**Playbook (`generate_nginx_config.yml`):**
```yaml
---
- name: Gerar Configuracao Nginx com Template
  hosts: webservers
  become: true
  vars:
    http_port: 80
    enable_ssl: true
  tasks:
    - name: Gerar configuracao Nginx
      ansible.builtin.template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
        owner: root
        group: root
        mode: '0644'
      notify: Restart Nginx

  handlers:
    - name: Restart Nginx
      ansible.builtin.service:
        name: nginx
        state: restarted
```

### Exemplo 6: Depuração (`ansible.builtin.debug`)

Este playbook demonstra como usar o módulo `debug` para exibir mensagens e o valor de variáveis.

```yaml
---
- name: Depuracao de Playbook
  hosts: webservers
  gather_facts: true
  tasks:
    - name: Exibir mensagem simples
      ansible.builtin.debug:
        msg: "Iniciando a configuracao do servidor web."

    - name: Exibir o nome do sistema operacional e versao
      ansible.builtin.debug:
        msg: "O sistema operacional e {{ ansible_facts.distribution }} {{ ansible_facts.distribution_version }}."

    - name: Exibir todas as interfaces de rede
      ansible.builtin.debug:
        var: ansible_facts.interfaces
```

### Exemplo 7: Executando Comandos (`ansible.builtin.command` e `ansible.builtin.shell`)

Este playbook mostra o uso de `command` para um comando simples e `shell` para um comando com pipe.

```yaml
---
- name: Executar Comandos
  hosts: webservers
  become: true
  tasks:
    - name: Verificar versao do Python (command)
      ansible.builtin.command:
        cmd: python3 --version
      register: python_version

    - name: Exibir versao do Python
      ansible.builtin.debug:
        var: python_version.stdout

    - name: Listar processos do Nginx (shell)
      ansible.builtin.shell:
        cmd: ps aux | grep nginx | grep -v grep
      register: nginx_processes
      changed_when: false # Este comando nao altera o sistema

    - name: Exibir processos do Nginx
      ansible.builtin.debug:
        var: nginx_processes.stdout_lines
```

### Exemplo Combinado: Configuração Completa de um Servidor Web

Este playbook demonstra como combinar vários módulos para realizar uma tarefa mais complexa: configurar um servidor web Nginx do zero.

```yaml
---
- name: Configuracao Completa de Servidor Web Nginx
  hosts: webservers
  become: true
  vars:
    nginx_port: 80
    app_root_dir: /var/www/html/minha_app

  tasks:
    - name: Atualizar cache de pacotes
      ansible.builtin.apt:
        update_cache: yes
        cache_valid_time: 3600 # Cache valido por 1 hora

    - name: Instalar Nginx
      ansible.builtin.package:
        name: nginx
        state: present

    - name: Criar diretorio raiz da aplicacao
      ansible.builtin.file:
        path: "{{ app_root_dir }}"
        state: directory
        mode: '0755'
        owner: www-data
        group: www-data

    - name: Copiar pagina index.html simples
      ansible.builtin.copy:
        content: |-
          <!DOCTYPE html>
          <html>
          <head>
              <title>Bem-vindo ao Ansible!</title>
          </head>
          <body>
              <h1>Servidor Web Configurado com Sucesso pelo Ansible!</h1>
              <p>Este é o host: {{ ansible_fqdn }}</p>
          </body>
          </html>
        dest: "{{ app_root_dir }}/index.html"
        owner: www-data
        group: www-data
        mode: '0644'

    - name: Gerar configuracao Nginx para a aplicacao
      ansible.builtin.template:
        src: templates/nginx_app.conf.j2
        dest: /etc/nginx/sites-available/minha_app.conf
        owner: root
        group: root
        mode: '0644'
      notify: Restart Nginx

    - name: Habilitar configuracao da aplicacao (criar link simbolico)
      ansible.builtin.file:
        src: /etc/nginx/sites-available/minha_app.conf
        dest: /etc/nginx/sites-enabled/minha_app.conf
        state: link
      notify: Restart Nginx

    - name: Remover configuracao default do Nginx
      ansible.builtin.file:
        path: /etc/nginx/sites-enabled/default
        state: absent
      notify: Restart Nginx

    - name: Garantir que o servico Nginx esteja rodando e habilitado
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart Nginx
      ansible.builtin.service:
        name: nginx
        state: restarted
```

**Conteúdo de `templates/nginx_app.conf.j2`:**
```jinja2
server {
    listen {{ nginx_port }};
    server_name {{ ansible_fqdn }};

    root {{ app_root_dir }};
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Este exemplo demonstra a sinergia entre diferentes módulos para alcançar um objetivo complexo, mostrando como o Ansible pode automatizar fluxos de trabalho completos de configuração de infraestrutura.

