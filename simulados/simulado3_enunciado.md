# Simulado 3 - Ansible

- Todos os scripts e arquivos utilizados pelo Ansible devem ser guardados em `/data/ansible`.
- Dados sensíveis e credenciais devem ser criptografados usando a senha `skill#2025` e descriptografados quando o playbook for executado.
- Utilize Ansible para criar playbooks e automatize as tarefas a seguir:

  - Crie um playbook chamado `secure_backup.yaml` para configurar um serviço de backup seguro e monitoramento.
    - Configure o host do grupo `secure-backup-server` como servidor de backup seguro.
    - Utilize o pacote rsync com SSH para realizar a transferência de dados de forma criptografada.
    - Configure autenticação baseada em chave SSH, garantindo que a chave privada seja armazenada criptografada com Ansible Vault.
    - Garanta que, sempre que o arquivo de configuração do rsync ou as chaves SSH forem alterados, o serviço de backup seja reiniciado automaticamente.
    - O servidor de backup deve aceitar conexões apenas de hosts do grupo `secure-backup-clients` e apenas na rede 10.100.0.0/24, bloqueando o restante via firewall (nftables).
    -  Os clientes devem realizar backup de duas pastas:
       
       `/var/mail` (emails)

       `/var/www/html` (sites)

    - O servidor deve armazenar os backups separados por cliente, em `/secure-backups/<nome_do_cliente>/files`.
    - Configure logs do rsync para serem gravados em `/var/log/secure-backup.log` e rotacionados semanalmente com `logrotate`.
    - Agende os backups para ocorrerem a cada 15 minutos, mas apenas se houver mudanças nos arquivos desde o último backup (use `rsync --update`).
    - Caso o backup falhe, um email de alerta deve ser enviado para `admin@empresa.com` usando `mail` (instale e configure se necessário).
