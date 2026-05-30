# Atv_supplier

Aplicacao Flutter Web para a atividade de persistencia de dados.

## Tema

- Aluno: Pedro Gabriel Sepulveda Borgheti
- Classe de modelo: `Supplier`
- Tema: CRUD de fornecedores

Cada fornecedor possui:

- Nome
- CNPJ ficticio
- Telefone
- Data de contrato, preenchida automaticamente no dia do cadastro

## Comentários (manual)
// comentário sem correção (redação e perfumaria) de ia 

OBS:  Tive bastante problemas na persistencia de dados, principalmente na parte de fechar o "app", tive que fazer essa gambiarra de portas, mas a ideia do json está lá... obviamente, ainda não vi sobre implementar em algum sgbd para resolver o problema.

No enunciado pedia somente CRUD de fornecedores e não os produtos, mediante isto, deixei somente um campo lá para descrição (EXP: fornecedor tal fornece pedras).
Itens que usei a i.a 
- TESTESSSS
- Arquivos gigantes que não sei inserir os dados nos arquivos - tipo o .metadata (???)
- Problema das portas e muita escrita de código pra facilitar os problemas (redação ou redição das brincadeiras ).

## Organizacao do projeto

- `lib/models/`: contem a classe de negocio `Supplier`, responsavel pelos dados do fornecedor e pelos metodos `toJson` e `fromJson`.
- `lib/repositories/`: contem `SupplierRepository`, repositorio local que salva, carrega e limpa a lista de fornecedores com `SharedPreferences`.
- `lib/pages/`: contem as telas do app, separando login, listagem e formulario de cadastro/edicao.

## Login do sistema

A aplicacao inicia em uma tela de login separada. Para teste, use:

- Email: `teste`
- Senha: `teste`

A tela possui validacao de campos obrigatorios, mensagem de erro com `SnackBar` e botao para alternar entre modo claro e modo escuro.

## Fluxo do CRUD

1. Apos o login, a aplicacao abre a tela `SupplierListPage`, que carrega automaticamente os dados salvos localmente.
2. A coluna lateral possui botoes para Painel, Estoque completo, Novo fornecedor, Limpar dados, SAC, Modo claro/escuro e Sair.
3. O botao `Fornecedor` ou `Novo fornecedor` abre o formulario para cadastrar um novo registro.
4. Ao tocar em um item ou no icone de edicao, o mesmo formulario abre preenchido para alteracao.
5. O icone de lixeira pede confirmacao antes de remover um fornecedor.
6. O botao de limpar dados pede confirmacao antes de apagar todos os registros.
7. Toda inclusao, alteracao, remocao ou limpeza exibe mensagem de retorno com `SnackBar`.

## Perfumarias adicionadas

- Tela de login com credenciais de teste.
- Modo claro e modo escuro.
- Coluna lateral com botoes de navegacao.
- Tela de painel com resumo dos fornecedores.
- Tela `Estoque completo` com a lista completa em tabela.
- Lista de fornecedores com cards reordenaveis por arrastar.
- Botao de SAC exibindo o email ficticio `atendimento@sistema.com`.
- Botao de sair para voltar ao login.

## Persistencia

A persistencia usa o pacote `shared_preferences`. A lista de objetos `Supplier` e convertida para JSON com `jsonEncode` antes de ser salva e e reconstruida com `jsonDecode` ao abrir a tela de listagem.

No Flutter Web, o `SharedPreferences` salva os dados no armazenamento local do navegador para a mesma origem da aplicacao. Por isso, para testar se os dados continuam apos fechar e abrir novamente, e importante usar sempre o mesmo endereco, incluindo host e porta.

Para demonstrar a persistencia de forma mais estavel, gere o build web e sirva a pasta em uma porta fixa:

```bash
flutter build web
cd build/web
python3 -m http.server 5502 --bind 127.0.0.1
```

Depois, abra manualmente no Chrome:

```text

```

Com esse fluxo, os dados cadastrados ficam salvos no armazenamento local do Chrome para esse endereco. Eles permanecem apos fechar a aba, fechar o navegador e abrir novamente o mesmo endereco, desde que os dados do site nao sejam apagados pelo usuario ou pelo navegador.

Para desenvolvimento com hot reload, tambem e possivel fixar a porta:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5502
```

## Evidencias de execucao

Comandos usados para validar a aplicacao:

```bash
flutter analyze
flutter test
flutter build web
```

Resultado esperado: analise sem problemas, testes aprovados e build web gerado em `build/web`.
// as demais evidencias que o enunciado pediu deixei em um video enviado ao professor diretamente, espero que não atrapalhe a avaliação.
## Observacoes manuais

Use este espaco para registrar observacoes, testes realizados, prints ou comentarios da apresentacao:

```text
Data do teste:

Endereco utilizado:

Registros cadastrados:

Resultado apos fechar e abrir novamente:

Observacoes:
```

## Como executar no Chrome

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5502
```
