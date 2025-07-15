# FDN Json 4 Dart - Guia de Instalação para Cursor

Este guia explica como instalar e usar a extensão **FDN Json 4 Dart** no Cursor IDE.

## 📋 Sobre a Extensão

A extensão **FDN Json 4 Dart** converte objetos JSON em classes Dart automaticamente, perfeita para desenvolvimento Flutter. A extensão é totalmente compatível com o Cursor IDE.

## 🚀 Instalação

### Método 1: OpenVSX Registry (Recomendado)

1. Abra o Cursor IDE
2. Acesse o painel de extensões (`Ctrl+Shift+X` ou `Cmd+Shift+X`)
3. Procure por "**FDN Json 4 Dart**"
4. Clique em **Install**

### Método 2: Instalação Manual via VSIX

Se a extensão não estiver disponível no marketplace do Cursor:

1. Baixe o arquivo `.vsix` da [página de releases](https://github.com/fdenisnascimento/json2dart/releases)
2. No Cursor, abra o Command Palette (`Ctrl+Shift+P` ou `Cmd+Shift+P`)
3. Digite "Extensions: Install from VSIX..."
4. Selecione o arquivo `.vsix` baixado

## 🎯 Como Usar

### Converter JSON do Clipboard

1. Copie um JSON para o clipboard
2. Abra o Command Palette (`Ctrl+Shift+P`)
3. Digite "**json2dart: Convert JSON from Clipboard**"
4. Digite o nome da classe quando solicitado
5. O código Dart será gerado automaticamente

### Converter Diretamente em Arquivo

1. Copie um JSON para o clipboard
2. Clique com o botão direito em um arquivo `.dart` no Explorer
3. Selecione "**Convert JSON from Clipboard Here**"
4. Digite o nome da classe
5. O código será inserido no arquivo selecionado

### Converter em Pasta

1. Copie um JSON para o clipboard
2. Clique com o botão direito em uma pasta no Explorer
3. Selecione "**Convert JSON from Clipboard Here**"
4. Digite o nome da classe (ex: `models.User`)
5. Um novo arquivo será criado na pasta

## ⚙️ Configuração

Configure a extensão através do `pubspec.yaml` do seu projeto Flutter:

```yaml
jsonToDart:
  outputFolder: "lib/models"     # Pasta de saída padrão
  nullSafety: true              # Null safety habilitado
  mergeArrayApproach: false     # Como tratar arrays
  copyWithMethod: true          # Gerar método copyWith
  nullValueDataType: "dynamic"  # Tipo para valores null
```

## 🔧 Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `json2dart.convertFromClipboard` | Converte JSON do clipboard |
| `json2dart.convertFromClipboardToFile` | Converte para arquivo específico |
| `json2dart.convertFromClipboardToFolder` | Converte criando novo arquivo |

## 🎨 Exemplo de Uso

**JSON de entrada:**
```json
{
  "id": 1,
  "name": "João Silva",
  "email": "joao@exemplo.com",
  "isActive": true
}
```

**Código Dart gerado:**
```dart
class User {
  final int? id;
  final String? name;
  final String? email;
  final bool? isActive;

  User({
    this.id,
    this.name,
    this.email,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isActive': isActive,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }
}
```

## 🆘 Suporte

- **Issues**: [GitHub Issues](https://github.com/fdenisnascimento/json2dart/issues)
- **Documentação**: [README Principal](./README.md)

## 📚 Links Úteis

- [Documentação do Flutter](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides/language)
- [Cursor IDE Official Site](https://cursor.sh/)

---

**Desenvolvido com ❤️ para a comunidade Flutter**