import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/Servicos/autenticacao_servico.dart';
import '../classes/Produtos.dart';

class RegistrarVenda extends StatefulWidget {
  final AutenticacaoService autenticacaoService = AutenticacaoService();

  @override
  _RegistrarVendaPageState createState() => _RegistrarVendaPageState();
}

class _RegistrarVendaPageState extends State<RegistrarVenda> {
  final _formKey = GlobalKey<FormState>();
  final _quantidadeController = TextEditingController();

  String? _tipoParticipante;
  String? _identificador;
  String? _nomeParticipante;
  String? nomeFuncionarioLogado;
  String? selectedProduto;
  double selectedProdutoPrice = 0.0;
  List<Map<String, dynamic>> produtos = [];
  String? _status = 'Pendente';

  List<String> _circulos = ['Vermelho', 'Rosa', 'Verde', 'Amarelo', 'Azul'];
  List<String> _equipes = [
    'Liturgia',
    'Secretária',
    'Garçons',
    'Orden',
    'Externa',
    'Cozinha',
    'Geral',
    'Cafezinho',
    'Virgilia externa',
    'Sala'
  ];

  List<Produto> _produtos = [];
  double _totalVenda = 0.0;

  @override
  void initState() {
    super.initState();
    print('Iniciando o carregamento da tela Registrar Venda');
    getFuncionarioLogado();
    carregarProdutos();
  }

  Future<void> getFuncionarioLogado() async {
    User? user = FirebaseAuth.instance.currentUser;
    print('Usuário autenticado: ${user?.uid}');
    if (user != null) {
      DocumentSnapshot funcionarioDoc = await FirebaseFirestore.instance
          .collection('Funcionarios')
          .doc(user.uid)
          .get();
      if (funcionarioDoc.exists) {
        var funcionarioData = funcionarioDoc.data() as Map<String, dynamic>;
        setState(() {
          nomeFuncionarioLogado = funcionarioData['nome'];
          print('Nome do funcionário logado: $nomeFuncionarioLogado');
        });
      } else {
        print('Funcionario não encontrado no firestore');
      }
    }
  }

