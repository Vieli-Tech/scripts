#!/bin/bash

# Configurações básicas
IMAGE_NAME="vielitech/freeman:1.28.0"
BASE_NAME="Freeman"
# Configurações de portas
BASE_HOST_PORT=8100
BASE_CONTAINER_PORT=8100
# Número de equipamentos de trabalho a serem criados
NUM_EQUIPAMENTOS=5

# Variáveis de ambiente para os containers
EQP_HOST="http://172.17.0.1"
BASE_EQP_CONFIG_ID=3030

# Função para criar um container
criar_container() {
    local equipamento=$1
    local equipamento_formatado=$(printf "%02d" "$equipamento")
    local nome_container="${BASE_NAME}-${equipamento_formatado}"
    local host_port=$((BASE_HOST_PORT + equipamento))
    local container_port=$BASE_CONTAINER_PORT
    local eqp_config_id=$((BASE_EQP_CONFIG_ID + equipamento))
    local eqp_host="${EQP_HOST}:${eqp_config_id}"

    echo "Criando container para equipamento ${equipamento_formatado}..."
    echo "Nome: ${nome_container}"
    echo "Portas: ${host_port}:${container_port}"

    docker run -d \
        --restart unless-stopped \
        --name "${nome_container}" \
        -p "${host_port}:${container_port}" \
        -e "EQP_CONFIG_ID=${equipamento}" \
        -e "EQP_CONFIG_HOST=${eqp_host}" \
        "${IMAGE_NAME}"

    if [ $? -eq 0 ]; then
        echo "Container ${nome_container} criado com sucesso!"
    else
        echo "Erro ao criar container ${nome_container}"
    fi
}

# Loop para criar os containers
for ((equipamento = 1; equipamento <= NUM_EQUIPAMENTOS; equipamento++)); do
    criar_container "$equipamento"
done

echo "Todos os containers foram criados!"
