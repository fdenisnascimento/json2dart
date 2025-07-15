# FDN Json2Dart

![Version](https://img.shields.io/visual-studio-marketplace/v/fdenisnascimento.json2dart)
![Installs](https://img.shields.io/visual-studio-marketplace/i/fdenisnascimento.json2dart)
![Downloads](https://img.shields.io/visual-studio-marketplace/d/fdenisnascimento.json2dart)
![Rating](https://img.shields.io/visual-studio-marketplace/r/fdenisnascimento.json2dart)

**Convert JSON to Dart classes** - Uma extensão poderosa para converter JSON em classes Dart automaticamente, compatível com **VSCode** e **Cursor IDE**.

## 🚀 Instalação

### VSCode / VSCode Insiders
[![Install on VSCode](https://img.shields.io/badge/Install%20on-VSCode-blue?style=for-the-badge&logo=visual-studio-code)](https://marketplace.visualstudio.com/items?itemName=fdenisnascimento.json2dart)

### Cursor IDE
[![Install on Cursor](https://img.shields.io/badge/Install%20on-Cursor-green?style=for-the-badge&logo=cursor)](https://open-vsx.org/extension/fdenisnascimento/json2dart)

### Instalação Manual
1. Baixe o arquivo `.vsix` da [página de releases](https://github.com/fdenisnascimento/json2dart/releases)
2. Abra VSCode/Cursor
3. Pressione `Ctrl+Shift+P` (ou `Cmd+Shift+P` no Mac)
4. Digite "Extensions: Install from VSIX..."
5. Selecione o arquivo baixado

## 📋 Recursos

- ✅ **Conversão automática** de JSON para classes Dart
- ✅ **Null Safety** nativo (Dart 2.12+)
- ✅ **Serialização completa** (fromJson/toJson)
- ✅ **Método copyWith** opcional
- ✅ **Configuração flexível** via pubspec.yaml
- ✅ **Múltiplas formas de uso** (clipboard, arquivo, pasta)
- ✅ **Compatível com Flutter** e Dart puro
- ✅ **Suporte completo ao Cursor IDE**

## 🎯 Como Usar

### 1. Converter do Clipboard

1. **Copie um JSON** para o clipboard
2. **Abra o Command Palette** (`Ctrl+Shift+P`)
3. **Digite** `json2dart: Convert JSON from Clipboard`
4. **Informe o nome da classe** (ex: `User`)
5. **Código Dart gerado** automaticamente!

### 2. Converter para Arquivo Específico

1. **Copie um JSON** para o clipboard
2. **Clique com botão direito** em um arquivo `.dart`
3. **Selecione** `Convert JSON from Clipboard Here`
4. **Digite o nome da classe**
5. **Código inserido** no arquivo selecionado

### 3. Converter para Nova Pasta

1. **Copie um JSON** para o clipboard
2. **Clique com botão direito** em uma pasta
3. **Selecione** `Convert JSON from Clipboard Here`
4. **Digite** `pasta.subpasta.NomeClasse`
5. **Novo arquivo criado** automaticamente

## ⚙️ Configuração

Adicione ao seu `pubspec.yaml`:

```yaml
jsonToDart:
  outputFolder: "lib/models"     # Pasta padrão de saída
  nullSafety: true              # Habilitar null safety
  mergeArrayApproach: false     # Como tratar arrays
  copyWithMethod: true          # Gerar método copyWith
  nullValueDataType: "dynamic"  # Tipo para valores null
```

### Opções Disponíveis

| Opção | Tipo | Padrão | Descrição |
|-------|------|--------|-----------|
| `outputFolder` | String | `"lib"` | Pasta de destino dos arquivos |
| `nullSafety` | Boolean | `false` | Habilitar null safety |
| `mergeArrayApproach` | Boolean | `false` | Mesclar tipos de array |
| `copyWithMethod` | Boolean | `false` | Gerar método copyWith |
| `nullValueDataType` | String | `null` | Tipo para valores null |

## 💡 Exemplos

### JSON de Entrada
```json
{
  "id": 1,
  "name": "João Silva",
  "email": "joao@example.com",
  "isActive": true,
  "preferences": {
    "theme": "dark",
    "notifications": true
  },
  "tags": ["flutter", "dart", "mobile"]
}
```

### Código Dart Gerado
```dart
class User {
  final int? id;
  final String? name;
  final String? email;
  final bool? isActive;
  final Preferences? preferences;
  final List<String>? tags;

  User({
    this.id,
    this.name,
    this.email,
    this.isActive,
    this.preferences,
    this.tags,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['isActive'],
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'])
          : null,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isActive': isActive,
      'preferences': preferences?.toJson(),
      'tags': tags,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    bool? isActive,
    Preferences? preferences,
    List<String>? tags,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
      tags: tags ?? this.tags,
    );
  }
}

class Preferences {
  final String? theme;
  final bool? notifications;

  Preferences({
    this.theme,
    this.notifications,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      theme: json['theme'],
      notifications: json['notifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'notifications': notifications,
    };
  }

  Preferences copyWith({
    String? theme,
    bool? notifications,
  }) {
    return Preferences(
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
    );
  }
}
```

## 🔧 Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `json2dart.convertFromClipboard` | Converte JSON do clipboard para código Dart |
| `json2dart.convertFromClipboardToFile` | Converte e insere em arquivo específico |
| `json2dart.convertFromClipboardToFolder` | Converte e cria novo arquivo em pasta |

## 🌟 Compatibilidade

### IDEs Suportados
- ✅ **Visual Studio Code** (todas as versões)
- ✅ **Visual Studio Code Insiders**
- ✅ **Cursor IDE** (via OpenVSX Registry)
- ✅ **VSCodium** (via OpenVSX Registry)
- ✅ **Outras IDEs** baseadas em VSCode

### Versões Dart/Flutter
- ✅ **Dart 2.12+** (com null safety)
- ✅ **Flutter 2.0+**
- ✅ **Dart 2.0+** (sem null safety)

## 📚 Documentação Adicional

- 📖 [**Guia de Instalação para Cursor**](./CURSOR_INSTALLATION.md)
- 🚀 [**Guia de Publicação**](./CURSOR_PUBLISHING_GUIDE.md)
- 📝 [**Changelog**](./CHANGELOG.md)

## 🤝 Contribuindo

Contribuições são bem-vindas! Veja como ajudar:

1. **Fork** este repositório
2. **Crie uma branch** para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra um Pull Request**

## 🐛 Reportar Bugs

Encontrou um problema? [Abra uma issue](https://github.com/fdenisnascimento/json2dart/issues/new) com:

- 📄 **JSON de entrada**
- 🎯 **Resultado esperado**
- ❌ **Resultado atual**
- 💻 **Versão do IDE** (VSCode/Cursor)
- 🐛 **Logs de erro** (se houver)

## 📊 Links de Distribuição

| Plataforma | Link | Status |
|------------|------|--------|
| **VSCode Marketplace** | [Instalar](https://marketplace.visualstudio.com/items?itemName=fdenisnascimento.json2dart) | ✅ Ativo |
| **OpenVSX Registry** | [Instalar](https://open-vsx.org/extension/fdenisnascimento/json2dart) | ✅ Ativo |
| **GitHub Releases** | [Download](https://github.com/fdenisnascimento/json2dart/releases) | ✅ Ativo |

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- 💙 **Comunidade Flutter/Dart**
- 🚀 **Equipe do VSCode**
- ⚡ **Equipe do Cursor IDE**
- 🌟 **Todos os contribuidores**

---

**Desenvolvido com ❤️ para a comunidade Flutter**

[![GitHub](https://img.shields.io/badge/GitHub-fdenisnascimento-black?style=flat-square&logo=github)](https://github.com/fdenisnascimento)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Denis%20Nascimento-blue?style=flat-square&logo=linkedin)](https://linkedin.com/in/fdenisnascimento)

**© 2024 Denis Nascimento. Licenciado sob MIT.**
