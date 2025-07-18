# Capítulo 5: Agrupamento e Relação Pai-Filho

## O Conceito de Agrupamento de Hosts no Ansible

No Ansible, o **agrupamento de hosts** é a maneira fundamental de organizar sua infraestrutura para automação. Em vez de gerenciar cada servidor individualmente, você os categoriza em grupos lógicos com base em suas funções, ambientes, localização geográfica ou qualquer outra característica que faça sentido para sua operação. Essa organização é definida no seu arquivo de inventário e é a base para direcionar playbooks e aplicar configurações de forma eficiente.

### Por que Agrupar Hosts?

1.  **Direcionamento Eficiente:** Permite que você execute playbooks em um subconjunto específico de sua infraestrutura. Por exemplo, você pode ter um playbook para configurar servidores web e outro para servidores de banco de dados. Ao agrupar seus hosts, você pode simplesmente direcionar o playbook para o grupo `webservers` ou `databases`, em vez de listar cada IP ou nome de host individualmente.
2.  **Gerenciamento de Configuração Consistente:** Garante que todos os hosts com uma função específica recebam a mesma configuração. Se você tem 10 servidores web, é muito mais fácil aplicar uma atualização de segurança ou uma nova configuração a todos eles de uma vez, direcionando o playbook para o grupo `webservers`.
3.  **Reutilização de Playbooks:** Playbooks podem ser escritos de forma mais genérica. Em vez de codificar nomes de hosts, você usa nomes de grupos, tornando o playbook reutilizável em diferentes ambientes (desenvolvimento, staging, produção) ou em diferentes clientes, desde que o inventário esteja corretamente estruturado.
4.  **Definição de Variáveis:** Variáveis podem ser definidas em nível de grupo, o que significa que todos os hosts dentro desse grupo herdarão essas variáveis. Isso reduz a duplicação de código e simplifica a gestão de configurações que são comuns a um conjunto de máquinas.
5.  **Escalabilidade:** À medida que sua infraestrutura cresce, o agrupamento se torna indispensável. Adicionar um novo servidor a um grupo existente significa que ele automaticamente receberá todas as configurações e playbooks aplicáveis a esse grupo, sem a necessidade de modificar playbooks.

### Como Agrupar Hosts no Inventário

Conforme vimos no capítulo de Inventários, você pode agrupar hosts usando os formatos INI ou YAML. A sintaxe é simples:

**Formato INI:**
```ini
[nome_do_grupo]
host1.example.com
host2.example.com
```

**Formato YAML:**
```yaml
all:
  children:
    nome_do_grupo:
      hosts:
        host1.example.com:
        host2.example.com:
```

### Exemplo Prático de Agrupamento:

Considere uma aplicação de três camadas: servidores web, servidores de aplicação e servidores de banco de dados.

**`inventory.ini`:**
```ini
[webservers]
web01.example.com
web02.example.com

[appservers]
app01.example.com
app02.example.com

[databases]
db01.example.com
```

Com este inventário, você pode executar um playbook apenas nos servidores web:

```bash
ansible-playbook -i inventory.ini web_config.yml --limit webservers
```

Ou em todos os servidores de aplicação:

```bash
ansible-playbook -i inventory.ini app_deploy.yml --limit appservers
```

O agrupamento é o primeiro passo para construir uma automação Ansible robusta e organizada, permitindo que você gerencie sua infraestrutura de forma modular e escalável.



## A Relação Pai-Filho entre Grupos (Children)

Além de simplesmente agrupar hosts, o Ansible permite criar hierarquias de grupos, onde um grupo pode ser "filho" de outro grupo. Essa funcionalidade, conhecida como **grupos de grupos** ou **relação pai-filho**, é fundamental para organizar inventários complexos e gerenciar a herança de variáveis de forma eficiente.

### Como Funciona a Relação Pai-Filho

