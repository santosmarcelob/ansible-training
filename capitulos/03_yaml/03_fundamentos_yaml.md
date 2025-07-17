# Capítulo 3: Fundamentos de YAML

## Questionário: https://forms.gle/JzxtYK6bcAfMyxip6

## Introdução

**YAML** (YAML Ain't Markup Language) é uma linguagem de serialização de dados projetada para ser legível por humanos. Sua simplicidade e clareza a tornaram a escolha preferida para arquivos de configuração, especialmente em ferramentas de automação como o Ansible, Kubernetes e Docker Compose. A facilidade de leitura e escrita do YAML, quando comparada a formatos como XML ou JSON, é uma de suas maiores vantagens, permitindo que você se concentre na lógica da sua automação em vez de lutar com a sintaxe.

Neste capítulo, vamos explorar a sintaxe essencial do YAML, incluindo pares chave-valor, listas, dicionários, tipos de dados e a crucial importância da indentação. Você aprenderá a construir estruturas de dados complexas que são a base para playbooks Ansible eficazes. O objetivo é que, ao final deste capítulo, você não apenas entenda o YAML, mas se sinta confortável para ler, escrever e depurar arquivos YAML com confiança, acelerando sua jornada no mundo da automação com Ansible.



## O que é YAML e Por que é Usado no Ansible?

YAML, que significa recursivamente "YAML Ain't Markup Language" (YAML Não é Linguagem de Marcação), é uma linguagem de serialização de dados legível por humanos. Foi projetada para ser facilmente compreendida tanto por humanos quanto por máquinas, tornando-a ideal para arquivos de configuração e para a troca de dados entre linguagens de programação.

### Características Principais do YAML:

*   **Legibilidade:** Sua sintaxe minimalista e o uso de indentação para estruturar dados a tornam muito fácil de ler e escrever.
*   **Expressividade:** Embora simples, é poderosa o suficiente para representar estruturas de dados complexas, como objetos aninhados e listas.
*   **Compatibilidade:** É um superconjunto de JSON, o que significa que qualquer arquivo JSON válido é também um arquivo YAML válido. Isso facilita a integração com sistemas que usam JSON.
*   **Human-friendly:** O foco principal do YAML é a usabilidade humana, priorizando a clareza sobre a concisão.

### Por que Ansible Usa YAML?

O Ansible escolheu o YAML como sua linguagem padrão para escrever playbooks por várias razões estratégicas que se alinham perfeitamente com a filosofia da ferramenta:

1.  **Simplicidade e Clareza:** A automação deve ser fácil de entender e manter. A sintaxe limpa do YAML permite que os playbooks sejam quase como uma descrição em linguagem natural das tarefas a serem executadas, mesmo para quem não é um programador experiente. Isso reduz a curva de aprendizado e facilita a colaboração entre equipes.

2.  **Natureza Declarativa:** O Ansible é uma ferramenta declarativa, o que significa que você descreve o *estado desejado* do seu sistema, e não os *passos* para alcançá-lo. O YAML, com sua estrutura de dados hierárquica, é excelente para expressar esse estado de forma clara e concisa. Por exemplo, em vez de "execute este comando para instalar o Nginx", você escreve "garanta que o pacote Nginx esteja presente".

3.  **Representação de Estruturas Complexas:** Embora simples, o YAML pode representar estruturas de dados complexas, como listas de dicionários aninhados. Isso é essencial para definir tarefas, variáveis, hosts e configurações de módulos de forma organizada e flexível dentro de um playbook.

4.  **Facilidade de Parsing:** Para o Ansible (e outras ferramentas), analisar arquivos YAML é um processo direto, o que contribui para a eficiência da execução dos playbooks.

5.  **Comentários:** A capacidade de adicionar comentários (`#`) no YAML é crucial para documentar playbooks, tornando-os mais compreensíveis para outros membros da equipe (e para você mesmo no futuro).

Em resumo, o YAML é a escolha ideal para o Ansible porque ele equilibra simplicidade e poder, permitindo que os usuários escrevam automações complexas de forma legível e eficiente. Dominar o YAML é, portanto, um passo fundamental para se tornar proficiente em Ansible.



## Sintaxe Básica do YAML: Pares Chave-Valor, Listas e Dicionários

A sintaxe do YAML é construída sobre três estruturas básicas: pares chave-valor, listas e dicionários. A combinação dessas estruturas, juntamente com a indentação, permite representar qualquer tipo de dado de forma hierárquica.

### 1. Pares Chave-Valor (Mappings/Dicionários)

O par chave-valor é o bloco de construção mais fundamental do YAML. Ele representa um mapeamento de uma chave única para um valor. Em Ansible, isso é usado para definir parâmetros de módulos, variáveis e configurações.

**Sintaxe:**
```yaml
chave: valor
```

**Regras Importantes:**
*   A chave é sempre uma string (texto).
*   O valor pode ser de qualquer tipo de dado (string, número, booleano, lista, dicionário, etc.).
*   Deve haver um **espaço** após os dois pontos (`:`) que separa a chave do valor. Isso é crucial e um erro comum para iniciantes.

**Exemplos:**
```yaml
servidor: webserver01
porta: 8080
producao: true
```

Você pode aninhar pares chave-valor para criar estruturas mais complexas, que são essencialmente dicionários dentro de dicionários. A indentação define essa hierarquia.

```yaml
configuracao:
  aplicacao: meu_app
  versao: 1.0.0
  ambiente: desenvolvimento
```

Neste exemplo, `aplicacao`, `versao` e `ambiente` são chaves aninhadas sob a chave `configuracao`.

### 2. Listas (Sequences/Arrays)

Listas são coleções ordenadas de itens. Em YAML, os itens de uma lista são indicados por um hífen (`-`) seguido de um espaço, e cada item da lista deve estar em uma nova linha e no mesmo nível de indentação.

**Sintaxe:**
```yaml
- item1
- item2
- item3
```

**Exemplos:**
```yaml
pacotes_essenciais:
  - nginx
  - mariadb-server
  - php-fpm
```

Listas podem conter qualquer tipo de dado, incluindo dicionários. Isso é muito comum em playbooks Ansible, onde uma lista de tarefas é, na verdade, uma lista de dicionários (cada dicionário representando uma tarefa).

```yaml
usuarios:
  - nome: alice
    uid: 1001
    shell: /bin/bash
  - nome: bob
    uid: 1002
    shell: /bin/sh
```

Neste exemplo, `usuarios` é uma lista, e cada item da lista é um dicionário que descreve um usuário.

### 3. Dicionários (Mappings) e Listas Aninhadas

A combinação de dicionários e listas aninhadas é o que permite ao YAML representar estruturas de dados complexas e flexíveis, essenciais para a definição de playbooks Ansible.

**Exemplo de Estrutura Complexa:**
```yaml
servidores:
  - nome: webserver01
    ip: 192.168.1.10
    servicos:
      - http
      - https
    tags:
      ambiente: producao
      funcao: web
  - nome: dbserver01
    ip: 192.168.1.20
    servicos:
      - mysql
    tags:
      ambiente: producao
      funcao: database
```

Neste exemplo:
*   `servidores` é uma lista.
*   Cada item da lista `servidores` é um dicionário que descreve um servidor.
*   Dentro de cada dicionário de servidor, `servicos` é uma lista de strings.
*   `tags` é um dicionário aninhado que contém pares chave-valor adicionais.

### A Importância Crucial da Indentação

Em YAML, a **indentação não é opcional; ela é a sintaxe**. A indentação define a estrutura hierárquica dos dados. Um erro de indentação é um erro de sintaxe e fará com que seu arquivo YAML seja inválido.

**Regras de Indentação:**
*   Use **apenas espaços** para indentação. **Nunca use tabulações.**
*   O número de espaços para cada nível de indentação deve ser **consistente** dentro do mesmo documento (geralmente 2 ou 4 espaços).
*   Cada nível de aninhamento deve ser mais indentado que o nível anterior.

**Exemplo de Indentação Correta vs. Incorreta:**

**Correto:**
```yaml
chave_principal:
  sub_chave_1: valor1
  sub_chave_2:
    - item_lista_1
    - item_lista_2
```

**Incorreto (mistura de espaços e tabs ou indentação inconsistente):**
```yaml
chave_principal:
	sub_chave_1: valor1 # Usando tabulação
  sub_chave_2:
   - item_lista_1 # Indentação inconsistente
   - item_lista_2
```

Ferramentas como editores de código (VS Code, Sublime Text) com plugins YAML podem ajudar a manter a indentação correta, mas é fundamental entender o princípio por trás dela. A indentação é o que permite ao Ansible interpretar corretamente a estrutura dos seus playbooks e variáveis, garantindo que as tarefas sejam executadas no contexto certo e com os parâmetros corretos.



## Tipos de Dados em YAML

Embora o YAML seja flexível na inferência de tipos de dados, é importante entender os tipos básicos que ele suporta, pois eles influenciam como os dados são interpretados e usados em seus playbooks Ansible.

### 1. Strings (Texto)

Strings são sequências de caracteres e são o tipo de dado mais comum. Em YAML, strings geralmente não precisam de aspas, a menos que contenham caracteres especiais (como `:`, `{`, `[`, `}`, `]`, `#`, `&`, `*`, `!`, `|`, `>`, `'`, `"`, `%`, `@`, `` ` ``), ou se começarem com um caractere que possa ser interpretado como outro tipo de dado (como um número ou um booleano).

**Exemplos:**
```yaml
mensagem: Olá, mundo!
servidor_nome: webserver-01
versao_app: "1.2.3" # Aspas são opcionais aqui, mas podem ser usadas para clareza
caminho_arquivo: /etc/nginx/nginx.conf
```

### 2. Números

YAML suporta números inteiros e de ponto flutuante. O tipo é inferido automaticamente.

**Exemplos:**
```yaml
porta_http: 80
quantidade_cpu: 4
preco_item: 19.99
pi_valor: 3.14159
```

### 3. Booleanos (Verdadeiro/Falso)

Valores booleanos representam `true` (verdadeiro) ou `false` (falso). YAML é bastante flexível na sua representação, aceitando várias formas.

**Exemplos:**
```yaml
habilitar_servico: true
ativar_debug: false
permitir_acesso: yes
desabilitar_log: no
```

As formas comuns incluem `true`, `True`, `TRUE`, `false`, `False`, `FALSE`, `yes`, `Yes`, `YES`, `no`, `No`, `NO`, `on`, `On`, `ON`, `off`, `Off`, `OFF`.

### 4. Nulos (Null)

Representa a ausência de um valor. É frequentemente usado para indicar que uma variável não tem um valor atribuído ou que um recurso deve ser removido.

**Exemplos:**
```yaml
valor_nulo: null
sem_valor: ~
```

### 5. Datas e Horas

YAML pode representar datas e horas no formato ISO 8601.

**Exemplos:**
```yaml
data_criacao: 2023-10-27
hora_evento: 14:30:00
data_hora_completa: 2023-10-27T14:30:00Z
```

### 6. Blocos Literais (`|`) e Dobrados (`>`)

Para strings longas ou que contêm quebras de linha, o YAML oferece sintaxes especiais para blocos de texto, que preservam ou dobram as quebras de linha.

*   **Bloco Literal (`|`):** Preserva todas as quebras de linha e espaços em branco. Útil para blocos de código, mensagens formatadas ou qualquer texto onde o layout é importante.

    ```yaml
    mensagem_multilinha: |
      Esta é a primeira linha.
      Esta é a segunda linha.
        Esta linha é indentada.
    ```
    Será interpretado como: `Esta é a primeira linha.\nEsta é a segunda linha.\n  Esta linha é indentada.\n`

*   **Bloco Dobrado (`>`):** Dobra as quebras de linha em um único espaço, a menos que haja uma linha em branco ou uma indentação maior. Útil para parágrafos longos onde o fluxo do texto é mais importante que as quebras de linha exatas.

    ```yaml
    paragrafo_longo: >
      Este é um parágrafo muito longo que
      será dobrado em uma única linha.

      Este é um novo parágrafo.
    ```
    Será interpretado como: `Este é um parágrafo muito longo que será dobrado em uma única linha.\nEste é um novo parágrafo.\n`

Ambos os estilos de bloco podem ter um indicador de tratamento de quebra de linha final (opcional): `+` para manter a quebra de linha final, `-` para remover a quebra de linha final, ou nenhum para um comportamento padrão (geralmente uma única quebra de linha final).

### 7. Comentários (`#`)

Comentários são linhas ignoradas pelo parser YAML e são usadas para adicionar notas e explicações ao seu código. Eles começam com o caractere `#`.

**Exemplos:**
```yaml
# Este é um comentário de linha única
chave: valor # Este é um comentário no final da linha

lista:
  - item1
  - item2 # Comentário para item2
```

Compreender esses tipos de dados e a forma como o YAML os representa é fundamental para escrever playbooks Ansible corretos e eficientes. A flexibilidade do YAML permite que você estruture seus dados de forma lógica e legível, facilitando a automação de tarefas complexas.



## Exemplos Práticos de YAML em Playbooks Ansible

Agora que você compreende a sintaxe básica e os tipos de dados do YAML, vamos ver como esses conceitos se traduzem em exemplos práticos dentro dos playbooks Ansible. A capacidade de estruturar dados de forma eficaz em YAML é o que permite ao Ansible ser tão poderoso e flexível.

### Exemplo 1: Variáveis e Estruturas Simples

Este playbook demonstra o uso de variáveis simples (string, número, booleano) e como elas são referenciadas em tarefas.

```yaml
---
- name: Exemplo de Variaveis Simples em YAML
  hosts: localhost
  gather_facts: false
  vars:
    nome_aplicacao: "MinhaApp"
    versao_aplicacao: 1.0
    habilitar_log: true

  tasks:
    - name: Exibir informações da aplicação
      ansible.builtin.debug:
        msg: "A aplicação {{ nome_aplicacao }} na versão {{ versao_aplicacao }} está com log {{ 'habilitado' if habilitar_log else 'desabilitado' }}."

    - name: Criar diretório de log se habilitado
      ansible.builtin.file:
        path: "/var/log/{{ nome_aplicacao | lower }}"
        state: directory
        mode: '0755'
      when: habilitar_log
```

**Explicação:**
*   A seção `vars` define variáveis com diferentes tipos de dados.
*   As variáveis são usadas nas tarefas, incluindo uma expressão condicional (`if/else`) para `habilitar_log` e um filtro (`| lower`) para `nome_aplicacao`.
*   A tarefa de criação de diretório é condicional, demonstrando como um booleano YAML pode controlar o fluxo do playbook.

### Exemplo 2: Listas de Itens

Listas são frequentemente usadas para iterar sobre um conjunto de itens, como pacotes a serem instalados ou serviços a serem gerenciados.

```yaml
---
- name: Exemplo de Listas em YAML
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    pacotes_web:
      - nginx
      - apache2
      - php-fpm

  tasks:
    - name: Instalar pacotes web usando loop
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      loop: "{{ pacotes_web }}"

    - name: Garantir que os serviços web estejam rodando
      ansible.builtin.service:
        name: "{{ item }}"
        state: started
        enabled: true
      loop:
        - nginx
        - apache2
```

**Explicação:**
*   A variável `pacotes_web` é uma lista de strings.
*   O `loop` itera sobre essa lista, instalando cada pacote individualmente.
*   O segundo loop demonstra a gestão de serviços, mostrando que nem todos os itens da lista original precisam ser usados em todas as tarefas.

### Exemplo 3: Dicionários Aninhados (Estruturas Complexas)

Dicionários aninhados são essenciais para representar configurações complexas, como usuários com múltiplas propriedades ou configurações de rede.

```yaml
---
- name: Exemplo de Dicionarios Aninhados em YAML
  hosts: localhost
  gather_facts: false
  become: true
  vars:
    configuracao_servidor:
      nome_host: "srv-prod-web01"
      ip_endereco: "192.168.1.100"
      servicos:
        ssh: { porta: 22, habilitado: true }
        http: { porta: 80, habilitado: true }
        https: { porta: 443, habilitado: false }
      administradores:
        - nome: "admin_local"
          uid: 1000
          grupos: ["sudo", "webadmin"]
        - nome: "monitor_user"
          uid: 1001
          grupos: ["monitor"]

  tasks:
    - name: Exibir nome do host
      ansible.builtin.debug:
        msg: "Configurando o host: {{ configuracao_servidor.nome_host }} ({{ configuracao_servidor.ip_endereco }})"

    - name: Criar administradores
      ansible.builtin.user:
        name: "{{ item.nome }}"
        uid: "{{ item.uid }}"
        groups: "{{ item.grupos | join(',') }}"
        state: present
      loop: "{{ configuracao_servidor.administradores }}"

    - name: Configurar servicos (exemplo com debug)
      ansible.builtin.debug:
        msg: "Servico {{ item.key }}: Porta {{ item.value.porta }}, Habilitado: {{ item.value.habilitado }}"
      loop: "{{ configuracao_servidor.servicos | dict2items }}"
      when: item.value.habilitado
```

**Explicação:**
*   A variável `configuracao_servidor` é um dicionário que contém outros dicionários (`servicos`) e listas de dicionários (`administradores`).
*   Acessamos valores aninhados usando a notação de ponto (`.`) como em `configuracao_servidor.nome_host`.
*   O loop para `administradores` itera sobre uma lista de dicionários, acessando as chaves de cada dicionário (`item.nome`, `item.uid`, `item.grupos`). O filtro `| join(',')` é usado para converter a lista de grupos em uma string separada por vírgulas.
*   O loop para `servicos` usa o filtro `| dict2items` para converter o dicionário `servicos` em uma lista de pares chave-valor, permitindo a iteração. Uma condicional `when` é usada para processar apenas serviços habilitados.

### Exemplo 4: Blocos Literais e Dobrados

Útil para gerenciar arquivos de configuração com conteúdo multilinha.

```yaml
---
- name: Exemplo de Blocos de Texto em YAML
  hosts: localhost
  gather_facts: false
  become: true

  tasks:
    - name: Criar arquivo de configuracao com bloco literal
      ansible.builtin.copy:
        content: |
          # Configuracao do Nginx
          server {
              listen 80;
              server_name example.com;
              location / {
                  root /var/www/html;
                  index index.html;
              }
          }
        dest: /tmp/nginx.conf
        mode: '0644'

    - name: Criar arquivo de mensagem com bloco dobrado
      ansible.builtin.copy:
        content: >
          Esta é uma mensagem longa que será
          formatada em uma única linha pelo YAML.
          As quebras de linha serão convertidas em espaços.

          Parágrafos separados por linhas em branco
          serão mantidos como parágrafos.
        dest: /tmp/mensagem.txt
        mode: '0644'
```

**Explicação:**
*   O primeiro exemplo usa o bloco literal (`|`) para copiar um arquivo de configuração do Nginx, preservando todas as quebras de linha e indentação internas.
*   O segundo exemplo usa o bloco dobrado (`>`) para criar um arquivo de texto onde as quebras de linha são convertidas em espaços, mas parágrafos separados por linhas em branco são mantidos.

Estes exemplos práticos demonstram a versatilidade do YAML e como ele é aplicado no Ansible para definir e gerenciar a infraestrutura de forma declarativa e eficiente. A prática constante com essas estruturas é a chave para dominar o YAML e, consequentemente, o Ansible.



## Conclusão

Parabéns! Você acaba de dominar os fundamentos do YAML, a linguagem essencial para escrever playbooks Ansible. Compreender a sintaxe de pares chave-valor, listas e dicionários, juntamente com a importância crítica da indentação, é o alicerce para qualquer automação com Ansible.

Você aprendeu que o YAML não é apenas uma linguagem de configuração, mas uma ferramenta poderosa para expressar estruturas de dados complexas de forma legível por humanos. Os exemplos práticos demonstraram como aplicar esses conceitos para gerenciar variáveis, iterar sobre listas e configurar sistemas de forma declarativa e eficiente.

Com este conhecimento, você está agora apto a ler, entender e, mais importante, escrever seus próprios arquivos YAML para playbooks Ansible. A prática contínua é fundamental; experimente criar seus próprios arquivos YAML, manipular diferentes estruturas e observar como o Ansible as interpreta. No próximo capítulo, começaremos a explorar módulos Ansible mais específicos e como eles interagem com as estruturas YAML que você agora domina. Sua jornada na automação com Ansible está cada vez mais sólida!

