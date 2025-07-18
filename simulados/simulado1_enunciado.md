 **Simulado 1 - Ansible**
---------------------------------------------------------------------------

### **Cenário**

Você foi contratado pela empresa **TechSkills Solutions** para configurar e automatizar a infraestrutura de rede de três filiais: **Europa**, **América** e **Nuvem Pública**. Seu papel é garantir conectividade segura, alta disponibilidade, automação e segurança dos serviços.

### **Tarefa 1: VPN e Firewall – Roteadores**

#### RT-EUROPA e RT-AMERICA

*   Configure uma VPN **site-to-site** com WireGuard entre os dois roteadores.
    
*   Use a sub-rede 10.200.0.0/24 para o túnel.
    
*   Configure PersistentKeepalive e salve em /etc/wireguard/wg0.conf.
    
*   Permita acesso completo entre as redes internas.
    

#### RT-EUROPA

*   Configure uma VPN **remote access** para clientes externos.
    
*   Use IP 10.20.20.20/32 e porta 51820/udp.
    
*   Salve em /etc/wireguard/wg1.conf.
    

#### NFTables

*   Configure firewall com política padrão DROP e modo stateful.
    
*   Permita:
    
    *   ICMP
        
    *   Acesso externo a Web, Email e DNS
        
    *   Acesso interno à Internet
        
    *   Acesso VPN a todos os serviços
        
*   Salve regras persistentes e documentadas.
    

### **Tarefa 2: Serviços de Rede – Datacenter Europa**

#### Servidor dc-eu.techskills.org

*   **DHCP**:
    
    *   Range: 192.168.10.100-200/24
        
    *   Gateway: 192.168.10.1
        
    *   DNS: 192.168.10.10
        
    *   DDNS com TSIG
        
    *   Failover com dc-eu2 (porta 519/520)
        
*   **DNS**:
    
    *   Zona direta e reversa techskills.org
        
    *   Split-DNS: IPs públicos para acesso externo
        
    *   Transferência de zona para dc-eu2 com TSIG
        
    *   Recursão habilitada
        
*   **LDAP**:
    
    *   Domínio: techskills.org
        
    *   Acesso restrito a client-eu
        
    *   Apenas usuários da OU TI podem logar
        
    *   Senhas criptografadas
        
    *   Usuários: alice, bob
        
*   **Proxy Reverso**:
    
    *   Keepalived com IP flutuante 192.168.10.100
        
    *   HTTPS obrigatório, redirecionamento HTTP
        
    *   Balanceamento round-robin entre web1 e web2
        
    *   Header x-proxy-host configurado
        

### **Tarefa 3: Automação com Ansible**

*   Todos os arquivos em /data/ansible
    
*   Use **Ansible Vault** com senha skill#2025
    
*   Crie os seguintes playbooks:
    

#### backup.yaml

*   Servidor: backup.techskills.org
    
*   Cliente: client-eu
    
*   Backup via rsync dos diretórios /var/mail
    
*   Armazenar em /mnt/backup
    
*   Agendar a cada 30 minutos
    
*   Reiniciar serviço se config mudar
    

#### firewall.yaml

*   Aplicar regras NFTables em todos os roteadores
    
*   Garantir persistência e logging
    

### **Tarefa 4: Monitoramento e Certificados**

#### Monitoramento

*   Configure **Icinga2** em monitor.techskills.org
    
*   Monitore:
    
    *   VPN
        
    *   Sites HTTPS
        
    *   ICMP dos roteadores
        

#### Certificados

*   Use CA local ca.techskills.org
    
*   Publique CRL e AIA em:
    
    *   http://ca.techskills.org/certs/crl.pem
        
    *   http://ca.techskills.org/certs/ca.pem
        

### **Tarefa 5: Clientes**

#### client-eu

*   Receber IP via DHCP
    
*   Acessar todos os serviços internos e externos
    
*   Configurar Thunderbird com conta alice@techskills.org
    
*   Enviar email para bob@techskills.org com o texto “Bonjour!”