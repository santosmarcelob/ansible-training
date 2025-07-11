# Capítulo 2: Introdução ao Ansible

## Questionário: https://forms.gle/y1UJZufHNDWeTjjK9

## Introdução

Ansible é uma ferramenta de automação de código aberto que simplifica o gerenciamento de configuração, a implantação de aplicações e a orquestração de tarefas em ambientes de TI. Diferente de outras ferramentas que exigem a instalação de agentes nos servidores gerenciados, o Ansible opera de forma "agentless", utilizando SSH para se comunicar com os hosts. Essa simplicidade, combinada com sua sintaxe declarativa e legível em YAML, o tornou uma escolha popular para administradores de sistemas, engenheiros de DevOps e desenvolvedores.

Ao longo deste capítulo, vamos desmistificar o Ansible, cobrindo seus principais casos de uso, sua arquitetura, os componentes essenciais como o inventário e os arquivos de configuração, e a estrutura básica de um playbook. Nosso objetivo é fornecer uma compreensão clara de como o Ansible funciona e como você pode começar a utilizá-lo para automatizar suas próprias tarefas.



## O que é Ansible e Seus Casos de Uso

Ansible é uma plataforma de automação de TI de código aberto que permite automatizar o provisionamento, o gerenciamento de configuração, a implantação de aplicações, a orquestração e muitas outras tarefas de TI. Ele se destaca por sua simplicidade, sendo fácil de aprender e usar, e por sua natureza "agentless", o que significa que não requer a instalação de software cliente nos servidores que ele gerencia.

### Por que Ansible?

Tradicionalmente, a administração de sistemas e a implantação de software eram processos manuais e propensos a erros. Com o crescimento da infraestrutura e a necessidade de agilidade, a automação se tornou indispensável. O Ansible preenche essa lacuna, oferecendo uma solução poderosa e flexível para:

*   **Simplicidade:** Usa YAML para playbooks, que é uma linguagem legível por humanos, tornando a automação acessível mesmo para quem não é programador.
*   **Agentless:** Não há agentes para instalar ou gerenciar nos hosts remotos, o que reduz a sobrecarga e os pontos de falha. Ele se comunica via SSH (para Linux/Unix) ou WinRM (para Windows).
*   **Poderoso:** Pode automatizar desde tarefas simples de gerenciamento de configuração até orquestrações complexas de múltiplos aplicativos e servidores.
*   **Extensível:** Possui uma vasta coleção de módulos prontos para uso e permite a criação de módulos personalizados.
*   **Idempotência:** Garante que as operações podem ser executadas várias vezes sem causar efeitos colaterais indesejados. Se uma tarefa já está no estado desejado, o Ansible não fará alterações.

### Principais Casos de Uso do Ansible

O Ansible é incrivelmente versátil e pode ser aplicado em uma ampla gama de cenários de automação de TI:

1.  **Gerenciamento de Configuração:**
    *   Garantir que os servidores estejam configurados de forma consistente (por exemplo, pacotes instalados, serviços em execução, arquivos de configuração corretos).
    *   Aplicar patches e atualizações de segurança em toda a infraestrutura.
    *   Gerenciar usuários e permissões.

    *Exemplo:* Um playbook pode garantir que o servidor web tenha o Nginx instalado, configurado para servir um site específico e que o serviço esteja sempre em execução.

2.  **Implantação de Aplicações:**
    *   Automatizar o processo de implantação de aplicações em diferentes ambientes (desenvolvimento, teste, produção).
    *   Gerenciar dependências, compilar código, configurar servidores de aplicação e bancos de dados.

    *Example:* Implantar uma aplicação web Python, incluindo a instalação de dependências, configuração do Gunicorn e Nginx como proxy reverso.

