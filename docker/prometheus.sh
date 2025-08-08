#!/bin/bash

# Configurações básicas
IMAGE_NAME="vielitech/prometheus:3.10.0"
BASE_NAME="Prometheus"
# Configurações de portas
BASE_HOST_PORT=3030
BASE_CONTAINER_PORT=3002
# Número de equipamentos de trabalho a serem criados
NUM_EQUIPAMENTOS=5

# Variáveis de ambiente para os containers
DEBUG_MODE="True"

# Função para criar um container
criar_container() {
    local equipamento=$1
    local equipamento_formatado=$(printf "%02d" "$equipamento")
    local nome_container="${BASE_NAME}-${equipamento_formatado}"
    local host_port=$((BASE_HOST_PORT + equipamento))
    local container_port=$BASE_CONTAINER_PORT

    echo "Criando container para equipamento ${equipamento_formatado}..."
    echo "Nome: ${nome_container}"
    echo "Portas: ${host_port}:${container_port}"

    docker run -d \
        --restart unless-stopped \
        --name "${nome_container}" \
        -p "${host_port}:${container_port}" \
        -e "DEBUG=${DEBUG_MODE}" \
        -e "EQP_CONFIG_ID=${equipamento}" \
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
