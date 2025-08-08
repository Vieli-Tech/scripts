# Scripts
## About The Project
Scripts em Bash para servidores Linux VieliTech


## Usage

Pastas estão organizadas por assuntos. Por exemplo, dentro da pasta docker, você encontrará scripts para automações docker.
Escolha aquela que irá precisar e rode
```
./prometheus.sh (example)
```

## Table of Scripts
* Docker
  * **container_update**:<br>Script para atualizar em batch. Containers diferentes com a mesma imagem. Irá parar, copiar a configuração, remover, e criar um novo container atualizado.
  * **prometheus.sh**: 
  * **gump.sh**:
  * **freeman.sh**:
  * **ritmun.sh**:

## Procedimento para Deploy de Containers Novos

### Pré-requisitos
- Acesso SSH ao servidor
- Docker instalado e configurado
### 1. Criação e Configuração do Script
#### Acesso ao servidor
```bash
ssh usuario@ip-do-servidor
```
#### Criação do diretório (organização)
```bash
mkdir scripts
cd scripts
```
#### Criação/Edição do script com Vim
```bash
vi prometheus.sh
```
**Comandos básicos do Vim:**
- `i` → Modo de inserção (para editar)
- `ESC` → Sair do modo de inserção
- `:wq` → Salvar e sair
- `:q` → Sair sem salvar
#### Conteúdo do script
```bash
# script para deploy de containers Prometheus...
# pode ser copiado qualquer um dos scripts na pasta containers
# e colado em modo inserção do arquivo .sh recèm criado.

# Deve-se apenas alterar o número de containers a serem criados
# e a versão a ser utilizada
```
Após abrir e entrar em modo inserção, basta utilizar (ctrl + shift + V) para colar o script
### 2. Permissões e Execução
#### Tornar o script executável
```bash
chmod +x prometheus.sh
```
#### Execução do script
```bash
./prometheus.sh
```
### 3. Resolução de Problemas de Permissão do Docker

#### Erro encontrado:
```
docker: permission denied while trying to connect to the Docker daemon socket...
```
#### Solução implementada:
1. Verificar/instalar grupo docker:
```bash
sudo groupadd docker
```
2. Adicionar usuário ao grupo docker:
```bash
sudo usermod -aG docker vieli
```
3. Atualizar permissões sem logout:
```bash
newgrp docker
```
4. Verificar se o usuário foi adicionado (docker é para aprecer entre os grupos listados):
```bash
groups
```
5. Reiniciar serviço docker (se necessário):
```bash
sudo systemctl restart docker
```
### 4. Validação do Deploy
#### Verificar containers em execução
```bash
docker ps
```