3.  **Provisionamento:**
    *   Automatizar a criação e configuração inicial de novas máquinas virtuais ou instâncias em nuvem (AWS, Azure, Google Cloud, VMware, etc.).
    *   Instalar o sistema operacional base e as ferramentas essenciais.

    *Exemplo:* Provisionar um novo servidor Ubuntu na AWS, instalar Docker e Kubernetes, e configurá-lo como um nó de cluster.

4.  **Orquestração:**
    *   Coordenar a execução de tarefas em múltiplos servidores em uma ordem específica.
    *   Realizar operações complexas que envolvem vários componentes, como atualizações de cluster, migrações de banco de dados ou failovers.

    *Exemplo:* Realizar uma atualização sem tempo de inatividade para uma aplicação de três camadas, atualizando primeiro os servidores de banco de dados, depois os servidores de aplicação e, por fim, os balanceadores de carga.

5.  **Automação de Segurança e Conformidade:**
    *   Auditar configurações de segurança e aplicar políticas de conformidade.
    *   Garantir que as configurações de firewall estejam corretas e que as portas necessárias estejam abertas ou fechadas.

    *Exemplo:* Verificar se todos os servidores estão usando senhas fortes e se o SSH está configurado para desabilitar o login de root.

6.  **Automação de Rede:**
    *   Configurar roteadores, switches e firewalls de diferentes fornecedores.
    *   Automatizar a criação de VLANs, rotas e políticas de segurança de rede.

    *Exemplo:* Configurar uma nova VLAN em múltiplos switches Cisco e atribuir portas a essa VLAN.

Esses casos de uso demonstram a flexibilidade e o poder do Ansible como uma ferramenta central para a automação de infraestrutura e operações de TI. Sua abordagem simples e declarativa o torna uma escolha excelente para equipes que buscam aumentar a eficiência e reduzir erros manuais.



## Arquitetura do Ansible

A arquitetura do Ansible é notavelmente simples, o que contribui para sua facilidade de uso e implantação. Ao contrário de muitas outras ferramentas de automação que dependem de agentes instalados nos servidores gerenciados, o Ansible opera de forma "agentless". Isso significa que ele não requer nenhum software especial rodando nos hosts remotos, apenas SSH (para sistemas Linux/Unix) ou WinRM (para sistemas Windows) e Python (na maioria dos casos).

Os principais componentes da arquitetura do Ansible são:

1.  **Control Node (Nó de Controle):**
    *   É a máquina onde o Ansible está instalado e de onde os playbooks são executados. Pode ser seu laptop, um servidor dedicado ou uma máquina virtual.
    *   É o ponto central de onde todas as operações de automação são iniciadas.
    *   Você só precisa instalar o Ansible neste nó de controle.

2.  **Managed Nodes (Nós Gerenciados/Hosts):**
    *   São os servidores, dispositivos de rede ou qualquer outro sistema que o Ansible irá automatizar ou configurar.
    *   Não precisam ter o Ansible instalado. Eles apenas precisam ter um método de comunicação (SSH ou WinRM) e, para a maioria dos módulos, Python instalado (geralmente já vem por padrão em sistemas Linux).
    *   O Ansible se conecta a esses nós, executa as tarefas e desconecta.

3.  **Inventário (Inventory):**
    *   É um arquivo (ou conjunto de arquivos) que lista os hosts que o Ansible gerenciará. Ele pode ser estático (um arquivo de texto simples) ou dinâmico (gerado por scripts ou APIs de provedores de nuvem).
    *   O inventário organiza os hosts em grupos, o que permite aplicar configurações a conjuntos específicos de máquinas.
    *   É aqui que você define informações como endereços IP, nomes de host, variáveis específicas de host ou grupo, e credenciais de conexão.

    *Exemplo de Inventário Simples (`inventory.ini`):*
    ```ini
    [webservers]
    web1.example.com
    web2.example.com

    [databases]
    db1.example.com

    [all:vars]
    ansible_user=ubuntu
    ansible_ssh_private_key_file=~/.ssh/id_rsa
    ```
    Neste exemplo, temos dois grupos: `webservers` e `databases`. A seção `[all:vars]` define variáveis que se aplicam a todos os hosts no inventário, como o usuário SSH e o caminho para a chave privada.

