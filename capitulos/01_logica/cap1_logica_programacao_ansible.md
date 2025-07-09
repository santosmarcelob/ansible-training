# Capítulo 1: Lógica de Programação para Ansible

## Introdução

Embora Ansible não seja uma linguagem de programação no sentido tradicional, seus playbooks e tarefas são construídos sobre conceitos lógicos que são a espinha dorsal de qualquer automação eficaz. Compreender esses conceitos permitirá que você crie playbooks mais robustos, flexíveis e fáceis de manter.

Neste capítulo, exploraremos os fundamentos da lógica de programação, como variáveis, tipos de dados, estruturas de controle (condicionais e loops) e a importância da sintaxe. Faremos isso com um olhar atento em como esses conceitos se traduzem e são aplicados no contexto dos arquivos YAML, que são a base para a criação de playbooks Ansible.



## Variáveis e Tipos de Dados

No coração de qualquer lógica de programação estão as variáveis e os tipos de dados. Uma **variável** é um nome simbólico que representa um valor armazenado na memória do computador. Pense nela como uma caixa rotulada onde você pode guardar diferentes tipos de informações. O **tipo de dado** refere-se à natureza do valor que uma variável pode conter, como números inteiros, texto, valores verdadeiros/falsos, etc.

Em linguagens de programação tradicionais, você declara variáveis e seus tipos explicitamente. Por exemplo, em Python, você pode ter `idade = 30` (um número inteiro) ou `nome = "João"` (uma string). Em Ansible, as variáveis são amplamente utilizadas para tornar os playbooks mais dinâmicos e reutilizáveis. Em vez de codificar valores diretamente, você pode usar variáveis para representar informações que podem mudar, como nomes de usuários, caminhos de arquivos, portas de rede, etc.

### Variáveis em YAML e Ansible

