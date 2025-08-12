# Simulado 2 - Ansible

-  Todos os scripts e arquivos utilizados pelo Ansible devem ser guardados em /`data/ansible`
- Dados sensíveis e credenciais devem ser criptografados usando a senha: **skill#39** e descriptografados quando o playbook for executado.
- Utilize Ansible para criar playbooks e automatizar as tarefas a seguir:

## Tarefa:

Crie um playbook chamado `webdeploy.yaml` para configurar um servidor web que disponibilize um site simples.

- Configure o host do grupo **web-server** como servidor web.
- Utilize o pacote **nginx** como servidor HTTP.
- O conteúdo do site deve ser criado dinamicamente pelo playbook (não precisa existir antes).
- O site deve ter um arquivo `index.html` com a mensagem:
```html
<h1>Bem-vindo ao site da TechSkills Solutions</h1>
<p>Deploy automatizado com Ansible</p>
```

- Garanta que toda vez em que o arquivo `index.html` for alterado, o serviço nginx seja reiniciado.
- O servidor deve estar configurado para iniciar o nginx automaticamente no boot.
- A página deve ser servida na porta padrão 80.
- Nenhuma pré-configuração deve ser necessária — o playbook deve instalar e configurar tudo.