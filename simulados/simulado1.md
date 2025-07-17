# Tarefa 1: Domínio worldskills.af - África

## RT-AFRICA

### WireGuard
1. Configure uma VPN Site-to-site entre os roteadores **RT-AFRICA** e **RT-EUROPA**, garantindo uma conexão segura, permanente e de alta performance entre as duas redes.
   - Garanta que os Clientes e Servidores das duas redes tenham acesso total entre si.  

   - Salve a configuração no diretório `/etc/wireguard` com o nome `wg0.conf`.

   - Utilize o `wg-quick` para que a VPN funcione como serviço do sistema.

   - Use a sub-rede `10.150.0.0/24` para o túnel VPN.

   - Configure `PersistentKeepalive` para manter o túnel ativo.

2. Configure uma VPN Remote Access para permitir que engenheiros em campo acessem a rede interna.
    - Garanta que os clientes externos tenham acesso à rede AFRICA e à rede EUROPA (via túnel site-to-site).

    - Salve a configuração em `/etc/wireguard/wg1.conf`.

    - Utilize a porta **51830/udp**.

    - Atribua o IP `10.25.25.25/32` ao cliente VPN remoto.

    - Use a opção **PersistentKeepalive** no cliente.

---

### NFTABLES
1. Utilize o **nftables** para implementar regras de firewall seguras:
    - Configure `policy DROP` com modo **stateful** (rastreamento de estado) em todas as chains da tabela `filter`.
    - Permita **ICMP** para todas as redes.

    - Garanta que clientes externos da VPN possam:
      - Resolver o DNS interno.
      - Acessar os sites web internos.
      - Acessar o servidor de email interno.

    - Garanta que clientes internos tenham acesso à internet.
    - Garanta que clientes internos e VPN acessem todos os serviços necessários.
    - E que clientes internos e VPN acessem todos os serviços necessários.

2. Salve todas as regras em um arquivo de configuração do **nftables** e certifique-se de que elas persistam após reinicialização.

3. Utilize boas práticas adicionais com **nftables**:
    - Crie chains específicas (ex: `vpn_input`, `vpn_forward`).
    - Adicione regras de log, contadores e comentários explicativos.

---

## CLIENTE: leila-pc
1. Este cliente está com a interface gráfica **XFCE** e tem **IPv6** configurado.
2. Garanta que o cliente obtenha endereço **IPv4** via **DHCP**.

3. Garanta que o cliente consiga acessar todos os recursos da rede “EUROPA” via **VPN Site-to-site**.

4. Garanta que o cliente possa navegar em qualquer site, **sem erros de certificado**.

5. Configure o cliente de email Thunderbird com a conta "leila" do domínio worldskills.af
    - Envie um email para "paul" e "nala" com o texto “Salama!”.

    - Não apague esse email nem quaisquer outros emails de teste.