Quando um grupo é definido como `children` de outro grupo, todos os hosts que pertencem ao grupo filho (direta ou indiretamente) também são considerados membros do grupo pai. Isso cria uma estrutura hierárquica onde as variáveis e configurações definidas no grupo pai são automaticamente herdadas pelos grupos filhos e seus respectivos hosts.

**Sintaxe no Inventário INI:**
```ini
[grupo_pai:children]
grupo_filho1
grupo_filho2
```

**Sintaxe no Inventário YAML:**
```yaml
all:
  children:
    grupo_pai:
      children:
        grupo_filho1:
        grupo_filho2:
```

### Vantagens da Relação Pai-Filho:

1.  **Herança de Variáveis Simplificada:** A principal vantagem é a herança automática de variáveis. Variáveis definidas em um grupo pai se aplicam a todos os hosts em seus grupos filhos. Isso evita a duplicação de variáveis e garante consistência em configurações comuns a um segmento maior da sua infraestrutura.
2.  **Organização Lógica Aprimorada:** Permite modelar sua infraestrutura de forma mais granular e lógica. Por exemplo, você pode ter grupos para ambientes (`production`, `development`), regiões (`us_east`, `eu_west`) e, dentro deles, grupos para funções (`webservers`, `databases`).
3.  **Direcionamento Flexível:** Você pode direcionar playbooks para um grupo pai, e o Ansible executará as tarefas em todos os hosts dos grupos filhos. Isso simplifica a execução de tarefas em grandes conjuntos de máquinas.

### Exemplo Prático de Relação Pai-Filho:

Vamos expandir o exemplo anterior para incluir ambientes de produção e desenvolvimento.

**`inventory.ini`:**
```ini
[webservers]
web01.example.com
web02.example.com

[appservers]
app01.example.com
app02.example.com

[databases]
db01.example.com

# Grupos de ambiente
[production:children]
webservers
appservers
databases

[development:children]
dev_webservers
dev_appservers
dev_databases

[dev_webservers]
devweb01.example.com

[dev_appservers]
devapp01.example.com

[dev_databases]
devdb01.example.com

# Variaveis de ambiente
[production:vars]
ambiente=producao
backup_strategy=full_daily

[development:vars]
ambiente=desenvolvimento
backup_strategy=incremental_weekly
```

**`inventory.yml` (equivalente):**
```yaml
all:
  children:
    production:
      children:
        webservers:
          hosts:
            web01.example.com:
            web02.example.com:
        appservers:
          hosts:
            app01.example.com:
            app02.example.com:
        databases:
          hosts:
            db01.example.com:
      vars:
        ambiente: producao
        backup_strategy: full_daily
    development:
      children:
        dev_webservers:
          hosts:
            devweb01.example.com:
        dev_appservers:
          hosts:
            devapp01.example.com:
        dev_databases:
          hosts:
            devdb01.example.com:
      vars:
        ambiente: desenvolvimento
        backup_strategy: incremental_weekly
```

Neste exemplo:
*   `production` e `development` são grupos pais.
*   `webservers`, `appservers`, `databases` são grupos filhos de `production`.
*   `dev_webservers`, `dev_appservers`, `dev_databases` são grupos filhos de `development`.
*   Variáveis como `ambiente` e `backup_strategy` são definidas nos grupos pais e são herdadas por todos os hosts dentro de seus respectivos ambientes.

Você pode então executar um playbook para todos os servidores de produção:

```bash
ansible-playbook -i inventory.ini deploy_app.yml --limit production
```

E o Ansible aplicará as configurações apropriadas, incluindo as variáveis herdadas do grupo `production`, a todos os hosts dentro dos grupos `webservers`, `appservers` e `databases`.

### Precedência de Variáveis em Grupos Aninhados

É crucial entender que as variáveis definidas em grupos mais específicos (grupos filhos) têm precedência sobre as variáveis definidas em grupos mais genéricos (grupos pais). A regra geral é: **quanto mais específico o grupo, maior a precedência de suas variáveis**.

