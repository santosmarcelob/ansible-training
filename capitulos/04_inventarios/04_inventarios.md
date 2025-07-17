# Capítulo 4: Inventários

## Questionário: https://forms.gle/KU1QmcqXJYigrGbu9

## O que é um Inventário Ansible e Seu Propósito

No mundo da automação, saber *onde* e *em quais sistemas* executar suas tarefas é tão crucial quanto saber *o que* fazer. É aqui que o conceito de **Inventário** entra em jogo no Ansible. O inventário é, em sua essência, um arquivo (ou um conjunto de arquivos) que define os hosts (servidores, dispositivos de rede, máquinas virtuais, etc.) que o Ansible irá gerenciar. Ele serve como a fonte da verdade para todas as informações sobre sua infraestrutura.

### Propósito do Inventário:

1.  **Definição de Hosts:** O inventário lista todos os hosts que o Ansible pode alcançar e interagir. Sem um inventário, o Ansible não saberia onde executar os playbooks.
2.  **Organização de Hosts:** Ele permite agrupar hosts logicamente (por exemplo, `webservers`, `databases`, `dev`, `prod`). Essa organização é fundamental para aplicar configurações a conjuntos específicos de máquinas, em vez de ter que listar cada host individualmente em cada playbook.
3.  **Definição de Variáveis:** O inventário é um local central para definir variáveis que são específicas para hosts individuais ou para grupos de hosts. Isso permite que você personalize o comportamento dos playbooks sem modificar o playbook em si, tornando-o mais genérico e reutilizável.
4.  **Gerenciamento de Conexão:** Você pode especificar informações de conexão (como usuário SSH, porta, chave privada) diretamente no inventário, simplificando a forma como o Ansible se conecta aos seus hosts.

Imagine o inventário como um catálogo telefônico da sua infraestrutura, onde cada entrada é um host e você pode organizar essas entradas em seções (grupos) e adicionar notas (variáveis) sobre cada uma. Essa estrutura permite que o Ansible execute tarefas de forma direcionada e eficiente, aplicando as configurações certas nos lugares certos.



## Inventários Estáticos: Formatos INI e YAML

Inventários estáticos são arquivos de texto simples onde você define manualmente seus hosts e grupos. Eles são ideais para ambientes menores ou para quando a infraestrutura não muda com frequência. O Ansible suporta dois formatos principais para inventários estáticos: INI e YAML.

### Formato INI

O formato INI é o mais tradicional e se assemelha a um arquivo de configuração clássico. Ele usa seções para definir grupos e listas de hosts.

**Exemplo de Inventário INI (`inventory.ini`):**
```ini
# Hosts individuais
server1.example.com
server2.example.com

# Grupos de hosts
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com
db2.example.com

# Hosts com portas não padrão
[routers]
router1.example.com:2222
router2.example.com ansible_port=2222

# Variáveis de grupo
[webservers:vars]
http_port=80
max_clients=200

[databases:vars]
db_type=mysql
db_version=8.0

# Variáveis de host específicas
web1.example.com ansible_user=ubuntu
db1.example.com ansible_user=root
```

**Explicação:**
*   Hosts podem ser listados individualmente ou sob um cabeçalho de grupo (`[nome_do_grupo]`).
*   Variáveis de host podem ser definidas na mesma linha do host (`router2.example.com ansible_port=2222`) ou em uma linha separada (`web1.example.com ansible_user=ubuntu`).
*   Variáveis de grupo são definidas em uma seção `[nome_do_grupo:vars]`. Essas variáveis se aplicam a todos os hosts dentro desse grupo.

### Formato YAML

O formato YAML é mais moderno e oferece maior flexibilidade para estruturas de dados complexas, sendo o formato preferido para inventários mais elaborados e para consistência com os playbooks. Ele usa a estrutura de dicionários e listas do YAML.