4.  **Módulos (Modules):**
    *   São as unidades de código que o Ansible executa nos nós gerenciados. Cada módulo é projetado para realizar uma tarefa específica, como instalar pacotes, gerenciar serviços, copiar arquivos, etc.
    *   O Ansible vem com centenas de módulos "built-in" (integrados), cobrindo uma vasta gama de funcionalidades. Você também pode escrever seus próprios módulos.
    *   Quando um playbook é executado, o Ansible envia o módulo relevante para o nó gerenciado, executa-o e remove-o após a conclusão.

    *Exemplos de Módulos Comuns:*
    *   `ansible.builtin.apt`: Gerencia pacotes em sistemas baseados em Debian.
    *   `ansible.builtin.yum`: Gerencia pacotes em sistemas baseados em RedHat.
    *   `ansible.builtin.service`: Gerencia serviços.
    *   `ansible.builtin.copy`: Copia arquivos para hosts remotos.
    *   `ansible.builtin.file`: Gerencia arquivos e diretórios.
    *   `ansible.builtin.debug`: Exibe mensagens durante a execução do playbook.

5.  **Playbooks:**
    *   São os arquivos YAML que definem as tarefas a serem executadas pelo Ansible. Eles são o coração da automação com Ansible.
    *   Um playbook consiste em uma ou mais "plays", e cada play define um conjunto de tarefas a serem executadas em um grupo específico de hosts.
    *   Playbooks são declarativos, o que significa que você descreve o *estado desejado* do sistema, e o Ansible se encarrega de alcançar esse estado.

    *Exemplo de Estrutura Básica de um Playbook:*
    ```yaml
    ---
    - name: Meu primeiro playbook
      hosts: webservers
      become: true # Executar tarefas com privilégios de root
      tasks:
        - name: Instalar Nginx
          ansible.builtin.apt:
            name: nginx
            state: present

        - name: Iniciar serviço Nginx
          ansible.builtin.service:
            name: nginx
            state: started
            enabled: true
    ```
    Este playbook simples garante que o Nginx esteja instalado e em execução nos hosts do grupo `webservers`.

Essa arquitetura simplificada, sem a necessidade de agentes, torna o Ansible muito fácil de implantar e escalar, sendo uma das suas maiores vantagens.



## Arquivos de Configuração do Ansible (`ansible.cfg`)

O Ansible é altamente configurável, e a maioria de suas configurações pode ser ajustada através do arquivo `ansible.cfg`. Este arquivo permite personalizar o comportamento do Ansible para atender às suas necessidades específicas, desde o local do inventário até as opções de conexão e o comportamento de logging.

### Ordem de Precedência

O Ansible procura o arquivo `ansible.cfg` em uma ordem de precedência específica:

1.  **Variável de Ambiente `ANSIBLE_CONFIG`:** Se esta variável estiver definida, o Ansible usará o caminho especificado por ela.
2.  **Diretório Atual:** O Ansible procura por `ansible.cfg` no diretório de onde o comando `ansible` ou `ansible-playbook` é executado.
3.  **Diretório Home do Usuário:** `~/.ansible.cfg`.
4.  **Diretório do Sistema:** `/etc/ansible/ansible.cfg`.

Essa ordem de precedência permite que você tenha configurações globais no nível do sistema, configurações padrão no seu diretório home, e configurações específicas para projetos no diretório do projeto, garantindo flexibilidade.

### Seções e Parâmetros Comuns

O arquivo `ansible.cfg` é dividido em seções, e cada seção contém parâmetros que controlam diferentes aspectos do Ansible. Algumas das seções e parâmetros mais comuns incluem:

