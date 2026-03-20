# mobile_arquitetura_02 — Questionário de Reflexão

## 1. Em qual camada foi implementado o mecanismo de cache? Explique por que essa decisão é adequada.

O cache foi implementado na camada **data**, no arquivo `data/datasources/productcachedatasource.dart` (`ProductCacheDatasource`). O uso do cache é coordenado pelo `ProductRepositoryImpl`, também na camada `data`:

```dart

final cached = cache.get();
if (cached != null) {
  return cached.map((m) => Product(...)).toList();
}
throw Failure("Não foi possível carregar os produtos");
```

**Por que é adequado:** o cache é uma responsabilidade de acesso a dados — ele decide de onde os dados vêm. Não é uma regra de negócio nem uma decisão de interface. Mantê-lo na camada `data` permite que as camadas `domain` e `presentation` permaneçam completamente ignorantes de sua existência. Além disso, se o cache precisasse ser trocado por uma solução persistente (`shared_preferences`, `Hive`), apenas `ProductCacheDatasource` precisaria ser alterado.

---

## 2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?

O `ProductViewModel` recebe apenas um `ProductRepository` (contrato abstrato) e nunca importa `Dio` nem conhece URLs:

```dart
class ProductViewModel {
  final ProductRepository repository; // depende da abstração, não da implementação
  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);
    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(products: products, isLoading: false);
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

Realizar HTTP diretamente no ViewModel violaria a arquitetura por quatro razões:

- **Separação de responsabilidades:** o ViewModel gerencia estado (loading, erro, dados); o DataSource executa I/O. Misturar os dois torna cada classe difícil de entender e modificar.
- **Testabilidade:** dependendo do contrato `ProductRepository`, o ViewModel pode ser testado com um mock sem precisar de rede real.
- **Troca transparente de fonte:** o repositório pode ser substituído por um banco local sem alterar nenhuma linha do ViewModel.
- **Regra arquitetural:** camadas superiores (presentation) só conversam com camadas imediatamente abaixo (domain), nunca pulando para data.

---

## 3. O que poderia acontecer se a interface acessasse diretamente o DataSource?

Se a `ProductPage` chamasse o `ProductRemoteDatasource` diretamente, bypassando ViewModel e Repository:

- **Violação de separação de responsabilidades:** a UI passaria a conhecer Dio, URLs e formato de resposta da API — responsabilidades que não são dela.
- **Cache inacessível:** a lógica de fallback para `ProductCacheDatasource` está no Repository. Sem ele, o cache nunca seria consultado em caso de falha.
- **Ausência de tratamento de erros padronizado:** exceções de rede chegariam cruas à interface, sem passar pelo `Failure` da camada `core`.
- **Sem gerenciamento de estado:** os estados `isLoading` e `error` são controlados pelo `ProductViewModel`. Bypassá-lo exigiria duplicar toda essa lógica dentro do widget.
- **Impossibilidade de teste:** um widget que depende diretamente de Dio não pode ser testado sem rede real.

Em resumo: a interface ficaria responsável por rede, cache, tratamento de erros e estado simultaneamente — contrariando todos os princípios da arquitetura em camadas.

---

## 4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?

A troca é possível sem tocar em nenhuma camada acima de `data`, graças ao contrato definido em `domain`:

```dart
// domain/repositories/product_repository.dart
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
```

O processo de substituição seria:

1. Criar `ProductLocalDatasource` que lê de SQLite ou Hive.
2. Criar (ou adaptar) um `ProductRepositoryImpl` que usa o novo DataSource.
3. Registrar a nova implementação em `main.dart` (injeção de dependência já feita manualmente no projeto).

**O que não precisa ser alterado:** `ProductViewModel`, `ProductPage`, `ProductState`, a entidade `Product` e `Failure`. Todas essas classes dependem apenas da abstração `ProductRepository`, não da implementação concreta.

Isso demonstra na prática o **Princípio da Inversão de Dependência (DIP):** módulos de alto nível (presentation, domain) não dependem de módulos de baixo nível (data). Ambos dependem de abstrações.

# Atividade 07 — Navegação entre Telas com Flutter

## Questionário

**1. Qual era a estrutura do projeto antes da inclusão das novas telas?**

O projeto tinha só uma tela, a `ProductPage`, que listava os produtos da API. Não tinha tela inicial nem tela de detalhes, e não havia nenhuma navegação.

---

**2. Como ficou o fluxo da aplicação após a implementação da navegação?**

Ficou assim:

```
HomePage → ProductPage → ProductDetailPage
```

A tela inicial leva para a lista, e ao clicar num produto abre a tela de detalhes. De lá dá pra voltar para a lista ou direto para a tela inicial.

---

**3. Qual é o papel do `Navigator.push()` no projeto?**

Ele abre uma nova tela por cima da atual. Usei ele duas vezes: uma para ir da `HomePage` para a `ProductPage`, e outra para ir da `ProductPage` para a `ProductDetailPage`.

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const ProductPage()),
);
```

---

**4. Qual é o papel do `Navigator.pop()` no projeto?**

Ele fecha a tela atual e volta para a anterior. Usei no botão "Voltar para a lista" na tela de detalhes. Também usei o `popUntil` para voltar direto à tela inicial.

```dart
Navigator.pop(context); // volta uma tela

Navigator.of(context).popUntil((route) => route.isFirst); // volta para o início
```

---

**5. Como os dados do produto selecionado foram enviados para a tela de detalhes?**

Passei o produto pelo construtor da `ProductDetailPage` na hora de navegar:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ProductDetailPage(product: product),
  ),
);
```

---

**6. Por que a tela de detalhes depende das informações da tela anterior?**

Porque ela não busca nada da API, só exibe o que recebe. Quem carrega os produtos é a `ProductPage`, então os dados já vêm prontos quando a tela de detalhes é aberta.

---

**7. Quais foram as principais mudanças feitas no projeto original?**

- Criei a `HomePage` como nova tela inicial
- Criei a `ProductDetailPage` com todas as informações do produto
- Atualizei o `ProductModel` para incluir `description`, `category` e `rating`
- Os cards da lista agora são clicáveis
- O `main.dart` passou a iniciar na `HomePage`

---

**8. Quais dificuldades você encontrou durante a adaptação do projeto para múltiplas telas?**

A maior dificuldade foi entender a diferença entre `pop()` e `popUntil()`, porque no começo eu não sabia como voltar direto para a tela inicial sem passar pela lista de novo. Também tive que atualizar vários arquivos por causa dos novos campos no modelo, o que deu alguns erros de compilação até ajustar tudo.