**Exemplo de Inventário YAML (`inventory.yml`):**
```yaml
all:
  hosts:
    server1.example.com:
    server2.example.com:
  children:
    webservers:
      hosts:
        web1.example.com:
        web2.example.com:
      vars:
        http_port: 80
        max_clients: 200
    databases:
      hosts:
        db1.example.com:
        db2.example.com:
      vars:
        db_type: mysql
        db_version: 8.0

# Variáveis de host específicas podem ser definidas aqui também
web1.example.com:
  ansible_user: ubuntu
db1.example.com:
  ansible_user: root
```

**Explicação:**
*   O nó raiz é `all`, que pode conter `hosts` (para hosts não agrupados) e `children` (para grupos).
*   Cada grupo (`webservers`, `databases`) é definido sob `children` e pode conter sua própria seção `hosts` e `vars`.
*   A sintaxe YAML permite uma representação mais clara de estruturas aninhadas e variáveis complexas.

### Qual formato usar?

Ambos os formatos são válidos. O formato INI é mais conciso para inventários simples, enquanto o YAML é mais expressivo e flexível para inventários complexos, especialmente quando você precisa definir muitas variáveis ou estruturas de dados aninhadas. Para novos projetos, o formato YAML é geralmente recomendado devido à sua consistência com os playbooks e sua capacidade de lidar com estruturas de dados mais ricas.

Dica Prática: Para exercitar:

Reescreva o exemplo em INI no formato YAML.

Crie um inventário com 2 grupos (web e db), definindo 1 variável por grupo e 1 variável por host.


## Variáveis de Host e de Grupo

Uma das características mais poderosas do inventário Ansible é a capacidade de definir variáveis em diferentes níveis: para hosts individuais ou para grupos de hosts. Isso permite que você crie playbooks genéricos que se adaptam a diferentes ambientes e configurações sem a necessidade de modificá-los.

### Variáveis de Host

Variáveis de host são específicas para um único host. Elas podem ser definidas diretamente no arquivo de inventário, em arquivos separados no diretório `host_vars/`, ou passadas via linha de comando.

**Definição no Inventário (INI):**
```ini
[webservers]
web1.example.com ansible_user=ubuntu http_port=80
web2.example.com ansible_user=ec2-user http_port=443
```

**Definição no Inventário (YAML):**
```yaml
web1.example.com:
  ansible_user: ubuntu
  http_port: 80
web2.example.com:
  ansible_user: ec2-user
  http_port: 443
```

**Definição em `host_vars/`:**
Para uma organização melhor, especialmente em inventários grandes, você pode criar um diretório `host_vars/` no mesmo nível do seu inventário. Dentro dele, crie um arquivo YAML com o nome exato do host (por exemplo, `host_vars/web1.example.com.yml`).

**`host_vars/web1.example.com.yml`:**
```yaml
ansible_user: ubuntu
http_port: 80
ambiente: producao
```

### Variáveis de Grupo

Variáveis de grupo se aplicam a todos os hosts que pertencem a um determinado grupo. Elas são ideais para configurações que são comuns a um conjunto de servidores, como credenciais de banco de dados, versões de software ou configurações de firewall.

**Definição no Inventário (INI):**
```ini
[webservers]
web1.example.com
web2.example.com

[webservers:vars]
servidor_web_padrao=nginx
firewall_habilitado=true
```

**Definição no Inventário (YAML):**
```yaml
all:
  children:
    webservers:
      hosts:
        web1.example.com:
        web2.example.com:
      vars:
        servidor_web_padrao: nginx
        firewall_habilitado: true
```

**Definição em `group_vars/`:**
Similar a `host_vars/`, você pode criar um diretório `group_vars/` e, dentro dele, um arquivo YAML com o nome exato do grupo (por exemplo, `group_vars/webservers.yml`).

**`group_vars/webservers.yml`:**
```yaml
servidor_web_padrao: nginx
firewall_habilitado: true
```

### Precedência de Variáveis

