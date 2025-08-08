#!/bin/bash

# Configurações básicas
IMAGE_NAME="vielitech/ritmun:1.5.0"
BASE_NAME="Ritmun"
# Número de equipamentos de trabalho a serem criados
NUM_EQUIPAMENTOS=5

# Variáveis de ambiente para os containers
DEBUG_MODE="True"

# Função para criar um container
criar_container() {
    local equipamento=$1
    local equipamento_formatado=$(printf "%02d" "$equipamento")
    local nome_container="${BASE_NAME}-${equipamento_formatado}"

    echo "Criando container para equipamento ${equipamento_formatado}..."
    echo "Nome: ${nome_container}"

    docker run -d \
        --restart unless-stopped \
        --name "${nome_container}" \
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
