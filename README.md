# 🛍️ E-Commerce Whitelabel App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20iOS%20%7C%20Android-lightgrey?style=for-the-badge)

**Aplicativo E-commerce Multi-tenant com Arquitetura Limpa**

[Características](#-características) •
[Instalação](#-instalação) •
[Configuração](#️-configuração) •
[Uso](#-uso) •
[Arquitetura](#-arquitetura) •
[API](#-api)

</div>

---

## 📋 Sobre o Projeto

Sistema de e-commerce **whitelabel** desenvolvido em Flutter que permite múltiplos clientes (tenants) utilizarem a mesma base de código com diferentes identidades visuais e configurações. O app consome uma API NestJS e suporta múltiplos fornecedores de produtos.

### ✨ Principais Diferenciais

- 🎨 **Whitelabel**: Temas dinâmicos por cliente (cores, logos, nome)
- 🏢 **Multi-tenant**: Suporta múltiplos clientes na mesma aplicação
- 🔄 **Sincronização Automática**: Integração com múltiplos fornecedores
- 💾 **Cache Inteligente**: Sistema de cache local para melhor performance
- 🔐 **Autenticação JWT**: Sistema seguro de autenticação
- 🌐 **WebSocket**: Atualizações em tempo real
- 📱 **Responsivo**: Funciona em Web, iOS e Android

---

## 🎯 Características

### 🛒 Funcionalidades de E-commerce

- ✅ Listagem de produtos com filtros avançados
- ✅ Busca por nome, categoria e faixa de preço
- ✅ Carrinho de compras
- ✅ Detalhes do produto com galeria de imagens
- ✅ Ofertas e descontos
- ✅ Categorização de produtos

### 👤 Gestão de Usuários

- ✅ Registro e login
- ✅ Autenticação JWT
- ✅ Perfil do usuário
- ✅ Edição de dados pessoais
- ✅ Troca de senha

### 🎨 Whitelabel

- ✅ Cores primárias e secundárias customizáveis
- ✅ Logo personalizada por cliente
- ✅ Nome da aplicação dinâmico
- ✅ Temas configuráveis via API

### ⚡ Performance

- ✅ Cache local com SharedPreferences
- ✅ Sincronização de produtos em background
- ✅ Filtros locais para respostas instantâneas
- ✅ Lazy loading de produtos

---

## 🚀 Instalação

### Pré-requisitos

Certifique-se de ter instalado:

- [Flutter](https://flutter.dev/docs/get-started/install) 3.0 ou superior
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

### 3️⃣ Configurar Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto (opcional, se usar dotenv):

```env
API_BASE_URL=http://localhost:3000/api
WS_URL=http://localhost:3000
```

### 4️⃣ Verificar Instalação

```bash
flutter doctor
```

---

## ⚙️ Configuração

### 🌐 Configuração da API

Edite o arquivo `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // 🔧 Configuração da API
  static const String baseUrl = 'http://localhost:3000/api';
  
  // 🔧 Configuração WebSocket
  static const String wsNamespace = 'events';
  
  // 🔧 Domínios dos Clientes
  static const Map<String, String> clientDomains = {
    'localhost': 'localhost',
    'devnology': 'devnology.com',
    'in8': 'in8.com',
  };
}
```

### 🎨 Configuração de Temas

As cores e temas são carregados dinamicamente da API, mas você pode definir valores padrão em `lib/core/theme/app_theme.dart`.

---

## 🖥️ Uso

### Executar no Chrome (Web)

```bash
flutter run -d chrome --web-hostname=devnology.com --web-port=8000
```

### Executar no Android

```bash
flutter run -d android
```

### Executar no iOS

```bash
flutter run -d ios
```

### Build para Produção

#### Web
```bash
flutter build web --release
```

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                          # Entry point
│
├── core/                              # Núcleo da aplicação
│   ├── constants/
│   │   └── app_constants.dart        # Constantes globais
│   ├── errors/
│   │   ├── exceptions.dart           # Exceções customizadas
│   │   └── failures.dart             # Tratamento de falhas
│   ├── network/
│   │   └── api_client.dart           # Cliente HTTP
│   ├── services/
│   │   └── socket_io_service.dart    # WebSocket service
│   ├── navigation/
│   │   └── main_navigation.dart      # Navegação principal
│   └── theme/
│       ├── app_theme.dart            # Tema global
│       └── whitelabel_theme.dart     # Tema whitelabel
│
├── features/                          # Funcionalidades (Clean Architecture)
│   │
│   ├── auth/                         # 🔐 Autenticação
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in.dart
│   │   │       ├── sign_up.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── register_form.dart
│   │
│   ├── products/                     # 🛍️ Produtos
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── product_remote_datasources.dart
│   │   │   ├── models/
│   │   │   │   └── product_model.dart
│   │   │   └── repositories/
│   │   │       └── products_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product.dart
│   │   │   ├── repositories/
│   │   │   │   └── products_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_products.dart
│   │   │       ├── filter_products.dart
│   │   │       ├── get_products_by_id.dart
│   │   │       └── sync_product.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── products_bloc.dart
│   │       │   ├── products_event.dart
│   │       │   └── products_state.dart
│   │       ├── pages/
│   │       │   ├── products_list_page.dart
│   │       │   ├── products_detail_page.dart
│   │       │   ├── cart_page.dart
│   │       │   ├── category_page.dart
│   │       │   └── offers_page.dart
│   │       └── widgets/
│   │           ├── product_card.dart
│   │           ├── products_filter.dart
│   │           └── products_grid.dart
│   │
│   ├── client/                       # 🏢 Configuração de Clientes
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── client_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── client_model.dart
│   │   │   └── repositories/
│   │   │       └── client_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── client.dart
│   │   │   ├── repositories/
│   │   │   │   └── client_repository.dart
│   │   │   └── usecases/
│   │   │       └── GetClientConfig.dart
│   │   └── presentation/
│   │       └── provider/
│   │           └── whitelabel_provider.dart
│   │
│   └── users/                        # 👤 Gestão de Usuários
│       ├── data/
│       │   ├── datasources/
│       │   │   └── user_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── user_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart
│       │   ├── repositories/
│       │   │   └── user_repository.dart
│       │   └── usecases/
│       │       ├── get_user.dart
│       │       ├── get_profile.dart
│       │       ├── update_user.dart
│       │       ├── update_profile.dart
│       │       ├── change_password.dart
│       │       ├── delete_user.dart
│       │       └── get_all_users.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── user_bloc.dart
│           │   ├── user_event.dart
│           │   └── user_state.dart
│           └── pages/
│               └── user_edit_page.dart
│
└── injection_container.dart           # 💉 Injeção de Dependências (GetIt)
```

---

## 🏗️ Arquitetura

Este projeto segue os princípios da **Clean Architecture** proposta por Robert C. Martin, combinada com o padrão **BLoC** (Business Logic Component) para gerenciamento de estado.

### 📐 Camadas

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Widgets, BLoC, Pages, Providers)  │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)    │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Data Layer                    │
│  (Models, Datasources, Repositories)    │
└─────────────────────────────────────────┘
```

### 🔄 Fluxo de Dados

```
User Action → Event → BLoC → Use Case → Repository → DataSource → API
                 ↓
              State → UI Update
```

### 🧩 Principais Componentes

#### **BLoC Pattern**
Gerenciamento de estado reativo e previsível.

```dart
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;
  
  ProductsBloc({required this.getProducts}) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }
}
```

#### **Use Cases**
Lógica de negócio isolada e testável.

```dart
class GetProducts {
  final ProductsRepository repository;
  
  Future<Either<Failure, List<Product>>> call(params) async {
    return await repository.getProducts(/* ... */);
  }
}
```

#### **Repositories**
Abstração para fontes de dados.

```dart
abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
```

---

## 🔌 API

### Base URL

```
http://localhost:3000/api
```

### Endpoints Principais

#### 🔐 Autenticação

```http
POST /auth/login
POST /auth/register
```

#### 🛍️ Produtos

```http
GET    /products
GET    /products/:id
POST   /products/sync
GET    /products?category=Computers&minPrice=100&maxPrice=500
```

#### 👤 Usuários

```http
GET    /users
GET    /users/profile
PATCH  /users/profile
PATCH  /users/:id
DELETE /users/:id
PATCH  /users/change-password
```

#### 🏢 Clientes

```http
GET /clients/current
GET /clients/:id
```

### Exemplo de Requisição

```bash
# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "senha123"
  }'

# Listar Produtos
curl -X GET "http://localhost:3000/api/products?limit=20" \
  -H "X-Client-Domain: devnology.com"
```

---

## 🧪 Testes

### Executar Testes

```bash
# Todos os testes
flutter test

# Testes com coverage
flutter test --coverage

# Visualizar coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📦 Dependências Principais

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| flutter_bloc | ^8.1.3 | Gerenciamento de estado |
| provider | ^6.1.1 | Injeção de dependências simples |
| get_it | ^7.6.4 | Service locator |
| http | ^1.1.0 | Cliente HTTP |
| socket_io_client | ^2.0.3+1 | WebSocket |
| dartz | ^0.10.1 | Programação funcional |
| shared_preferences | ^2.2.2 | Cache local |
| equatable | ^2.0.5 | Comparação de objetos |

---

## 🌐 Executar para Web (Chrome)

### Desenvolvimento Local

```bash
flutter run -d chrome --web-hostname=localhost --web-port=8000
```

### Produção (devnology.com)

```bash
flutter run -d chrome --web-hostname=devnology.com --web-port=8000
```

### Configurar Hosts (Opcional)

Para testar diferentes clientes localmente, edite o arquivo de hosts:

**Windows**: `C:\Windows\System32\drivers\etc\hosts`  
**Mac/Linux**: `/etc/hosts`

```
127.0.0.1 devnology.com
127.0.0.1 in8.com
127.0.0.1 localhost
```

### Build de Produção

```bash
# Build otimizado
flutter build web --release --web-renderer html

# Servir localmente
cd build/web
python -m http.server 8000
```

---

## 🔧 Troubleshooting

### Problema: CORS Error

**Solução**: Configure CORS no backend NestJS:

```typescript
// main.ts
app.enableCors({
  origin: ['http://localhost:8000', 'http://devnology.com:8000'],
  credentials: true,
});
```

### Problema: Cache não funciona

**Solução**: Limpe o cache do SharedPreferences:

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

### Problema: WebSocket não conecta

**Solução**: Verifique a URL e namespace:

```dart
// socket_io_service.dart
final socketUrl = '$baseUrl/events'; // ✅ Namespace correto
```

---

## 🚢 Deploy

### Deploy Web (Firebase Hosting)

```bash
# Build
flutter build web --release

# Firebase
firebase deploy
```

### Deploy Android (Google Play)

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recomendado)
flutter build appbundle --release
```

### Deploy iOS (App Store)

```bash
flutter build ios --release
```

---

## 📝 Comandos Úteis

```bash
# Limpar build
flutter clean

# Atualizar dependências
flutter pub upgrade

# Analisar código
flutter analyze

# Formatar código
dart format lib/

# Gerar ícones
flutter pub run flutter_launcher_icons:main

# Ver dependências desatualizadas
flutter pub outdated
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👥 Autores

- **Seu Nome** - *Desenvolvimento inicial* - [seu-usuario](https://github.com/seu-usuario)

---

## 🙏 Agradecimentos

- Flutter Team
- Clean Architecture by Robert C. Martin
- BLoC Library
- Comunidade Flutter Brasil

---

## 📞 Contato

- Email: seu-email@example.com
- LinkedIn: [seu-perfil](https://linkedin.com/in/seu-perfil)
- Website: [seu-site.com](https://seu-site.com)

---

<div align="center">

**⭐ Se este projeto foi útil, considere dar uma estrela!**

Made with ❤️ and Flutter

</div>