Por exemplo, se você definir `http_port=80` no grupo `webservers` e `http_port=8080` no grupo `production` (que é pai de `webservers`), a variável `http_port=80` do grupo `webservers` terá precedência para os hosts nesse grupo. No entanto, se um host não estiver em `webservers` mas estiver em outro grupo filho de `production` que não define `http_port`, ele herdará `http_port=8080` de `production`.

Essa hierarquia de herança de variáveis é uma das características mais poderosas do Ansible, permitindo uma gestão de configuração flexível e escalável, mas exige um bom planejamento da estrutura do seu inventário.



## A Importância da Organização do Inventário para Escalabilidade

À medida que sua infraestrutura cresce e se torna mais complexa, a organização do seu inventário Ansible deixa de ser uma conveniência e se torna uma necessidade crítica. Um inventário bem estruturado é a base para uma automação escalável, manutenível e compreensível.

### Benefícios de um Inventário Bem Organizado:

1.  **Clareza e Compreensão:** Um inventário lógico e bem nomeado torna imediatamente claro quais hosts pertencem a quais grupos e qual é a função de cada grupo. Isso é vital para equipes grandes ou para quando novos membros se juntam ao projeto.
2.  **Redução de Erros:** A organização clara e a herança de variáveis minimizam a chance de aplicar configurações incorretas a hosts errados. Variáveis definidas no nível apropriado garantem que as configurações corretas sejam aplicadas onde são necessárias.
3.  **Facilidade de Manutenção:** Quando a infraestrutura muda (novos servidores são adicionados, funções são alteradas, ambientes são criados), um inventário organizado facilita a atualização. Adicionar um novo host a um grupo existente é muito mais simples do que atualizar manualmente dezenas de playbooks.
4.  **Reutilização e Modularidade:** Um inventário bem estruturado permite que você crie playbooks e roles mais genéricos e reutilizáveis. Em vez de escrever playbooks específicos para cada servidor, você escreve para grupos de funções, e o inventário se encarrega de mapear esses grupos para os hosts reais.
5.  **Desempenho:** Embora não seja o fator mais crítico para pequenos inventários, um inventário otimizado (especialmente dinâmicos) pode impactar o desempenho da execução do Ansible, pois ele precisa processar o inventário antes de cada execução.
6.  **Integração com Ferramentas Externas:** Um inventário bem definido facilita a integração do Ansible com outras ferramentas de monitoramento, CMDBs ou sistemas de provisionamento, pois a estrutura de dados é consistente e previsível.

### Estratégias de Organização:

*   **Por Função:** Agrupe hosts pela função que desempenham (e.g., `webservers`, `dbservers`, `loadbalancers`).
*   **Por Ambiente:** Separe hosts por ambiente (e.g., `development`, `staging`, `production`). Use grupos de grupos para aninhar funções dentro de ambientes.
*   **Por Localização Geográfica:** Para infraestruturas distribuídas, agrupe por data center ou região (e.g., `us_east`, `eu_west`).
*   **Por Aplicação:** Se você tem múltiplas aplicações, agrupe hosts por aplicação (e.g., `app_a_servers`, `app_b_servers`).
*   **Uso de `host_vars` e `group_vars`:** Conforme discutido no capítulo anterior, utilize esses diretórios para manter as variáveis fora do arquivo principal do inventário, tornando-o mais limpo e legível.

Um inventário bem pensado é um investimento que compensa enormemente à medida que sua automação e infraestrutura crescem. Ele é a fundação sobre a qual você construirá automações Ansible robustas e escaláveis.



## Exemplos Práticos de Agrupamento e Relação Pai-Filho

Para solidificar a compreensão sobre agrupamento e a relação pai-filho, vamos explorar exemplos práticos de inventários e playbooks que demonstram esses conceitos em ação.

### Exemplo 1: Inventário com Grupos Aninhados (INI)

Este exemplo mostra um inventário INI com uma estrutura de ambiente e função.

