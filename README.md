# Gerenciamento-de-Debitos
Sistema de Gerenciamento de Débitos EJC
Este é um projeto desenvolvido como Trabalho de Conclusão de Curso (TCC) no curso de Sistemas de Informação. Ele tem como objetivo automatizar o gerenciamento de débitos e vendas durante os encontros do Encontro de Jovens com Cristo (EJC).

## Funcionalidades
- Cadastro produtos
- Registrar vendas
- Registrar Pagamentos
- Consultar Débitos
- Listar Pagamentos
- Gerar Relatório de Produto mais vendido
- Integração com Firebase Firestore para armazenamento de dados.

## Estrutura de Coleções - SGDejc

## Participantes
-**id**: string
- **nome**:string
- **tipo**: string (circulo ou equipe)
- **Vendas**:subcoleção
  -**data**:timestamp
  -**funcionario**:string
  -**produtos**: array de produtos{
  nome:string
  preco:number
  quantidade:string
  status:string

## Funcionarios
-**id**:string
-**nome**:string
-**telefone**:string

## Debitos
- **data**:timestamp
- **funcionario**:string
- **identificador**:string
- **nomeParticipante**:string
- **participanteID**:string
- **produtos**:array de objetos
- nome:string
- preco:number
- quantidade:number
- status:string
  **vendaID**string

  ## Pagamentos
  - **dataPagamento**:timestamp
  - **debitoID**:string
  - **descricao**:string
  - **identificador**:string
  - **nomeFuncionario**string
  - **nomeParticipante**:string
  - **nomeProduto**:string
  - status:string
  - **valor**:number
 
    ## Produtos
    -**nome**:string
    -**preco**:number
    -**data da compra**:timestamp
    -**descricao**:string
 
## Tecnologias Utilizadas
- **Flutter**: Framework para desenvolvimento multiplataforma.
- **Firebase Firestore**: Banco de dados NoSQL para armazenamento.
- **Dart**: Linguagem de programação.

