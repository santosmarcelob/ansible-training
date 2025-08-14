# Configuração de Servidor Web Apache com Ansible

Você é responsável por configurar um cluster de servidores web Apache em dois hosts Linux do seu homelab (`web01` e `web02`) utilizando Ansible.

O playbook deverá atender aos seguintes requisitos:

### **1. Disponibilidade**

- O site deve estar disponível em **HTTP (porta 80)**.
- O Apache deve iniciar automaticamente no boot.
- Caso o serviço Apache esteja parado, ele deve ser reiniciado automaticamente.

### **2. Conteúdo do site**

- O conteúdo principal do site deve estar localizado em `/var/www/html/`.
- Caso nenhum arquivo seja especificado na URL, deve exibir automaticamente `index.html`.
- Ao acessar `/whoami`, o servidor deve exibir o hostname da máquina dinamicamente.
- Ao acessar uma página inexistente, deve exibir `404.html`.
- O conteúdo das páginas (`index.html`, `whoami`, `404.html`) deve ser gerado dinamicamente pelo playbook usando templates Jinja2.

### **3. Configuração**

- A página `index.html` deve exibir também a data e hora de implantação.
- A página `whoami` deve mostrar o hostname, endereço IP e sistema operacional.
- A configuração do Apache deve ser feita de forma a permitir logs de acesso e erro personalizados em `/var/log/apache2/custom_access.log` e `/var/log/apache2/custom_error.log`.

### **4. Boas práticas exigidas**

- O playbook deve ser **idempotente**.
- Todo o conteúdo HTML deve ser criado via templates **Jinja2** (não arquivos fixos).
- A instalação e configuração devem ser feitas em tasks separadas, usando `handlers` para reiniciar o Apache quando necessário.
- O código deve ser organizado com roles