**`inventory_nested.ini`:**
```ini
[webservers]
web01.prod.example.com
web02.prod.example.com

[databases]
db01.prod.example.com

[appservers]
app01.prod.example.com

[prod_region_us_east:children]
webservers
databases
appservers

[dev_webservers]
devweb01.dev.example.com

[dev_databases]
devdb01.dev.example.com

[dev_region_us_east:children]
dev_webservers
dev_databases

[all:vars]
ansible_user=ansible_admin
ansible_ssh_private_key_file=~/.ssh/id_rsa_ansible

[prod_region_us_east:vars]
ambiente=producao
firewall_rules=strict

[dev_region_us_east:vars]
ambiente=desenvolvimento
firewall_rules=lenient

[webservers:vars]
http_port=80
https_port=443
```

**Explicação:**
*   `prod_region_us_east` e `dev_region_us_east` são grupos pais que contêm grupos de função como `children`.
*   Variáveis como `ambiente` e `firewall_rules` são definidas nos grupos pais e serão herdadas por todos os hosts em seus grupos filhos.
*   `webservers:vars` define variáveis específicas para o grupo `webservers`.

### Exemplo 2: Inventário com Grupos Aninhados (YAML)

O equivalente YAML do inventário anterior, que é mais legível para estruturas complexas.

**`inventory_nested.yml`:**
```yaml
all:
  children:
    prod_region_us_east:
      children:
        webservers:
          hosts:
            web01.prod.example.com:
            web02.prod.example.com:
        databases:
          hosts:
            db01.prod.example.com:
        appservers:
          hosts:
            app01.prod.example.com:
      vars:
        ambiente: producao
        firewall_rules: strict
    dev_region_us_east:
      children:
        dev_webservers:
          hosts:
            devweb01.dev.example.com:
        dev_databases:
          hosts:
            devdb01.dev.example.com:
      vars:
        ambiente: desenvolvimento
        firewall_rules: lenient
  vars:
    ansible_user: ansible_admin
    ansible_ssh_private_key_file: ~/.ssh/id_rsa_ansible

webservers:
  vars:
    http_port: 80
    https_port: 443
```

**Explicação:**
*   A estrutura `children` aninhada define claramente a relação pai-filho.
*   Variáveis são definidas nos níveis apropriados, aproveitando a herança.

### Exemplo 3: Playbook Demonstrando Herança de Variáveis

Este playbook usará o inventário `inventory_nested.yml` (ou `.ini`) para demonstrar como as variáveis são herdadas.

**`check_vars.yml`:**
```yaml
---
- name: Verificar Variaveis Herdadas
  hosts: all
  gather_facts: false
  tasks:
    - name: Exibir informacoes do host e ambiente
      ansible.builtin.debug:
        msg: |
          Host: {{ inventory_hostname }}
          Ambiente: {{ ambiente | default("Nao definido") }}
          Regras de Firewall: {{ firewall_rules | default("Nao definido") }}
          Porta HTTP: {{ http_port | default("Nao definido") }}

    - name: Exibir informacoes especificas para webservers
      ansible.builtin.debug:
        msg: "{{ inventory_hostname }} e um webserver com porta HTTP {{ http_port }}."
      when: "webservers" in group_names
```

**Como Executar:**
```bash
ansible-playbook -i inventory_nested.yml check_vars.yml
```

**Saída Esperada (parcial, para `web01.prod.example.com`):**
```
TASK [Exibir informacoes do host e ambiente] ***********************************
ok: [web01.prod.example.com] => {
    


    "msg": "Host: web01.prod.example.com\nAmbiente: producao\nRegras de Firewall: strict\nPorta HTTP: 80"
}

TASK [Exibir informacoes especificas para webservers] **************************
ok: [web01.prod.example.com] => {
    "msg": "web01.prod.example.com e um webserver com porta HTTP 80."
}
```