É importante entender a ordem de precedência das variáveis no Ansible, pois uma variável definida em um nível pode sobrescrever outra definida em um nível diferente. A ordem geral (do menos para o mais prioritário) é:

1.  Variáveis de Role padrão
2.  Variáveis de Inventário (definidas no `inventory.ini` ou `inventory.yml`)
3.  Variáveis de `group_vars/all`
4.  Variáveis de `group_vars/` (específicas do grupo)
5.  Variáveis de `host_vars/` (específicas do host)
6.  Variáveis de Role
7.  Variáveis de Playbook (`vars:` seção)
8.  Variáveis de Linha de Comando (`-e`)

Isso significa que uma variável definida em `host_vars/` terá precedência sobre uma definida em `group_vars/`, e uma variável passada via linha de comando (`-e`) terá a maior precedência de todas. Compreender essa hierarquia é fundamental para evitar comportamentos inesperados em seus playbooks.



## Grupos de Grupos

Para ambientes maiores e mais complexos, o Ansible permite que você organize seus hosts em uma hierarquia, onde grupos podem conter outros grupos. Isso é conhecido como "grupos de grupos" e é uma ferramenta poderosa para gerenciar infraestruturas em larga escala, permitindo uma aplicação mais granular de variáveis e configurações.

### Estrutura de Grupos de Grupos

Você pode definir grupos que são "filhos" de outros grupos. Isso é particularmente útil para categorizar hosts com base em funções, ambientes ou localizações geográficas.

**Exemplo de Inventário INI com Grupos de Grupos:**
```ini
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com
db2.example.com

[app_servers]
app1.example.com
app2.example.com

[production:children]
webservers
databases
app_servers

[development:children]
dev_web
dev_db

[dev_web]
devweb1.example.com

[dev_db]
devdb1.example.com

[all:vars]
ansible_user=ansible_admin

[production:vars]
ambiente=producao
backup_schedule=daily

[development:vars]
ambiente=desenvolvimento
backup_schedule=weekly
```

**Explicação:**
*   Os grupos `webservers`, `databases` e `app_servers` contêm hosts específicos.
*   O grupo `production` é um "grupo pai" que inclui os grupos `webservers`, `databases` e `app_servers` como seus "filhos" (indicado por `:children`). Isso significa que qualquer host que seja membro de `webservers`, `databases` ou `app_servers` também é implicitamente um membro de `production`.
*   Variáveis definidas para o grupo `production` (como `ambiente=producao`) serão herdadas por todos os hosts nos grupos `webservers`, `databases` e `app_servers`.
*   Você pode ter múltiplos níveis de aninhamento de grupos, criando uma hierarquia complexa conforme a necessidade.

**Exemplo de Inventário YAML com Grupos de Grupos:**
```yaml
all:
  children:
    production:
      children:
        webservers:
          hosts:
            web1.example.com:
            web2.example.com:
        databases:
          hosts:
            db1.example.com:
            db2.example.com:
        app_servers:
          hosts:
            app1.example.com:
            app2.example.com:
      vars:
        ambiente: producao
        backup_schedule: daily
    development:
      children:
        dev_web:
          hosts:
            devweb1.example.com:
        dev_db:
          hosts:
            devdb1.example.com:
      vars:
        ambiente: desenvolvimento
        backup_schedule: weekly
  vars:
    ansible_user: ansible_admin
```

**Explicação:**
*   A estrutura YAML torna a hierarquia de grupos de grupos mais explícita e fácil de visualizar.
*   `production` e `development` são grupos pais, e cada um contém seus próprios `children` (grupos filhos) e `vars`.

### Vantagens dos Grupos de Grupos:

*   **Organização Lógica:** Permite modelar sua infraestrutura de forma mais precisa, refletindo a estrutura organizacional ou ambiental.
*   **Herança de Variáveis:** Variáveis definidas em um grupo pai são automaticamente herdadas por todos os seus grupos filhos e hosts, reduzindo a duplicação e simplificando o gerenciamento de configurações comuns.
*   **Segmentação de Playbooks:** Facilita a execução de playbooks em grandes segmentos da sua infraestrutura (por exemplo, `hosts: production`) sem precisar listar todos os grupos ou hosts individualmente.