YAML (YAML Ain't Markup Language) é uma linguagem de serialização de dados legível por humanos, e é a base para a escrita de playbooks Ansible. Em YAML, a definição de variáveis é bastante intuitiva e não exige declaração explícita de tipo. O tipo de dado é inferido pelo valor atribuído. As variáveis em Ansible podem ser definidas de várias maneiras, incluindo:

*   **Dentro do playbook:** Diretamente no playbook, usando a seção `vars`.
*   **Arquivos de variáveis:** Em arquivos `.yml` separados (por exemplo, `vars/main.yml`).
*   **Linha de comando:** Passadas como argumentos para o comando `ansible-playbook` usando `-e`.
*   **Inventário:** Definidas no arquivo de inventário para hosts ou grupos específicos.

**Exemplos de Tipos de Dados em YAML:**

YAML suporta os tipos de dados mais comuns, que são essenciais para a lógica de programação:

*   **Strings (Texto):** Representam sequências de caracteres. Podem ser delimitadas por aspas simples ou duplas, ou não delimitadas se não contiverem caracteres especiais.
    ```yaml
    nome_servidor: webserver01
    mensagem: "Olá, mundo!"
    ```

*   **Inteiros (Números Inteiros):** Representam números sem casas decimais.
    ```yaml
    porta_http: 80
    quantidade_cpu: 4
    ```

*   **Flutuantes (Números Decimais):** Representam números com casas decimais.
    ```yaml
    versao_software: 2.5
    preco_item: 19.99
    ```

*   **Booleanos (Verdadeiro/Falso):** Representam valores lógicos de verdadeiro ou falso. Em YAML, são frequentemente representados por `true`/`false`, `yes`/`no`, `on`/`off`.
    ```yaml
    habilitar_firewall: true
    servico_ativo: no
    ```

*   **Listas (Arrays):** Representam coleções ordenadas de itens. Cada item é precedido por um hífen e um espaço.
    ```yaml
    pacotes_necessarios:
      - nginx
      - mariadb-server
      - php-fpm
    ```

*   **Dicionários (Mapas/Objetos):** Representam coleções de pares chave-valor. São fundamentais para a estrutura hierárquica do YAML.
    ```yaml
    usuario:
      nome: alice
      uid: 1001
      grupos:
        - webadmin
        - devops
    ```

**Uso de Variáveis em Playbooks Ansible:**

Para usar uma variável em um playbook Ansible, você a referencia usando a sintaxe `{{ nome_da_variavel }}`. O Ansible substituirá essa referência pelo valor da variável no momento da execução.

```yaml
---
- name: Exemplo de uso de variáveis
  hosts: localhost
  vars:
    usuario_admin: admin_ansible
    diretorio_log: /var/log/aplicacao

  tasks:
    - name: Criar diretório de log
      ansible.builtin.file:
        path: "{{ diretorio_log }}"
        state: directory
        mode: '0755'

    - name: Adicionar usuário administrador
      ansible.builtin.user:
        name: "{{ usuario_admin }}"
        state: present
        shell: /bin/bash

    - name: Exibir mensagem com variável
      ansible.builtin.debug:
        msg: "O usuário {{ usuario_admin }} foi criado e o diretório de log é {{ diretorio_log }}."
```

Neste exemplo, `usuario_admin` e `diretorio_log` são variáveis definidas na seção `vars` do playbook. O Ansible as interpreta e usa seus valores nas tarefas subsequentes. A capacidade de usar variáveis é um pilar da lógica de programação, permitindo que você escreva código genérico que pode ser adaptado a diferentes cenários sem modificações diretas no código-fonte.



## Estruturas de Controle: Condicionais e Loops

As estruturas de controle são elementos fundamentais da lógica de programação que permitem que um programa tome decisões e execute ações repetidamente. Elas ditam o fluxo de execução do código, tornando-o dinâmico e capaz de responder a diferentes situações. Em Ansible, essas estruturas são expressas de forma declarativa dentro dos playbooks YAML.

### Condicionais (Decisões)

Condicionais permitem que um bloco de código seja executado **apenas se** uma determinada condição for verdadeira. A estrutura mais comum é o `if-else` (se-senão), onde uma ação é tomada se a condição for verdadeira, e outra ação (opcional) é tomada se for falsa.

Em Ansible, a lógica condicional é implementada principalmente através da palavra-chave `when`. A cláusula `when` é anexada a uma tarefa e contém uma expressão que é avaliada. Se a expressão for verdadeira, a tarefa é executada; caso contrário, ela é ignorada.

**Sintaxe `when` em Ansible:**

```yaml
- name: Instalar Nginx apenas em servidores web
  ansible.builtin.apt:
    name: nginx
    state: present
  when: ansible_facts["os_family"] == "Debian" and inventory_hostname.startswith("web")
```

Neste exemplo, a tarefa de instalar o Nginx só será executada se o sistema operacional for da família Debian **E** o nome do host começar com "web". Você pode usar operadores lógicos como `and` (e), `or` (ou) e `not` (não) para construir condições mais complexas. Variáveis e fatos (informações coletadas sobre os hosts) são frequentemente usados nas expressões `when`.

**Operadores Comuns em Condicionais Ansible:**

| Operador | Descrição                               | Exemplo                                   |
|----------|-----------------------------------------|-------------------------------------------|
| `==`     | Igual a                                 | `variavel == 'valor'`                     |
| `!=`     | Diferente de                            | `variavel != 'valor'`                     |
| `>`      | Maior que                               | `numero > 10`                             |
| `<`      | Menor que                               | `numero < 10`                             |
| `>=`     | Maior ou igual a                        | `numero >= 10`                            |
| `<=`     | Menor ou igual a                        | `numero <= 10`                            |
| `in`     | Contido em (para listas ou strings)     | `'item' in lista` ou `'sub' in 'string'`  |
| `not in` | Não contido em                          | `'item' not in lista`                     |
| `is defined` | Variável está definida                  | `variavel is defined`                     |
| `is not defined` | Variável não está definida              | `variavel is not defined`                 |

### Loops (Repetições)

Loops permitem que um bloco de código seja executado **repetidamente** um certo número de vezes ou para cada item em uma coleção. Isso é extremamente útil para automatizar tarefas que precisam ser aplicadas a múltiplos itens, como criar vários usuários, instalar múltiplos pacotes ou configurar múltiplos arquivos.

Em Ansible, os loops são implementados usando as palavras-chave `loop`, `with_items`, `with_list`, `with_dict`, entre outras. A mais comum e recomendada atualmente é `loop`.

**Sintaxe `loop` em Ansible:**

```yaml
- name: Criar múltiplos usuários
  ansible.builtin.user:
    name: "{{ item.name }}"
    state: present
    shell: "{{ item.shell }}"
  loop:
    - { name: 'joao', shell: '/bin/bash' }
    - { name: 'maria', shell: '/bin/sh' }
    - { name: 'pedro', shell: '/sbin/nologin' }
```

Neste exemplo, a tarefa `ansible.builtin.user` será executada três vezes, uma para cada dicionário na lista fornecida ao `loop`. A variável `item` (ou qualquer nome que você definir com `loop_var`) representa o item atual da iteração.

**Exemplo de Loop com Lista Simples:**

```yaml
- name: Instalar múltiplos pacotes
  ansible.builtin.apt:
    name: "{{ item }}"
    state: present
  loop:
    - apache2
    - php
    - mysql-server
```

Este loop instala `apache2`, `php` e `mysql-server` sequencialmente.

### A Importância da Indentação e Sintaxe em YAML

Em YAML, a **indentação** não é apenas uma questão de estilo; ela define a estrutura e a hierarquia dos dados. Diferente de linguagens que usam chaves `{}` ou parênteses `()` para delimitar blocos, YAML usa espaços em branco para indicar aninhamento. **Cada nível de indentação deve usar um número consistente de espaços (geralmente 2 ou 4), e nunca tabulações.**

Uma indentação incorreta é a causa mais comum de erros em playbooks Ansible. Se a indentação estiver errada, o Ansible não conseguirá interpretar a estrutura do seu playbook, resultando em erros de sintaxe.

**Exemplo de Indentação Correta:**

```yaml
---
- name: Exemplo de indentação
  hosts: all
  tasks:
    - name: Primeira tarefa
      ansible.builtin.debug:
        msg: "Esta é a primeira tarefa."

    - name: Segunda tarefa
      ansible.builtin.debug:
        msg: "Esta é a segunda tarefa."
      when: true
```

Observe como `hosts` e `tasks` estão no mesmo nível de indentação sob o cabeçalho do playbook. As tarefas (`- name:`) são indentadas sob `tasks`, e os módulos (`ansible.builtin.debug`) são indentados sob as tarefas. Os parâmetros do módulo (`msg`, `when`) são indentados sob o módulo.

**Sintaxe YAML:**

Além da indentação, a sintaxe geral do YAML é crucial:

*   **Pares Chave-Valor:** A estrutura básica é `chave: valor`. O espaço após os dois pontos é obrigatório.
*   **Listas:** Itens de lista são precedidos por um hífen (`-`) e um espaço.
*   **Comentários:** Linhas que começam com `#` são consideradas comentários e são ignoradas pelo interpretador.
*   **Documentos Múltiplos:** `---` (três hífens) indica o início de um novo documento YAML. É comum usar no início de playbooks.

Dominar a indentação e a sintaxe YAML é tão importante quanto entender a lógica de programação, pois é através delas que você comunicará suas intenções ao Ansible de forma eficaz.



## Exemplos Práticos em YAML

Para solidificar sua compreensão sobre a aplicação da lógica de programação em Ansible, vamos explorar alguns exemplos práticos de playbooks. Estes exemplos demonstrarão como as variáveis, condicionais e loops são utilizados para criar automações flexíveis e eficientes.

### Exemplo 1: Gerenciamento de Pacotes com Variáveis

Este playbook utiliza variáveis para definir o nome do pacote e o estado desejado (instalado ou removido). Isso permite que o playbook seja reutilizado para diferentes pacotes e ações, simplesmente alterando os valores das variáveis.

```yaml
---
- name: Gerenciar pacotes no servidor
  hosts: all
  vars:
    nome_do_pacote: apache2
    estado_do_pacote: present # ou absent para remover

  tasks:
    - name: Instalar ou remover {{ nome_do_pacote }}
      ansible.builtin.apt:
        name: "{{ nome_do_pacote }}"
        state: "{{ estado_do_pacote }}"
      become: true
```

**Explicação:**
*   `nome_do_pacote` e `estado_do_pacote` são variáveis que controlam qual pacote será gerenciado e se ele será instalado (`present`) ou removido (`absent`).
*   A tarefa `ansible.builtin.apt` usa essas variáveis para executar a ação desejada.

### Exemplo 2: Configuração Condicional de Serviço

Este exemplo mostra como usar uma condicional (`when`) para iniciar um serviço apenas se ele estiver habilitado por uma variável. Isso é útil para configurar diferentes serviços em diferentes ambientes ou hosts.

```yaml
---
- name: Configurar e iniciar serviço
  hosts: webservers
  vars:
    habilitar_nginx: true
    habilitar_apache: false

  tasks:
    - name: Instalar Nginx se habilitado
      ansible.builtin.apt:
        name: nginx
        state: present
      when: habilitar_nginx
      become: true

    - name: Iniciar Nginx se habilitado
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
      when: habilitar_nginx
      become: true

    - name: Instalar Apache se habilitado
      ansible.builtin.apt:
        name: apache2
        state: present
      when: habilitar_apache
      become: true

    - name: Iniciar Apache se habilitado
      ansible.builtin.service:
        name: apache2
        state: started
        enabled: true
      when: habilitar_apache
      become: true
```

**Explicação:**
*   As variáveis `habilitar_nginx` e `habilitar_apache` controlam a execução das tarefas relacionadas a cada serviço.
*   A cláusula `when` garante que as tarefas de instalação e inicialização de um serviço só sejam executadas se a variável correspondente for `true`.

### Exemplo 3: Criação de Múltiplos Diretórios com Loop

Este playbook demonstra o uso de um loop para criar múltiplos diretórios em um servidor. Isso evita a repetição de tarefas para cada diretório individualmente.

```yaml
---
- name: Criar múltiplos diretórios
  hosts: appservers
  vars:
    diretorios_aplicacao:
      - /opt/app/data
      - /opt/app/logs
      - /opt/app/config

  tasks:
    - name: Criar diretório {{ item }}
      ansible.builtin.file:
        path: "{{ item }}"
        state: directory
        mode: '0755'
      loop: "{{ diretorios_aplicacao }}"
      become: true
```

**Explicação:**
*   A variável `diretorios_aplicacao` é uma lista de caminhos de diretórios.
*   O `loop` itera sobre cada item da lista, e a variável `item` assume o valor de cada caminho em cada iteração.
*   A tarefa `ansible.builtin.file` é executada para cada diretório na lista.

### Exemplo 4: Exemplo Combinado: Usuários, Grupos e Condicionais

Este exemplo mais complexo combina variáveis, loops e condicionais para gerenciar usuários e seus grupos. Ele mostra como você pode criar uma lógica sofisticada para automações mais avançadas.

```yaml
---
- name: Gerenciar usuários e grupos
  hosts: all
  vars:
    usuarios_a_gerenciar:
      - name: devops_user
        uid: 2001
        groups: [sudo, devops]
        state: present
        create_home: true
      - name: monitor_user
        uid: 2002
        groups: [monitor]
        state: present
        create_home: false
      - name: old_user
        state: absent # Para remover o usuário

  tasks:
    - name: Criar grupos se não existirem
      ansible.builtin.group:
        name: "{{ item }}"
        state: present
      loop: [sudo, devops, monitor] # Lista de grupos a serem garantidos
      become: true

    - name: Gerenciar usuários
      ansible.builtin.user:
        name: "{{ item.name }}"
        uid: "{{ item.uid | default(omit) }}" # Usa uid se definido, senão omite
        groups: "{{ item.groups | join(',') | default(omit) }}"
        state: "{{ item.state | default("present") }}"
        create_home: "{{ item.create_home | default(true) }}"
        shell: /bin/bash
      loop: "{{ usuarios_a_gerenciar }}"
      loop_control:
        label: "{{ item.name }}"
      become: true

    - name: Remover diretório home para usuários removidos
      ansible.builtin.file:
        path: "/home/{{ item.name }}"
        state: absent
      when: item.state == "absent" and item.create_home | default(true)
      loop: "{{ usuarios_a_gerenciar }}"
      loop_control:
        label: "{{ item.name }}"
      become: true
```

**Explicação:**
*   A variável `usuarios_a_gerenciar` é uma lista de dicionários, onde cada dicionário representa um usuário com suas propriedades.
*   O primeiro loop cria os grupos necessários.
*   O segundo loop (`Gerenciar usuários`) itera sobre a lista de usuários, criando ou garantindo o estado de cada um. Note o uso de filtros como `default(omit)` para lidar com chaves opcionais e `join(',')` para transformar a lista de grupos em uma string separada por vírgulas.
*   A última tarefa (`Remover diretório home para usuários removidos`) usa uma condicional `when` para remover o diretório home **apenas** se o usuário estiver sendo removido (`item.state == "absent"`) e se ele tiver um diretório home (`item.create_home | default(true)`).

Estes exemplos ilustram como a combinação de variáveis, condicionais e loops em Ansible permite a criação de playbooks poderosos e adaptáveis, que podem automatizar uma vasta gama de tarefas de gerenciamento de infraestrutura de forma inteligente e eficiente.