**Observações:**
*   O host `web01.prod.example.com` herda `ambiente: producao` e `firewall_rules: strict` do grupo pai `prod_region_us_east`.
*   Ele também herda `http_port: 80` do grupo `webservers`.
*   A segunda tarefa só é executada para hosts que são membros do grupo `webservers` (usando `when: "webservers" in group_names`).

### Exemplo 4: Direcionando Playbooks para Grupos Pais e Filhos

Você pode direcionar seus playbooks para qualquer grupo definido no seu inventário, seja ele um grupo de hosts ou um grupo de grupos.

**Playbook: `deploy_common_config.yml`**
Este playbook aplica uma configuração comum a todos os servidores de produção.

```yaml
---
- name: Aplicar Configuracao Comum em Producao
  hosts: prod_region_us_east # Direcionado ao grupo pai
  become: true
  tasks:
    - name: Instalar pacote comum (ex: htop)
      ansible.builtin.package:
        name: htop
        state: present

    - name: Exibir variavel de ambiente
      ansible.builtin.debug:
        msg: "Aplicando configuracao para o ambiente: {{ ambiente }}"
```

**Como Executar:**
```bash
ansible-playbook -i inventory_nested.yml deploy_common_config.yml
```

**Explicação:**
*   Ao direcionar `hosts: prod_region_us_east`, o playbook será executado em `web01.prod.example.com`, `web02.prod.example.com`, `db01.prod.example.com` e `app01.prod.example.com`.
*   A variável `ambiente` será resolvida para `producao` para todos esses hosts, demonstrando a herança do grupo pai.

**Playbook: `update_web_servers.yml`**
Este playbook aplica atualizações específicas apenas aos servidores web de produção.

```yaml
---
- name: Atualizar Servidores Web de Producao
  hosts: webservers # Direcionado ao grupo filho
  become: true
  tasks:
    - name: Atualizar pacote Nginx
      ansible.builtin.package:
        name: nginx
        state: latest

    - name: Exibir porta HTTP configurada
      ansible.builtin.debug:
        msg: "Nginx configurado na porta: {{ http_port }}"
```

**Como Executar:**
```bash
ansible-playbook -i inventory_nested.yml update_web_servers.yml
```

**Explicação:**
*   Ao direcionar `hosts: webservers`, o playbook será executado apenas em `web01.prod.example.com` e `web02.prod.example.com`.
*   A variável `http_port` será resolvida para `80`, conforme definido no grupo `webservers`.

### Exemplo 5: Visualizando a Hierarquia com `ansible-inventory --graph`

Para verificar visualmente a estrutura do seu inventário, especialmente com grupos aninhados, o comando `ansible-inventory --graph` é extremamente útil.

**Comando:**
```bash
ansible-inventory -i inventory_nested.yml --graph
```

**Saída Esperada:**
```
@all:
  |--@dev_region_us_east:
  |  |--@dev_databases:
  |  |  |--devdb01.dev.example.com
  |  |--@dev_webservers:
  |  |  |--devweb01.dev.example.com
  |--@prod_region_us_east:
  |  |--@appservers:
  |  |  |--app01.prod.example.com
  |  |--@databases:
  |  |  |--db01.prod.example.com
  |  |--@webservers:
  |  |  |--web01.prod.example.com
  |  |  |--web02.prod.example.com
  |--@ungrouped:
```

**Explicação:**
*   A saída mostra claramente a hierarquia: `all` contém `dev_region_us_east` e `prod_region_us_east`.
*   Dentro de `dev_region_us_east`, você vê `dev_databases` e `dev_webservers` como filhos, e seus respectivos hosts.
*   O mesmo para `prod_region_us_east` com `appservers`, `databases` e `webservers`.
*   `ungrouped` lista quaisquer hosts que não foram explicitamente atribuídos a um grupo.

Esses exemplos práticos demonstram como o agrupamento e a relação pai-filho são ferramentas poderosas para organizar e gerenciar sua infraestrutura com Ansible, permitindo automações mais flexíveis, escaláveis e fáceis de manter.