O uso de grupos de grupos é uma prática recomendada para gerenciar a complexidade em ambientes Ansible maiores, garantindo que as configurações sejam aplicadas de forma consistente e eficiente em toda a sua infraestrutura.



## Inventários Dinâmicos

Enquanto os inventários estáticos são adequados para ambientes menores e mais estáveis, em infraestruturas dinâmicas (como ambientes de nuvem, contêineres ou máquinas virtuais que são frequentemente provisionadas e desprovisionadas), manter um inventário manual se torna impraticável. É aqui que entram os **Inventários Dinâmicos**.

Um inventário dinâmico é um script ou programa executável que o Ansible pode chamar para obter uma lista de hosts e suas variáveis em tempo real. Esses scripts podem se integrar com APIs de provedores de nuvem (AWS EC2, Azure, Google Cloud, OpenStack), sistemas de CMDB (Configuration Management Database), ferramentas de virtualização (VMware vCenter), ou qualquer outra fonte de dados que possa fornecer informações sobre sua infraestrutura.

### Como Funcionam os Inventários Dinâmicos:

Quando o Ansible é executado com um script de inventário dinâmico, ele espera que o script retorne uma estrutura de dados JSON que representa o inventário. Essa estrutura JSON deve conter:

*   Uma lista de todos os hosts.
*   Informações sobre quais grupos cada host pertence.
*   Variáveis específicas de host e de grupo.

**Exemplo Conceitual de Saída JSON de um Inventário Dinâmico:**
```json
{
  "webservers": {
    "hosts": [
      "ec2-1-2-3-4.compute-1.amazonaws.com",
      "ec2-5-6-7-8.compute-1.amazonaws.com"
    ],
    "vars": {
      "ansible_user": "ec2-user"
    }
  },
  "databases": {
    "hosts": [
      "db-prod-01.example.com"
    ],
    "vars": {
      "db_port": 5432
    }
  },
  "_meta": {
    "hostvars": {
      "ec2-1-2-3-4.compute-1.amazonaws.com": {
        "instance_id": "i-0abcdef12345",
        "private_ip": "10.0.0.10"
      }
    }
  }
}
```

### Vantagens dos Inventários Dinâmicos:

*   **Atualização em Tempo Real:** O inventário está sempre atualizado com o estado atual da sua infraestrutura, sem intervenção manual.
*   **Escalabilidade:** Essencial para ambientes que escalam automaticamente ou onde as máquinas são efêmeras.
*   **Precisão:** Reduz erros humanos associados à manutenção manual de inventários.
*   **Integração:** Permite que o Ansible se integre perfeitamente com outras ferramentas e sistemas de gerenciamento de infraestrutura.

### Boas Práticas para Organização de Inventários

Independentemente de você usar inventários estáticos ou dinâmicos, algumas boas práticas podem ajudar a manter seu inventário organizado e eficiente:

1.  **Use Grupos Lógicos:** Organize seus hosts em grupos que façam sentido para sua aplicação ou infraestrutura (por exemplo, `webservers`, `databases`, `dev`, `prod`, `region_us_east`).
2.  **Separe Variáveis:** Utilize os diretórios `host_vars/` e `group_vars/` para armazenar variáveis. Isso mantém o inventário principal limpo e facilita a gestão de variáveis complexas.
    *   `group_vars/all.yml`: Para variáveis que se aplicam a todos os hosts.
    *   `group_vars/<group_name>.yml`: Para variáveis específicas de um grupo.
    *   `host_vars/<host_name>.yml`: Para variáveis específicas de um host.