*   **`[defaults]`:** Contém as configurações gerais do Ansible.
    *   `inventory`: Caminho para o arquivo de inventário padrão. Ex: `inventory = ./inventory.ini`
    *   `remote_user`: Usuário padrão para se conectar aos hosts remotos. Ex: `remote_user = ubuntu`
    *   `private_key_file`: Caminho para a chave SSH privada padrão. Ex: `private_key_file = ~/.ssh/id_rsa`
    *   `roles_path`: Caminho onde o Ansible deve procurar por roles. Ex: `roles_path = ./roles`
    *   `host_key_checking`: Define se o Ansible deve verificar as chaves SSH dos hosts. Para ambientes de desenvolvimento, pode ser desabilitado (`False`), mas **NUNCA** em produção. Ex: `host_key_checking = False`
    *   `forks`: Número de processos paralelos para se conectar aos hosts. Ex: `forks = 5`
    *   `log_path`: Caminho para o arquivo de log do Ansible. Ex: `log_path = /var/log/ansible.log`

*   **`[privilege_escalation]`:** Configurações relacionadas à elevação de privilégios (sudo/su).
    *   `become`: Habilita a elevação de privilégios por padrão. Ex: `become = True`
    *   `become_method`: Método de elevação de privilégios (sudo, su, doas, etc.). Ex: `become_method = sudo`
    *   `become_user`: Usuário para o qual os privilégios serão elevados. Ex: `become_user = root`

*   **`[ssh_connection]`:** Configurações específicas para a conexão SSH.
    *   `pipelining`: Habilita o pipelining SSH para reduzir o número de conexões SSH, melhorando a performance. Ex: `pipelining = True`
    *   `ssh_args`: Argumentos adicionais para o comando SSH. Ex: `ssh_args = -o ControlMaster=auto -o ControlPersist=60s`

### Exemplo de `ansible.cfg`

