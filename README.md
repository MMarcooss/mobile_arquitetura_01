# Projeto Produtos com Autenticacao

Aplicativo Flutter para gerenciamento de produtos com autenticacao via API DummyJSON.

## Pre-requisitos

- Flutter SDK >= 3.9.2
- Dart SDK
- Android Studio / VS Code
- Emulador ou dispositivo fisico

## Como Rodar

### Windows

```bash
# Clonar o repositorio
git clone https://github.com/MMarcooss/mobile_arquitetura_01.git
cd mobile_arquitetura_01/product_app

# Instalar dependencias
flutter pub get

# Executar o app
flutter run
```

### Linux

```bash
# Clonar o repositorio
git clone https://github.com/MMarcooss/mobile_arquitetura_01.git
cd mobile_arquitetura_01/product_app

# Instalar dependencias
flutter pub get

# Executar o app
flutter run
```

### Credenciais de Teste

- **Usuario:** emilys
- **Senha:** emilyspass

## Estrutura do Projeto

```
lib/
├── main.dart                          # Ponto de entrada
├── core/errors/failure.dart           # Tratamento de erros
├── data/
│   ├── datasources/                   # Fontes de dados (API + cache)
│   ├── models/                        # Modelos de dados
│   └── repositories/                  # Implementacao dos repositorios
├── domain/
│   ├── entities/                      # Entidades de negocio
│   ├── repositories/                  # Contratos dos repositorios
│   └── services/                      # Servicos (auth + produtos)
├── presentation/
│   ├── pages/                         # Telas do app
│   └── providers/                     # Gerenciamento de estado
└── sessions/                          # Controle de sessao do usuario
```

## Funcionalidades

- Login com autenticacao via DummyJSON API
- Listagem de produtos com imagem, titulo e preco
- Detalhes do produto (nome, preco, descricao, imagem)
- Criar e editar produtos
- Controle de favoritos
- Logout

## API Utilizada

- **Autenticacao:** `https://dummyjson.com/auth/login`
- **Produtos:** `https://dummyjson.com/products`
