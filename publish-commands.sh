#!/bin/bash

# 🚀 FDN Json 4 Dart - Script de Publicação
# Automatiza a publicação da extensão no VSCode Marketplace e OpenVSX Registry

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções auxiliares
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  FDN Json 4 Dart - Publication Script${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_step() {
    echo -e "${YELLOW}🔄 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar se está na raiz do projeto
check_project_root() {
    if [ ! -f "package.json" ]; then
        print_error "package.json não encontrado. Execute este script na raiz do projeto."
        exit 1
    fi

    if [ ! -f "src/extension.ts" ]; then
        print_error "src/extension.ts não encontrado. Este não parece ser o projeto correto."
        exit 1
    fi
}

# Verificar ferramentas necessárias
check_tools() {
    print_step "Verificando ferramentas necessárias..."

    if ! command -v npm &> /dev/null; then
        print_error "npm não está instalado"
        exit 1
    fi

    if ! command -v npx &> /dev/null; then
        print_error "npx não está instalado"
        exit 1
    fi

    print_success "Ferramentas verificadas"
}

# Instalar dependências
install_deps() {
    print_step "Instalando dependências..."
    npm ci
    print_success "Dependências instaladas"
}

# Executar testes
run_tests() {
    print_step "Executando testes..."
    npm run lint
    npm test
    print_success "Testes executados com sucesso"
}

# Build da extensão
build_extension() {
    print_step "Fazendo build da extensão..."
    npm run package
    print_success "Build concluído"
}

# Criar arquivo VSIX
create_vsix() {
    print_step "Criando arquivo VSIX..."
    npx @vscode/vsce package

    # Verificar se arquivo foi criado
    if ls *.vsix 1> /dev/null 2>&1; then
        local vsix_file=$(ls *.vsix | head -n1)
        print_success "Arquivo VSIX criado: $vsix_file"
        echo -e "${BLUE}📦 Tamanho: $(du -h $vsix_file | cut -f1)${NC}"
    else
        print_error "Falha ao criar arquivo VSIX"
        exit 1
    fi
}

# Criar commit e tag para nova versão
create_version_commit() {
    print_step "Criando commit e tag para nova versão..."

    # Obter versão do package.json
    VERSION=$(node -p "require('./package.json').version")

    # Verificar se a tag já existe
    if git rev-parse "v$VERSION" >/dev/null 2>&1; then
        print_error "Tag v$VERSION já existe!"
        echo -e "${YELLOW}ℹ️  Use 'git tag -d v$VERSION' para remover se necessário${NC}"
        return 1
    fi

    # Verificar se há mudanças para commitar
    if [ -n "$(git status --porcelain)" ]; then
        print_step "Commitando mudanças da versão $VERSION..."
        git add .
        git commit -m "🚀 Release v$VERSION

- Updated package version to $VERSION
- Ready for marketplace publication
- Generated VSIX package"

        if [ $? -eq 0 ]; then
            print_success "Commit criado com sucesso"
        else
            print_error "Falha ao criar commit"
            return 1
        fi
    else
        print_step "Nenhuma mudança para commitar"
    fi

    # Criar tag
    print_step "Criando tag v$VERSION..."
    if git tag -a "v$VERSION" -m "Release version $VERSION

🎯 Features:
- JSON to Dart class conversion
- Null safety support
- Compatible with VSCode and Cursor IDE

📦 Package: json4dart-$VERSION.vsix"; then
        print_success "Tag v$VERSION criada com sucesso"
    else
        print_error "Falha ao criar tag"
        return 1
    fi

    # Push das mudanças e tag
    print_step "Fazendo push das mudanças e tag..."

    # Detectar branch principal
    MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

    git push origin "$MAIN_BRANCH"
    git push origin "v$VERSION"

    if [ $? -eq 0 ]; then
        print_success "Push realizado com sucesso"
        echo -e "${BLUE}🔗 Tag criada: https://github.com/fdenisnascimento/json2dart/releases/tag/v$VERSION${NC}"
    else
        print_error "Falha no push - verifique permissões do repositório"
        return 1
    fi
}

# Verificar tokens
check_tokens() {
    print_step "Verificando tokens de acesso..."

    if [ -z "$VSCE_PAT" ]; then
        print_error "VSCE_PAT não definido. Configure a variável de ambiente."
        echo "export VSCE_PAT='seu_token_vscode_aqui'"
        exit 1
    fi

    if [ -z "$OVSX_PAT" ]; then
        print_error "OVSX_PAT não definido. Configure a variável de ambiente."
        echo "export OVSX_PAT='seu_token_openvsx_aqui'"
        exit 1
    fi

    print_success "Tokens verificados"
}

# Publicar no VSCode Marketplace
publish_vscode() {
    print_step "Publicando no VSCode Marketplace..."

    if npx @vscode/vsce publish -p "$VSCE_PAT"; then
        print_success "Publicado no VSCode Marketplace"
        echo -e "${BLUE}🔗 https://marketplace.visualstudio.com/items?itemName=fdenisnascimento.json2dart${NC}"
    else
        print_error "Falha na publicação no VSCode Marketplace"
        return 1
    fi
}

# Publicar no OpenVSX Registry
publish_openvsx() {
    print_step "Publicando no OpenVSX Registry..."

    if npx ovsx publish -p "$OVSX_PAT"; then
        print_success "Publicado no OpenVSX Registry"
        echo -e "${BLUE}🔗 https://open-vsx.org/extension/fdenisnascimento/json2dart${NC}"
    else
        print_error "Falha na publicação no OpenVSX Registry"
        return 1
    fi
}

# Verificar publicações
verify_publications() {
    print_step "Verificando publicações..."

    echo -e "${YELLOW}⏳ Aguardando propagação (30 segundos)...${NC}"
    sleep 30

    # Verificar VSCode Marketplace
    if curl -s "https://marketplace.visualstudio.com/items?itemName=fdenisnascimento.json2dart" > /dev/null; then
        print_success "VSCode Marketplace: Ativo"
    else
        echo -e "${YELLOW}⚠️  VSCode Marketplace: Aguardando propagação${NC}"
    fi

    # Verificar OpenVSX Registry
    if curl -s "https://open-vsx.org/api/fdenisnascimento/json2dart" > /dev/null; then
        print_success "OpenVSX Registry: Ativo"
    else
        echo -e "${YELLOW}⚠️  OpenVSX Registry: Aguardando propagação${NC}"
    fi
}

# Menu de opções
show_menu() {
    echo
    echo -e "${BLUE}Escolha uma opção:${NC}"
    echo "1) 🔨 Build completo (instalar deps + tests + build)"
    echo "2) 📦 Criar arquivo VSIX"
    echo "3) 📝 Criar commit e tag da versão"
    echo "4) 🚀 Publicar no VSCode Marketplace"
    echo "5) 🌟 Publicar no OpenVSX Registry"
    echo "6) 🎯 Publicar em ambos (com commit/tag)"
    echo "7) ✅ Verificar publicações"
    echo "8) 🏃 Release completo (build + commit/tag + publicar + verificar)"
    echo "0) ❌ Sair"
    echo
}

# Função principal
main() {
    print_header
    check_project_root
    check_tools

    while true; do
        show_menu
        read -p "Digite sua opção: " choice
        echo

        case $choice in
            1)
                install_deps
                run_tests
                build_extension
                ;;
            2)
                create_vsix
                ;;
            3)
                create_version_commit
                ;;
            4)
                check_tokens
                publish_vscode
                ;;
            5)
                check_tokens
                publish_openvsx
                ;;
            6)
                create_version_commit
                check_tokens
                publish_vscode && publish_openvsx
                ;;
            7)
                verify_publications
                ;;
            8)
                install_deps
                run_tests
                build_extension
                create_vsix
                create_version_commit
                check_tokens
                publish_vscode && publish_openvsx
                verify_publications
                ;;
            0)
                print_success "Script finalizado!"
                exit 0
                ;;
            *)
                print_error "Opção inválida!"
                ;;
        esac

        echo
        read -p "Pressione ENTER para continuar..."
    done
}

# Executar função principal
main "$@"