```ini
[defaults]
inventory = ./inventory.ini
remote_user = ansible_user
private_key_file = ~/.ssh/id_rsa_ansible
roles_path = ./roles:../roles

# Desabilitar host key checking para laboratórios, NUNCA em produção!
host_key_checking = False

# Número de processos paralelos
forks = 10

# Caminho para o log
log_path = /var/log/ansible.log

[privilege_escalation]
become = True
become_method = sudo
become_user = root

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

Utilizar o `ansible.cfg` de forma eficaz permite padronizar o comportamento do Ansible em seus projetos e equipes, garantindo consistência e reduzindo a necessidade de especificar opções na linha de comando a cada execução. É uma prática recomendada criar um `ansible.cfg` específico para cada projeto, localizado no diretório raiz do projeto, para isolar as configurações e evitar conflitos.



## Estrutura Básica de um Playbook

Os playbooks são o coração do Ansible. Eles são arquivos YAML que descrevem as tarefas que você deseja executar em seus hosts gerenciados. Um playbook é uma lista de uma ou mais "plays", e cada play é um conjunto de tarefas que são executadas em um grupo específico de hosts. A beleza dos playbooks reside em sua legibilidade e na sua natureza declarativa: você descreve o *estado desejado* do seu sistema, e o Ansible trabalha para alcançar esse estado.

### Componentes de um Playbook

Um playbook Ansible típico é composto pelos seguintes elementos:

1.  **`---` (Três Hífens):** Indica o início de um documento YAML. É uma boa prática incluí-lo no início de cada playbook.

2.  **`name` (Nome do Play):** Um nome descritivo para o play. É útil para identificar o que o play faz durante a execução e nos logs.

3.  **`hosts`:** Define em quais hosts ou grupos de hosts do inventário este play será executado. Pode ser um nome de grupo (`webservers`), um nome de host (`server1.example.com`), `all` (todos os hosts no inventário), ou uma combinação.

4.  **`become` (Elevação de Privilégios):** Se definido como `true`, as tarefas neste play serão executadas com privilégios elevados (geralmente como `root` via `sudo`). Pode ser configurado por play ou por tarefa.

5.  **`gather_facts`:** Controla se o Ansible deve coletar "fatos" sobre os hosts gerenciados antes de executar as tarefas. Fatos são informações sobre o sistema (sistema operacional, memória, interfaces de rede, etc.) que podem ser usadas em condicionais ou templates. Por padrão, é `true`.

6.  **`vars` (Variáveis):** Uma seção onde você pode definir variáveis específicas para este play. Essas variáveis podem ser usadas em qualquer tarefa dentro do play.

7.  **`tasks` (Tarefas):** A seção mais importante, onde você define a lista de ações a serem executadas. Cada item na lista de `tasks` é uma tarefa individual.

    *   **`name` (Nome da Tarefa):** Um nome descritivo para a tarefa. Assim como o nome do play, ajuda a entender o que está acontecendo durante a execução.
    *   **Módulo Ansible:** O nome do módulo Ansible a ser executado (por exemplo, `ansible.builtin.apt`, `ansible.builtin.service`, `ansible.builtin.copy`).
    *   **Parâmetros do Módulo:** Argumentos específicos para o módulo, definidos como pares chave-valor. Por exemplo, para o módulo `apt`, você pode ter `name: nginx` e `state: present`.
    *   **`when` (Condicional):** Uma expressão que, se verdadeira, permite que a tarefa seja executada. Se falsa, a tarefa é ignorada.
    *   **`loop` (Loop):** Permite que uma tarefa seja executada repetidamente para cada item em uma lista.

### Exemplo de Playbook Básico

Vamos revisitar um exemplo simples para ilustrar a estrutura:

```yaml
---
- name: Configurar Servidor Web Básico
  hosts: webservers
  become: true
  gather_facts: true
  vars:
    pacote_web: nginx
    porta_http: 80

  tasks:
    - name: Garantir que o pacote web esteja instalado
      ansible.builtin.apt:
        name: "{{ pacote_web }}"
        state: present

    - name: Garantir que o serviço web esteja rodando e habilitado
      ansible.builtin.service:
        name: "{{ pacote_web }}"
        state: started
        enabled: true

    - name: Abrir porta HTTP no firewall (exemplo com firewalld)
      ansible.posix.firewalld:
        port: "{{ porta_http }}/tcp"
        state: enabled
        permanent: true
        immediate: true
      when: ansible_facts["os_family"] == "RedHat" # Exemplo de condicional

    - name: Exibir mensagem de sucesso
      ansible.builtin.debug:
        msg: "Servidor web {{ pacote_web }} configurado com sucesso na porta {{ porta_http }} em {{ inventory_hostname }}."