  void carregarProdutos() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Produtos').get();
      setState(() {
        produtos = snapshot.docs.map((doc) {
          return {
            'nome': doc['nome'],
            'preco': doc['preco'],
          };
        }).toList();
        print('Produtos carregados: $produtos');
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  void _adicionarProduto() {
    if (_formKey.currentState!.validate()) {
      String nome = selectedProduto!;
      double preco = selectedProdutoPrice;
      int quantidade = int.parse(_quantidadeController.text);

      Produto produto = Produto(
        nome: nome,
        quantidade: quantidade,
        preco: preco,
        status: _status!,
      );

      setState(() {
        _produtos.add(produto);
        _totalVenda += produto.preco * quantidade;
      });

      _limparCamposProduto();
    }
  }

  void _editarProduto(int index) {
  setState(() {
    _quantidadeController.text = _produtos[index].quantidade.toString();
    selectedProduto = _produtos[index].nome;
    selectedProdutoPrice = _produtos[index].preco;
    _status = _produtos[index].status;
  });
  
  // Remover o produto da lista temporariamente para permitir edição
  _removerProduto(index, removePermanente: false);
}


  void _removerProduto(int index, {bool removePermanente = true}) {
    setState(() {
      _totalVenda -= _produtos[index].preco * _produtos[index].quantidade;
      if (removePermanente) {
        _produtos.removeAt(index);
      }
    });
  }

  Future<void> _finalizarVenda() async {
  if (_produtos.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adicione pelo menos um produto antes de finalizar!')),
    );
    return;
  }

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && nomeFuncionarioLogado != null) {
    if (_nomeParticipante == null ||
        _tipoParticipante == null ||
        _identificador == null ||
        _produtos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos e adicione produtos')),
      );
      return;
    }

    try {
      CollectionReference participantes = FirebaseFirestore.instance.collection('Participantes');
      CollectionReference debitos = FirebaseFirestore.instance.collection('Debitos');

      // Verificar se o participante já existe
      QuerySnapshot participanteSnapshot = await participantes
          .where('nome', isEqualTo: _nomeParticipante)
          .where('tipo', isEqualTo: _tipoParticipante)
          .where('identificador', isEqualTo: _identificador)
          .get();

      DocumentReference participanteRef;
      if (participanteSnapshot.docs.isNotEmpty) {
        // Se o participante já existe, referenciá-lo
        participanteRef = participanteSnapshot.docs.first.reference;
      } else {
        // Se o participante não existe, criar um novo
        participanteRef = await participantes.add({
          'nome': _nomeParticipante,
          'tipo': _tipoParticipante,
          'identificador': _identificador,
        });
      }

      // Criar a venda
      DocumentReference vendaRef = await participanteRef.collection('Vendas').add({
        'funcionario': nomeFuncionarioLogado,
        'total': _totalVenda,
        'produtos': _produtos
            .map((produto) => {
                  'nome': produto.nome,
                  'quantidade': produto.quantidade,
                  'preco': produto.preco,
                  'status': produto.status,
                })
            .toList(),
        'data': Timestamp.now(),
        'status': _status,
      });

      // Salvar também na coleção "Débitos"
      await debitos.add({
        'funcionario': nomeFuncionarioLogado,
        'participanteId': participanteRef.id,
        'nomeParticipante': _nomeParticipante,
        'tipo': _tipoParticipante,
        'identificador': _identificador,
        'total': _totalVenda,
        'produtos': _produtos
            .map((produto) => {
                  'nome': produto.nome,
                  'quantidade': produto.quantidade,
                  'preco': produto.preco,
                  'status': produto.status,
                })
            .toList(),
        'data': Timestamp.now(),
        'vendaId': vendaRef.id,
        'status': _status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Venda registrada com sucesso!')),
      );

      _limparFormulario();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar venda')),
      );
    }
  }
}

  // Limpar formulário completo
  void _limparFormulario() {
    setState(() {
      _nomeParticipante = null;
      _tipoParticipante = null;
      _identificador = null;
      _produtos.clear();
      _totalVenda = 0.0;
      _status = 'Pendente'; // Resetando o status
    });
    _limparCamposProduto();
  }

  void _limparCamposProduto() {
    _quantidadeController.clear();
    selectedProduto = null;
    selectedProdutoPrice = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Venda')),
      body: nomeFuncionarioLogado == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Funcionário: $nomeFuncionarioLogado'),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Nome do Participante'),
                      onChanged: (value) {
                        setState(() {
                          _nomeParticipante = value;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe o nome do participante'
                          : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _tipoParticipante,
                      decoration:
                          InputDecoration(labelText: 'Tipo de Participante'),
                      items: ['Círculo', 'Equipe'].map((tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Text(tipo),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoParticipante = value;
                          _identificador = null;
                        });
                      },
                      validator: (value) => value == null
                          ? 'Selecione o tipo de participante'
                          : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _identificador,
                      decoration: InputDecoration(labelText: 'Identificador'),
                      items: (_tipoParticipante == 'Círculo'
                              ? _circulos
                              : _equipes)
                          .map((id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(id),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _identificador = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione um identificador' : null,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Produtos (${_produtos.length}) - Total: R\$ $_totalVenda',
                      style: TextStyle(fontSize: 18),
                    ),
                    // Dropdown para selecionar produto
                    DropdownButtonFormField<String>(
                      value: selectedProduto,
                      decoration:
                          InputDecoration(labelText: 'Selecione um Produto'),
                      items: produtos.map((produto) {
                        return DropdownMenuItem<String>(
                          value: produto['nome'],
                          child: Text(
                              '${produto['nome']} - R\$ ${produto['preco']}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProduto = value;
                          selectedProdutoPrice = produtos
                              .firstWhere((p) => p['nome'] == value)['preco'];
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione um produto' : null,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _quantidadeController,
                            decoration:
                                InputDecoration(labelText: 'Quantidade'),
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Informe a quantidade'
                                : null,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _adicionarProduto,
                        ),
                      ],
                    ),
                    // Dropdown para selecionar o status da venda
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(labelText: 'Status'),
                      items: [
                        'Pendente',
                        'Pago',
                      ].map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione um status' : null,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _finalizarVenda,
                      child: Text('Finalizar Venda'),
                    ),
                    SizedBox(height: 16.0),
                    // Lista de produtos adicionados
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final produto = _produtos[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title:
                                Text('${produto.nome} - R\$ ${produto.preco}'),
                            subtitle: Text('Quantidade: ${produto.quantidade}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editarProduto(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removerProduto(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
