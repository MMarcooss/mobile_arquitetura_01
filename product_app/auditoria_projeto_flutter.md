# Auditoria Automatizada — Projeto Flutter `mobile_arquitetura_01`

## Contexto

Você é um avaliador técnico especialista em Flutter e Dart. Sua tarefa é **analisar o repositório GitHub abaixo** e verificar se cada um dos 30 requisitos obrigatórios foi atendido.

> **Repositório a analisar:** `[COLE AQUI O LINK DO SEU REPOSITÓRIO GITHUB]`

---

## Instruções de Análise

1. Acesse o repositório e leia **todos os arquivos** relevantes: `pubspec.yaml`, arquivos `.dart` em `lib/`, estrutura de pastas, `README.md` (se houver).
2. Para cada item do checklist abaixo, emita um veredicto: ✅ **Atendido**, ❌ **Não atendido** ou ⚠️ **Parcialmente atendido**.
3. Para cada veredicto, cite **o arquivo e trecho de código** que justifica sua conclusão.
4. Ao final, gere um **resumo executivo** com a contagem de itens atendidos, parcialmente atendidos e não atendidos, e aponte os pontos críticos que precisam de correção antes da entrega.

---

## Checklist Consolidado (30 itens obrigatórios)

### 🗂️ Repositório e Projeto

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 1 | Repositório chamado `mobile_arquitetura_01` | | |
| 2 | Projeto Flutter executável (pubspec.yaml válido, sem erros de compilação aparentes) | | |
| 3 | Organização em camadas ou pastas separadas (ex: `models/`, `services/`, `screens/`, `providers/`) | | |
| 4 | Uso da API **DummyJSON** (`https://dummyjson.com`) | | |

### 🔐 Autenticação e Sessão

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 5 | Tela de login implementada | | |
| 6 | Validação de usuário e senha (campos não vazios e/ou regras básicas) | | |
| 7 | `POST /auth/login` funcionando corretamente | | |
| 8 | Tratamento de erro no login (ex: credenciais inválidas exibem mensagem) | | |
| 9 | Sessão de usuário autenticado mantida após login (token ou objeto de usuário) | | |
| 10 | Bloqueio de acesso às telas protegidas sem login | | |

### 🛍️ Tela Principal de Produtos

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 11 | Tela principal de produtos implementada | | |
| 12 | Nome do usuário autenticado exibido na tela principal | | |
| 13 | Botão de logout presente e funcional | | |
| 14 | `GET /products` funcionando e retornando lista de produtos | | |
| 15 | Modelo `Product` ajustado para o formato de resposta do DummyJSON | | |
| 16 | Lista exibe título, preço e imagem de cada produto | | |

### 📄 Tela de Detalhes do Produto

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 17 | Tela de detalhes do produto implementada | | |
| 18 | `GET /products/{id}` utilizado **ou** produto selecionado passado via navegação | | |
| 19 | Detalhes exibem: nome, preço, descrição e imagem | | |

### 🧭 Navegação

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 20 | Navegação entre telas implementada | | |
| 21 | Uso de `Navigator.push` ou rotas nomeadas (`go_router`, `onGenerateRoute`, etc.) | | |
| 22 | Uso de `Navigator.pop` (voltar de tela de detalhes, por exemplo) | | |

### ❤️ Controle de Favoritos

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 23 | Funcionalidade de marcar produto como favorito | | |
| 24 | Funcionalidade de remover produto dos favoritos | | |
| 25 | Interface atualizada automaticamente ao favoritar/desfavoritar (sem precisar recarregar a tela) | | |

### ⚙️ Arquitetura e Gerenciamento de Estado

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 26 | Uso de **Provider**, **Riverpod**, **BLoC** ou `setState` com justificativa clara no código | | |
| 27 | Separação clara entre: modelo (`model`), serviço (`service`), sessão (`session`/`auth`) e tela (`screen`/`page`) | | |

### 🔄 Tratamento de Estado da UI

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 28 | Tratamento de **carregamento** (ex: `CircularProgressIndicator` enquanto busca dados) | | |
| 29 | Tratamento de **erro nas requisições** (ex: mensagem de erro quando API falha) | | |

### ✅ Item Bônus / Geral

| # | Requisito | Veredicto | Evidência (arquivo / trecho) |
|---|-----------|-----------|------------------------------|
| 30 | Projeto coeso, funcional e sem inconsistências graves que impeçam a execução | | |

---

## Resumo Executivo (preencha ao final)

```
Total de itens:          30
✅ Atendidos:            __
⚠️  Parcialmente:        __
❌ Não atendidos:        __

Nota estimada: __ / 30
```

### Pontos críticos que precisam de correção:
1. ...
2. ...
3. ...

### Observações adicionais:
- ...

---

*Spec gerada para auditoria com modelo de IA. Substitua o link do repositório antes de usar.*