```

Neste playbook:
*   O play é nomeado `Configurar Servidor Web Básico`.
*   Ele será executado nos hosts definidos no grupo `webservers` do inventário.
*   `become: true` garante que as tarefas sejam executadas com privilégios de root.
*   `gather_facts: true` coleta informações sobre os hosts.
*   Variáveis `pacote_web` e `porta_http` são definidas para reutilização.
*   As tarefas incluem a instalação do pacote, o gerenciamento do serviço e a configuração do firewall, com uma condicional para o firewall baseada no sistema operacional.
*   A última tarefa usa o módulo `debug` para exibir uma mensagem, utilizando variáveis e fatos do sistema (`inventory_hostname`).

Compreender essa estrutura é o primeiro passo para escrever seus próprios playbooks e automatizar suas tarefas de infraestrutura.



## A Importância da Idempotência no Ansible

Um dos conceitos mais cruciais no Ansible, e na automação em geral, é a **idempotência**. Em termos simples, uma operação é idempotente se ela pode ser executada múltiplas vezes sem causar efeitos colaterais adicionais após a primeira execução. Ou seja, aplicar a mesma configuração ou executar a mesma tarefa repetidamente resultará no mesmo estado final do sistema, sem erros ou mudanças desnecessárias.

### Por que a Idempotência é Fundamental?

Imagine que você tem um playbook que instala um pacote de software. Se esse playbook não fosse idempotente, cada vez que você o executasse, ele tentaria instalar o pacote novamente, o que poderia levar a erros, consumo desnecessário de recursos ou até mesmo corrupção do sistema. Com a idempotência, o Ansible verifica o estado atual do sistema antes de fazer qualquer alteração:

*   **Se o pacote já estiver instalado:** O Ansible reconhece que o estado desejado já foi alcançado e não tenta reinstalá-lo. A tarefa é marcada como "ok" (verde).
*   **Se o pacote não estiver instalado:** O Ansible instala o pacote para atingir o estado desejado. A tarefa é marcada como "changed" (amarelo).

Essa característica é extremamente valiosa por várias razões:

1.  **Segurança e Confiabilidade:** Você pode executar seus playbooks com segurança a qualquer momento, sabendo que eles não causarão danos ou alterações indesejadas em sistemas que já estão no estado correto.
2.  **Reexecução Simplificada:** Facilita a reexecução de playbooks para garantir a conformidade, aplicar pequenas alterações ou recuperar-se de falhas parciais, sem a necessidade de rastrear manualmente o estado anterior.
3.  **Consistência:** Ajuda a manter a consistência em toda a sua infraestrutura, pois o Ansible sempre busca o estado final definido no playbook, independentemente do estado inicial.
4.  **Depuração e Teste:** Simplifica o processo de depuração e teste, pois você pode executar o mesmo playbook repetidamente para verificar se ele se comporta como esperado.

### Como o Ansible Garante a Idempotência?

A maioria dos módulos Ansible é projetada para ser idempotente por natureza. Eles incluem lógica interna para verificar o estado atual do sistema antes de tentar fazer uma alteração. Por exemplo:

*   O módulo `ansible.builtin.package` (ou `apt`, `yum`) verifica se o pacote já está instalado na versão desejada antes de tentar instalá-lo.
*   O módulo `ansible.builtin.service` verifica se o serviço já está no estado (`started`, `stopped`) e habilitado (`enabled`) antes de tentar alterá-lo.
*   O módulo `ansible.builtin.file` verifica se o arquivo ou diretório já existe com as permissões e proprietários corretos antes de tentar criá-lo ou modificá-lo.

Ao escrever seus próprios playbooks, é importante pensar em termos de idempotência. Em vez de instruir o Ansible a "instalar Nginx", pense em "garantir que Nginx esteja presente". Essa mudança de mentalidade é fundamental para construir automações robustas e resilientes com Ansible. A idempotência é um dos pilares que tornam o Ansible uma ferramenta tão poderosa e confiável para gerenciamento de infraestrutura.



## Exemplos Práticos

Para consolidar o conhecimento adquirido sobre a introdução ao Ansible, vamos explorar alguns exemplos práticos que ilustram os conceitos discutidos. Estes exemplos são simples, mas demonstram a funcionalidade básica do Ansible.

### Exemplo 1: Inventário Simples

Um inventário é a espinha dorsal do Ansible, definindo os hosts que você irá gerenciar. Crie um arquivo chamado `inventory.ini` com o seguinte conteúdo:

```ini
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

**Explicação:**
*   `[webservers]` e `[databases]` são grupos de hosts. Você pode ter quantos grupos precisar.
*   `web1.example.com`, `web2.example.com` e `db1.example.com` são os nomes dos hosts que o Ansible tentará se conectar.
*   `[all:vars]` é uma seção especial para definir variáveis que se aplicam a *todos* os hosts no inventário. Aqui, definimos o usuário SSH (`ansible_user`) e o caminho para a chave privada (`ansible_ssh_private_key_file`).

### Exemplo 2: Testando Conectividade (Módulo `ping`)