3.  **Controle de Versão:** Mantenha seus arquivos de inventário (e `host_vars`/`group_vars`) sob controle de versão (Git é o mais comum). Isso permite rastrear mudanças, reverter para versões anteriores e colaborar em equipe.
4.  **Comentários:** Adicione comentários explicativos em seus arquivos de inventário, especialmente para variáveis ou agrupamentos complexos.
5.  **Evite Variáveis Sensíveis:** Não armazene senhas ou outras informações sensíveis diretamente no inventário. Use o Ansible Vault para criptografar esses dados.
6.  **Use `ansible-inventory`:** Utilize o comando `ansible-inventory --list` ou `ansible-inventory --graph` para visualizar a estrutura do seu inventário e verificar se ele está sendo interpretado corretamente pelo Ansible.

**Exemplo de Estrutura de Diretórios Recomendada:**
```
meu_projeto_ansible/
├── ansible.cfg
├── inventory.ini  # ou inventory.yml
├── group_vars/
│   ├── all.yml
│   ├── webservers.yml
│   └── databases.yml
├── host_vars/
│   ├── web1.example.com.yml
│   └── db1.example.com.yml
└── playbooks/
    ├── site.yml
    └── web_config.yml
```

Ao seguir essas práticas, você garantirá que seu inventário seja robusto, escalável e fácil de manter, o que é fundamental para uma automação eficaz com Ansible.



## Usando o Comando `ansible-inventory`

O comando `ansible-inventory` é uma ferramenta poderosa para inspecionar e verificar seu inventário. Ele permite que você veja como o Ansible interpreta seus arquivos de inventário, incluindo a estrutura de grupos, hosts e variáveis.

### Listar Todos os Hosts e Variáveis

Para ver a representação JSON completa do seu inventário, incluindo todos os hosts, grupos e variáveis, use a opção `--list`:

```bash
ansible-inventory -i inventory.ini --list
```

Ou, se você estiver usando um `ansible.cfg` que aponta para o seu inventário:

```bash
ansible-inventory --list
```

**Saída (exemplo parcial):**
```json
{
  "_meta": {
    "hostvars": {
      "db1.example.com": {
        "ansible_user": "root"
      },
      "web1.example.com": {
        "ansible_user": "ubuntu",
        "http_port": 80
      },
      "web2.example.com": {
        "ansible_user": "ec2-user",
        "http_port": 443
      }
    }
  },
  "all": {
    "children": [
      "databases",
      "ungrouped",
      "webservers"
    ]
  },
  "databases": {
    "hosts": [
      "db1.example.com",
      "db2.example.com"
    ],
    "vars": {
      "db_type": "mysql",
      "db_version": "8.0"
    }
  },
  "webservers": {
    "hosts": [
      "web1.example.com",
      "web2.example.com"
    ],
    "vars": {
      "http_port": 80,
      "max_clients": 200
    }
  }
}
```

### Visualizar a Estrutura de Grupos (Gráfico)

Para uma representação visual da hierarquia de grupos, use a opção `--graph`:

```bash
ansible-inventory -i inventory.ini --graph
```

**Saída (exemplo):**
```
@all:
  |--@databases:
  |  |--db1.example.com
  |  |--db2.example.com
  |--@ungrouped:
  |  |--server1.example.com
  |  |--server2.example.com
  |--@webservers:
  |  |--web1.example.com
  |  |--web2.example.com
```

### Visualizar Variáveis de um Host Específico

Para ver todas as variáveis que se aplicam a um host específico (incluindo variáveis de grupo e de host), use a opção `--host`:

```bash
ansible-inventory -i inventory.ini --host web1.example.com
```

**Saída (exemplo):**
```json
{
  "ansible_user": "ubuntu",
  "http_port": 80,
  "max_clients": 200
}
```

O comando `ansible-inventory` é uma ferramenta indispensável para depurar problemas de inventário, verificar a herança de variáveis e garantir que seus hosts e grupos estejam configurados como esperado antes de executar playbooks.

