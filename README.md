# 🛍️ E-Commerce Whitelabel App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20iOS%20%7C%20Android-lightgrey?style=for-the-badge)

**Aplicativo E-commerce Multi-tenant com Clean Architecture e BLoC**

[Características](#-características) •
[Instalação](#-instalação) •
[Configuração](#️-configuração) •
[Uso](#-uso) •
[Arquitetura](#-arquitetura) •
[Troubleshooting](#-troubleshooting)

</div>

---

## 📋 Sobre o Projeto

Sistema de e-commerce **whitelabel** desenvolvido em Flutter que permite múltiplos clientes (tenants) utilizarem a mesma base de código com diferentes identidades visuais e configurações. O app consome uma API NestJS e suporta múltiplos fornecedores de produtos com sincronização automática.

### ✨ Principais Diferenciaiss

- 🎨 **Whitelabel Dinâmico**: Temas aplicados instantaneamente baseados no domínio (sem dependência de API)
- 🏢 **Multi-tenant**: Suporta múltiplos clientes na mesma aplicação
- 🔄 **Sincronização Automática**: Integração com múltiplos fornecedores externos
- 💾 **Cache Inteligente**: Sistema de cache local com SharedPreferences (validade de 24h)
- 🔐 **Autenticação JWT**: Sistema seguro de autenticação com refresh token
- 📱 **Cross-platform**: Web, iOS e Android com código único
- 🛒 **Carrinho Completo**: Sistema de carrinho com Provider e gestão de estado

---

## 🎯 Características

### 🛍️ E-commerce Completo

- ✅ **Listagem de Produtos**: Grid responsivo com cards otimizados
- ✅ **Busca e Filtros**: Por nome, categoria, faixa de preço e fornecedor
- ✅ **Detalhes do Produto**: Galeria de imagens, descrição completa, informações técnicas
- ✅ **Carrinho de Compras**: Adicionar, remover, alterar quantidades
- ✅ **Ofertas e Descontos**: Badge de desconto, preço original riscado
- ✅ **Categorias**: Página dedicada com ícones customizados
- ✅ **Sincronização**: Busca produtos de fornecedores externos e salva localmente

### 👤 Gestão de Usuários

- ✅ **Autenticação**: Login e registro com validação
- ✅ **JWT**: Tokens salvos localmente com SharedPreferences
- ✅ **Perfil**: Visualização e edição de dados pessoais
- ✅ **Segurança**: Change password, delete account

### 🎨 Whitelabel & Temas

- ✅ **Detecção Automática**: Identifica o cliente pelo domínio (Uri.base.host)
- ✅ **Cores Personalizadas**: Primary e secondary colors por cliente
- ✅ **Aplicação Instantânea**: Tema correto desde o primeiro frame
- ✅ **Clientes Suportados**:
  - 🟢 **localhost**: Verde (#2ecc71 / #27ae60)
  - 🟢 **devnology.com**: Verde (#2ecc71 / #27ae60)
  - 🟣 **in8.com**: Roxo (#8e44ad / #9b59b6)

### ⚡ Performance & Cache

- ✅ **Cache Local**: Produtos salvos com SharedPreferences (24h de validade)
- ✅ **Filtros Locais**: Busca e filtros aplicados no cache (instantâneo)
- ✅ **Sincronização Inteligente**: Atualiza apenas quando necessário
- ✅ **Lazy Loading**: Carregamento sob demanda

---

## 🚀 Instalação

### Pré-requisitos

Certifique-se de ter instalado:

- [Flutter](https://flutter.dev/docs/get-started/install) 3.7 ou superior
- [Dart](https://dart.dev/get-dart) 3.0 ou superior
- [Git](https://git-scm.com/)
- Um editor de código ([VS Code](https://code.visualstudio.com/) recomendado)

### 1️⃣ Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/flutter-ecommerce-whitelabel.git
cd flutter-ecommerce-whitelabel
```

### 2️⃣ Instalar Dependências

```bash
flutter pub get
```

### 3️⃣ Verificar Instalação

```bash
flutter doctor
```

---

## ⚙️ Configuração

### 🌐 Configuração da API

Edite o arquivo `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // 🔧 URL Base da API
  static const String baseUrl = 'http://localhost:3000/api';
  
  // 🔧 Domínios Whitelabel
  static const Map<String, String> clientDomains = {
    'localhost': 'localhost',
    'devnology': 'devnology.com',
    'in8': 'in8.com',
  };
  
  // 🎨 Cores por Cliente
  static const Map<String, Map<String, String>> clientColors = {
    'localhost': {'primary': '#2ecc71', 'secondary': '#27ae60'},
    'devnology.com': {'primary': '#2ecc71', 'secondary': '#27ae60'},
    'in8.com': {'primary': '#8e44ad', 'secondary': '#9b59b6'},
  };
}
```

### 🔑 Configuração do Backend

O app espera que o backend NestJS esteja rodando em `http://localhost:3000`.

**Headers obrigatórios em todas as requisições:**
- `X-Client-Domain`: Identifica o cliente (ex: `devnology.com`)
- `Authorization`: Bearer token JWT (para rotas autenticadas)

---

## 🖥️ Uso

### Executar para Diferentes Clientes

#### 🟢 Localhost (Verde)
```bash
flutter run -d chrome --web-hostname=localhost --web-port=8000
```
Acesse: `http://localhost:8000`

#### 🟢 Devnology (Verde)
```bash
flutter run -d chrome --web-hostname=devnology.com --web-port=8000
```
Acesse: `http://devnology.com:8000`

#### 🟣 In8 (Roxo)
```bash
flutter run -d chrome --web-hostname=in8.com --web-port=8000
```
Acesse: `http://in8.com:8000`

### Configurar Hosts (Desenvolvimento Local)

Para testar diferentes domínios localmente, edite o arquivo de hosts:

**Windows**: `C:\Windows\System32\drivers\etc\hosts`  
**Mac/Linux**: `/etc/hosts`

```
127.0.0.1 localhost
127.0.0.1 devnology.com
127.0.0.1 in8.com
```

### Build para Produção

#### Web
```bash
flutter build web --release --web-renderer html
```

#### Android
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

---

## 🏗️ Arquitetura

Este projeto segue **Clean Architecture** proposta por Robert C. Martin + **BLoC Pattern** para gerenciamento de estado.

### 📐 Estrutura de Camadas

```
┌─────────────────────────────────────────────┐
│         Presentation Layer                  │
│  (UI, Widgets, BLoC, Pages, Providers)      │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│          Domain Layer                       │
│  (Entities, Use Cases, Repositories)        │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│           Data Layer                        │
│  (Models, Datasources, Repositories Impl)   │
└─────────────────────────────────────────────┘
```

### 🔄 Fluxo de Dados

```
User Action → Event → BLoC → Use Case → Repository → DataSource → API
                 ↓
              State → UI Update
```

### 📂 Estrutura de Pastas

```
lib/
├── main.dart                          # Entry point + tema whitelabel
├── injection_container.dart           # Dependency Injection (GetIt)
│
├── core/                              # Núcleo da aplicação
│   ├── constants/
│   │   └── app_constants.dart        # Constantes globais + cores whitelabel
│   ├── errors/
│   │   ├── exceptions.dart           # Exceções customizadas
│   │   └── failures.dart             # Tipos de falhas
│   ├── network/
│   │   └── api_client.dart           # Cliente HTTP + interceptors
│   ├── navigation/
│   │   └── main_navigation.dart      # Bottom Navigation
│   └── theme/
│       ├── app_theme.dart            # Theme builder
│       └── whitelabel_theme.dart     # Detecção de domínio + tema
│
└── features/                          # Features (Clean Architecture)
    │
    ├── auth/                         # 🔐 Autenticação
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── sign_in.dart
    │   │       ├── sign_up.dart
    │   │       └── sign_out.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── register_page.dart
    │       └── widgets/
    │           ├── login_form.dart
    │           └── register_form.dart
    │
    ├── products/                     # 🛍️ Produtos
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── product_remote_datasources.dart
    │   │   ├── models/
    │   │   │   └── product_model.dart
    │   │   └── repositories/
    │   │       └── products_repository_impl.dart  # ✅ Cache de 24h
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── product.dart
    │   │   ├── repositories/
    │   │   │   └── products_repository.dart
    │   │   └── usecases/
    │   │       ├── get_products.dart
    │   │       ├── filter_products.dart      # ✅ Filtros locais
    │   │       ├── get_products_by_id.dart
    │   │       ├── sync_product.dart         # ✅ Sincronização
    │   │       └── cart_provider.dart        # ✅ Carrinho
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── products_bloc.dart
    │       │   ├── products_event.dart
    │       │   └── products_state.dart
    │       ├── pages/
    │       │   ├── products_list_page.dart   # Lista principal
    │       │   ├── products_detail_page.dart # Detalhes
    │       │   ├── cart_page.dart           # Carrinho
    │       │   ├── category_page.dart       # Categorias
    │       │   └── offers_page.dart         # Ofertas
    │       └── widgets/
    │           ├── product_card.dart
    │           ├── products_filter.dart      # ✅ Modal de filtros
    │           └── products_grid.dart
    │
    ├── client/                       # 🏢 Configuração de Clientes
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── client_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── client_model.dart
    │   │   └── repositories/
    │   │       └── client_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── client.dart
    │   │   ├── repositories/
    │   │   │   └── client_repository.dart
    │   │   └── usecases/
    │   │       └── get_client_config.dart
    │   └── presentation/
    │       └── provider/
    │           └── whitelabel_provider.dart
    │
    ├── orders/                       # 🏢 Configuração de Pedidos
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── order_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── orders_model.dart
    │   │   └── repositories/
    │   │       └── orders_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── orders.dart
    │   │   ├── repositories/
    │   │   │   └── orders_repository.dart
    │   │   └── usecases/
    │   │       └── get_orders.dart
    │   └── presentation/
    |      ├── bloc/
    |        │   ├── order_bloc.dart
    |        │   ├── order_event.dart
    |        │   └── order_state.dart
    |        └── pages/
    |            └── order_page.dart
    |
    │
    └── users/                        # 👤 Gestão de Usuários
        ├── data/
        │   ├── datasources/
        │   │   └── user_remote_datasource.dart
        │   ├── models/
        │   │   └── user_model.dart
        │   └── repositories/
        │       └── user_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user.dart
        │   ├── repositories/
        │   │   └── user_repository.dart
        │   └── usecases/
        │       ├── get_user.dart
        │       ├── get_profile.dart
        │       ├── update_user.dart
        │       ├── update_profile.dart
        │       ├── change_password.dart
        │       ├── delete_user.dart
        │       └── get_all_users.dart
        └── presentation/
            ├── bloc/
            │   ├── user_bloc.dart
            │   ├── user_event.dart
            │   └── user_state.dart
            └── pages/
                └── user_edit_page.dart
```

---

## 📌 API Endpoints

### Base URL
```
http://localhost:3000/api
```

### 🔐 Autenticação

```http
POST   /auth/login          # Login
POST   /auth/register       # Registro
```

### 🛍️ Produtos

```http
GET    /products                               # Listar produtos
GET    /products/:id                           # Produto por ID
POST   /products/sync                          # Sincronizar fornecedores
GET    /products?category=Books&minPrice=10    # Filtrar produtos
```

### 👤 Usuários

```http
GET    /users               # Listar usuários (admin)
GET    /users/profile       # Perfil atual
PATCH  /users/profile       # Atualizar perfil
PATCH  /users/:id           # Atualizar usuário (admin)
DELETE /users/:id           # Deletar usuário (admin)
PATCH  /users/change-password  # Alterar senha
```

### 🏢 Clientes

```http
GET    /clients/current     # Config do cliente atual (por domínio)
GET    /clients/:id         # Cliente por ID
```

### Exemplo de Requisição

```bash
# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -H "X-Client-Domain: devnology.com" \
  -d '{
    "email": "user@example.com",
    "password": "senha123"
  }'

# Listar Produtos
curl -X GET "http://localhost:3000/api/products?limit=20&category=Books" \
  -H "X-Client-Domain: devnology.com" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 📦 Dependências Principais

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| **flutter_bloc** | ^8.1.6 | Gerenciamento de estado (BLoC pattern) |
| **provider** | ^6.1.5 | State management simples (CartProvider) |
| **get_it** | ^7.7.0 | Dependency Injection (Service Locator) |
| **http** | ^1.6.0 | Cliente HTTP |
| **dartz** | ^0.10.1 | Programação funcional (Either, Option) |
| **shared_preferences** | ^2.5.3 | Cache local (tokens, produtos, config) |
| **equatable** | ^2.0.7 | Comparação de objetos (BLoC states) |
| **cupertino_icons** | ^1.0.8 | Ícones iOS |

---

## 🔧 Troubleshooting

### Problema: Cores continuam azuis (padrão)

**Causa**: O tema não está sendo aplicado corretamente.

**Solução**:
1. Verifique se o `main.dart` está usando `WhitelabelTheme.getTheme(_currentHost)`
2. Execute `flutter clean && flutter pub get`
3. Reinicie o app com `--web-hostname` correto
4. Verifique o console: deve aparecer `🌐 Domínio detectado: devnology.com`

```bash
# Exemplo correto
flutter run -d chrome --web-hostname=devnology.com --web-port=8000
```

### Problema: CORS Error

**Solução**: Configure CORS no backend NestJS:

```typescript
// main.ts
app.enableCors({
  origin: [
    'http://localhost:8000',
    'http://devnology.com:8000',
    'http://in8.com:8000'
  ],
  credentials: true,
});
```

### Problema: Token não está sendo enviado

**Solução**: Verifique se o token foi salvo corretamente:

```dart
// No console, procure por:
✅ Token salvo: eyJhbGciOiJIUzI1NiI...
🔐 Token adicionado ao header: eyJhbGciOiJIUzI1NiI...
```

Se não aparecer, verifique `auth_remote_datasource.dart` linha ~50.

### Problema: WebSocket não conecta

**Solução**:
1. Verifique se o backend Socket.IO está rodando
2. Confirme o namespace correto: `events`
3. Verifique a URL base: deve ser sem `/api`

```dart
// socket_io_service.dart
final baseUrl = AppConstants.baseUrl.replaceAll('/api', '');
final socketUrl = '$baseUrl/events';
```

### Problema: Produtos não aparecem

**Solução**:
1. Sincronize os produtos: botão "Sincronizar" na tela inicial
2. Verifique se o backend está retornando produtos
3. Limpe o cache: `SharedPreferences.clear()`

```bash
# No console, procure por:
✅ 150 produtos salvos no cache
```

### Problema: Filtros não funcionam

**Solução**:
1. Os filtros são aplicados localmente no cache
2. Se o cache está vazio, sincronize primeiro
3. Categorias devem corresponder exatamente às do backend

---

## 🎓 Conceitos Importantes

### 🎨 Whitelabel: Como Funciona?

1. **Detecção do Domínio**: `Uri.base.host` pega o domínio do navegador
2. **Busca das Cores**: `app_constants.dart` tem um mapa com as cores de cada cliente
3. **Aplicação do Tema**: `WhitelabelTheme.getTheme()` cria o tema com as cores corretas
4. **Renderização**: `MaterialApp` recebe o tema já pronto

```dart
// main.dart
String get _currentHost => Uri.base.host;  // "devnology.com"
final theme = WhitelabelTheme.getTheme(_currentHost);  // Tema verde

MaterialApp(
  theme: theme,  // ✅ Verde desde o primeiro frame
  // ...
)
```

### 💾 Cache: Estratégia de 24 Horas

- Produtos são salvos em `SharedPreferences` após sincronização
- Timestamp marca quando foi salvo
- Se passou mais de 24h, busca novamente da API
- Filtros são aplicados localmente (instantâneo)

### 🔄 Sincronização de Produtos

1. Backend conecta com fornecedores externos (APIs de terceiros)
2. Salva produtos no banco de dados
3. Flutter busca do backend e salva localmente
4. Filtros acontecem no cache local

### 🔐 Fluxo de Autenticação

1. User faz login → recebe JWT token
2. Token é salvo em `SharedPreferences`
3. Todas as requisições incluem header `Authorization: Bearer TOKEN`
4. Se token expirar (401), user é deslogado automaticamente

---

## 🚀 Deploy

### Web (Firebase Hosting)

```bash
# Build
flutter build web --release

# Deploy
firebase init
firebase deploy
```

### Android (Google Play)

```bash
# Build APK (testes)
flutter build apk --release

# Build App Bundle (recomendado para produção)
flutter build appbundle --release
```

### iOS (App Store)

```bash
# Build
flutter build ios --release

# Abra no Xcode
open ios/Runner.xcworkspace
```

---

## 📚 Comandos Úteis

```bash
# Limpar build
flutter clean

# Atualizar dependências
flutter pub get
flutter pub upgrade

# Analisar código
flutter analyze

# Formatar código
dart format lib/

# Ver dependências desatualizadas
flutter pub outdated

# Rodar testes
flutter test

# Gerar coverage
flutter test --coverage
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 🙏 Agradecimentos

- Flutter Team
- Clean Architecture by Robert C. Martin
- BLoC Library by Felix Angelov
- Comunidade Flutter Brasil

---

<div align="center">

**⭐ Se este projeto foi útil, considere dar uma estrela!**

Made with ❤️ and Flutter

</div>