Antes de executar tarefas complexas, é fundamental verificar se o Ansible consegue se comunicar com seus hosts gerenciados. O módulo `ping` é perfeito para isso.

**Playbook (`ping_test.yml`):**
```yaml
---
- name: Testar conectividade com todos os hosts
  hosts: all
  gather_facts: false

  tasks:
    - name: Executar ping nos hosts
      ansible.builtin.ping:
```

**Como executar:**
`ansible-playbook -i inventory.ini ping_test.yml`

**Saída Esperada (exemplo):**
```
PLAY [Testar conectividade com todos os hosts] *********************************

TASK [Executar ping nos hosts] *************************************************
ok: [web1.example.com]
ok: [web2.example.com]
ok: [db1.example.com]

PLAY RECAP *********************************************************************
db1.example.com            : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
web1.example.com           : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
web2.example.com           : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

Se a saída mostrar `ok` para todos os hosts, significa que o Ansible conseguiu se conectar e autenticar com sucesso.

### Exemplo 3: Instalação de um Pacote Simples

Este playbook demonstra como instalar um pacote (por exemplo, `nginx`) em seus servidores web. Ele utiliza o módulo `ansible.builtin.apt` (para sistemas baseados em Debian) ou `ansible.builtin.yum` (para sistemas baseados em RedHat).

**Playbook (`install_nginx.yml`):**
```yaml
---
- name: Instalar e configurar Nginx
  hosts: webservers
  become: true # Necessário para instalar pacotes

  tasks:
    - name: Instalar pacote Nginx
      ansible.builtin.apt:
        name: nginx
        state: present
      when: ansible_facts["os_family"] == "Debian"

    - name: Instalar pacote Nginx (RedHat)
      ansible.builtin.yum:
        name: nginx
        state: present
      when: ansible_facts["os_family"] == "RedHat"

    - name: Garantir que o serviço Nginx esteja rodando e habilitado
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

**Como executar:**
`ansible-playbook -i inventory.ini install_nginx.yml`

**Explicação:**
*   O playbook é direcionado ao grupo `webservers`.
*   `become: true` é usado para que o Ansible possa executar comandos com privilégios de superusuário (como `sudo`).
*   Duas tarefas de instalação são fornecidas, uma para Debian e outra para RedHat, usando a condicional `when` e os fatos do sistema (`ansible_facts["os_family"]`) para garantir que o módulo correto seja usado.
*   A última tarefa garante que o serviço `nginx` esteja iniciado e configurado para iniciar automaticamente no boot.

### Exemplo 4: Usando `ansible.cfg`

Para demonstrar o uso de `ansible.cfg`, crie um diretório para seu projeto, por exemplo, `meu_projeto_ansible`. Dentro dele, crie os arquivos `inventory.ini` (do Exemplo 1) e `ansible.cfg` com o seguinte conteúdo:

**`meu_projeto_ansible/ansible.cfg`:**
```ini
[defaults]
inventory = ./inventory.ini
remote_user = ubuntu
private_key_file = ~/.ssh/id_rsa
host_key_checking = False # Apenas para ambiente de laboratório!

[privilege_escalation]
become = True
become_method = sudo
become_user = root
```

Agora, você pode executar o playbook `ping_test.yml` (do Exemplo 2) de dentro do diretório `meu_projeto_ansible` sem precisar especificar o inventário na linha de comando:

`cd meu_projeto_ansible`
`ansible-playbook ping_test.yml`

O Ansible automaticamente encontrará o `inventory.ini` e aplicará as configurações de usuário e chave SSH definidas no `ansible.cfg`. Isso simplifica a execução de playbooks e garante consistência nas configurações do projeto.

Estes exemplos fornecem uma base prática para começar a trabalhar com Ansible. À medida que você avança, a complexidade dos playbooks e a utilização de módulos e funcionalidades mais avançadas se tornarão mais evidentes.