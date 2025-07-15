# 🚀 Guia de Publicação - VSCode Marketplace & OpenVSX (Cursor)

Este guia explica como publicar a extensão **FDN Json 4 Dart** tanto no VSCode Marketplace quanto no OpenVSX Registry (usado pelo Cursor IDE).

## 📋 Pré-requisitos

### Ferramentas Necessárias

1. **Node.js** (versão 14 ou superior)
2. **vsce** (Visual Studio Code Extension)
3. **ovsx** (OpenVSX CLI)

```bash
# Instalar globalmente
npm install -g vsce ovsx

# Ou usar via npx (recomendado)
npx @vscode/vsce --version
npx ovsx --version
```

### Tokens de Acesso

#### 1. VSCode Marketplace Token

1. Acesse [Azure DevOps](https://dev.azure.com/)
2. Crie uma organização (se não tiver)
3. Vá em **User Settings** → **Personal Access Tokens**
4. Crie um novo token com escopo **Marketplace (manage)**
5. Salve o token com segurança

#### 2. OpenVSX Registry Token

1. Acesse [OpenVSX Registry](https://open-vsx.org/)
2. Faça login com GitHub
3. Vá em **Settings** → **Access Tokens**
4. Crie um novo token
5. Salve o token com segurança

## 🔐 Configuração de Variáveis de Ambiente

### Local (.env)

Crie um arquivo `.env` na raiz do projeto:

```bash
VSCE_PAT=your_vscode_marketplace_token_here
OVSX_PAT=your_openvsx_token_here
```

### GitHub Secrets

Configure as seguintes secrets no GitHub:

| Nome | Descrição |
|------|-----------|
| `VSCE_PAT` | Token do VSCode Marketplace |
| `OVSX_PAT` | Token do OpenVSX Registry |

## 📦 Scripts de Publicação

### Manual

```bash
# Publicar apenas no VSCode Marketplace
npm run publish:vscode

# Publicar apenas no OpenVSX
npm run publish:openvsx

# Publicar em ambos
npm run publish:all

# Gerar arquivo .vsix
npm run package:vsix
```

### Com Tokens de Ambiente

```bash
# VSCode Marketplace
vsce publish -p $VSCE_PAT

# OpenVSX Registry
ovsx publish -p $OVSX_PAT

# Ou usando npx
npx @vscode/vsce publish -p $VSCE_PAT
npx ovsx publish -p $OVSX_PAT
```

## 🤖 GitHub Actions (CI/CD)

Crie o arquivo `.github/workflows/publish.yml`:

```yaml
name: Publish Extension

on:
  push:
    tags:
      - 'v*.*.*'
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to publish'
        required: true
        default: 'patch'
        type: choice
        options:
          - patch
          - minor
          - major

jobs:
  publish:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Build extension
      run: npm run package

    - name: Publish to VSCode Marketplace
              run: npx @vscode/vsce publish -p ${{ secrets.VSCE_PAT }}

    - name: Publish to OpenVSX Registry
      run: npx ovsx publish -p ${{ secrets.OVSX_PAT }}

    - name: Create GitHub Release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: ${{ github.ref }}
        release_name: Release ${{ github.ref }}
        draft: false
        prerelease: false
```

## 🔄 Workflow de Publicação

### 1. Preparação da Release

```bash
# 1. Atualize a versão no package.json
npm version patch  # ou minor/major

# 2. Atualize o CHANGELOG.md
# 3. Commit das mudanças
git add .
git commit -m "chore: bump version to v1.0.2"

# 4. Crie uma tag
git tag v1.0.2

# 5. Push com tags
git push origin main --tags
```

### 2. Publicação Manual

```bash
# Build da extensão
npm run package

# Teste local (opcional)
code --install-extension json4dart-1.0.2.vsix

# Publicação
npm run publish:all
```

### 3. Verificação

#### VSCode Marketplace
- Acesse: https://marketplace.visualstudio.com/items?itemName=fdenisnascimento.json4dart

#### OpenVSX Registry
- Acesse: https://open-vsx.org/extension/fdenisnascimento/json4dart

## 📊 Monitoramento

### Downloads e Estatísticas

- **VSCode**: Dashboard do Azure DevOps
- **OpenVSX**: Dashboard do OpenVSX Registry

### Logs de Publicação

```bash
# Verificar status da publicação
vsce show fdenisnascimento.json4dart
ovsx get fdenisnascimento.json4dart
```

## 🐛 Troubleshooting

### Problemas Comuns

#### 1. Token Inválido
```bash
# Verificar token VSCode
vsce verify-pat $VSCE_PAT

# Verificar token OpenVSX
ovsx verify-pat $OVSX_PAT
```

#### 2. Versão já Existe
```bash
# Incrementar versão automaticamente
vsce publish patch  # ou minor/major
ovsx publish patch
```

#### 3. Arquivo muito Grande
```bash
# Verificar tamanho
ls -lh *.vsix

# Otimizar bundle
npm run package
```

#### 4. Dependências Quebradas
```bash
# Limpar e reinstalar
rm -rf node_modules package-lock.json
npm install
npm run package
```

## 📝 Checklist de Publicação

- [ ] **package.json** atualizado com nova versão
- [ ] **CHANGELOG.md** atualizado
- [ ] **README.md** atualizado
- [ ] Extensão testada localmente
- [ ] Tokens de acesso válidos
- [ ] GitHub Secrets configurados
- [ ] Tags criadas no Git
- [ ] Build da extensão funcionando
- [ ] Publicação no VSCode Marketplace
- [ ] Publicação no OpenVSX Registry
- [ ] Verificação das publicações
- [ ] Documentação atualizada

## 🔗 Links Úteis

- [VSCode Extension API](https://code.visualstudio.com/api)
- [Publishing Extensions](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)
- [OpenVSX Registry](https://open-vsx.org/)
- [ovsx CLI Documentation](https://github.com/eclipse/openvsx/wiki/Publishing-Extensions)
- [vsce CLI Documentation](https://github.com/Microsoft/vscode-vsce)

---

**🎯 Resultado:** Extensão disponível tanto no VSCode quanto no Cursor IDE!