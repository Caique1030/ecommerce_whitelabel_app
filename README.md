# ecommerce_whitelabel_app

A new Flutter module project.

## Getting Started

For help getting started with Flutter development, view the online
[documentation](https://flutter.dev/).

For instructions integrating Flutter modules to your existing applications,
see the [add-to-app documentation](https://flutter.dev/to/add-to-app).

# Criar o projeto Flutter

flutter create ecommerce_whitelabel_app

# Entrar no diretório do projeto

cd ecommerce_whitelabel_app

# Adicionar dependências necessárias

flutter pub add http dio shared_preferences provider flutter_secure_storage equatable dartz
flutter pub add_dev build_runner

```

## 📁 Estrutura de Pastas

Depois de criar o projeto, organize a estrutura de pastas assim:
```

lib/
├── main.dart
├── core/
│ ├── constants/
│ │ └── app_constants.dart
│ ├── errors/
│ │ ├── exceptions.dart
│ │ └── failures.dart
│ ├── network/
│ │ └── api_client.dart
│ ├── theme/
│ │ ├── app_theme.dart
│ │ └── whitelabel_theme.dart
│ └── utils/
│ └── domain_helper.dart
├── features/
│ ├── auth/
│ │ ├── data/
│ │ │ ├── datasources/
│ │ │ │ └── auth_remote_datasource.dart
│ │ │ ├── models/
│ │ │ │ └── user_model.dart
│ │ │ └── repositories/
│ │ │ └── auth_repository_impl.dart
│ │ ├── domain/
│ │ │ ├── entities/
│ │ │ │ └── user.dart
│ │ │ ├── repositories/
│ │ │ │ └── auth_repository.dart
│ │ │ └── usecases/
│ │ │ ├── sign_in.dart
│ │ │ ├── sign_up.dart
│ │ │ └── sign_out.dart
│ │ └── presentation/
│ │ ├── bloc/
│ │ │ ├── auth_bloc.dart
│ │ │ ├── auth_event.dart
│ │ │ └── auth_state.dart
│ │ ├── pages/
│ │ │ ├── login_page.dart
│ │ │ └── register_page.dart
│ │ └── widgets/
│ │ ├── login_form.dart
│ │ └── register_form.dart
│ ├── products/
│ │ ├── data/
│ │ │ ├── datasources/
│ │ │ │ └── products_remote_datasource.dart
│ │ │ ├── models/
│ │ │ │ └── product_model.dart
│ │ │ └── repositories/
│ │ │ └── products_repository_impl.dart
│ │ ├── domain/
│ │ │ ├── entities/
│ │ │ │ └── product.dart
│ │ │ ├── repositories/
│ │ │ │ └── products_repository.dart
│ │ │ └── usecases/
│ │ │ ├── get_products.dart
│ │ │ ├── filter_products.dart
│ │ │ └── get_product_by_id.dart
│ │ └── presentation/
│ │ ├── bloc/
│ │ │ ├── products_bloc.dart
│ │ │ ├── products_event.dart
│ │ │ └── products_state.dart
│ │ ├── pages/
│ │ │ ├── products_list_page.dart
│ │ │ └── product_detail_page.dart
│ │ └── widgets/
│ │ ├── product_card.dart
│ │ ├── product_filter.dart
│ │ └── product_grid.dart
│ └── client/
│ ├── data/
│ │ ├── datasources/
│ │ │ └── client_remote_datasource.dart
│ │ ├── models/
│ │ │ └── client_model.dart
│ │ └── repositories/
│ │ └── client_repository_impl.dart
│ ├── domain/
│ │ ├── entities/
│ │ │ └── client.dart
│ │ ├── repositories/
│ │ │ └── client_repository.dart
│ │ └── usecases/
│ │ └── get_client_config.dart
│ └── presentation/
│ └── provider/
│ └── whitelabel_provider.dart
└── injection_container.dart

quero criar um projeto front end , com base nessa estrutura. Para que eu possa rodar os comandos. Seria no cmd normal ou eu devo fazer diretamente no terminal do vsCode. Pois nao sei se esses comandos irão funcionar

$ flutter run -d chrome --web-hostname=devnology.com --web-port=8000
