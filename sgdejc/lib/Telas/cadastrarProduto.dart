import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastrarProduto extends StatefulWidget {
  @override
  _CadastrarProdutoState createState() => _CadastrarProdutoState();
}

class _CadastrarProdutoState extends State<CadastrarProduto> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();

  String? _produtoId; // Variável para armazenar o ID do produto ao editar

  // Função para salvar ou editar o produto no Firestore
  Future<void> _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      if (_produtoId == null) {
        // Novo produto
        await FirebaseFirestore.instance.collection('Produtos').add({
          'nome': _nomeController.text,
          'preco': double.tryParse(_precoController.text) ?? 0.0,
          'descricao': _descricaoController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto cadastrado com sucesso!')),
        );
      } else {
        // Editar produto existente
        await FirebaseFirestore.instance
            .collection('Produtos')
            .doc(_produtoId)
            .update({
          'nome': _nomeController.text,
          'preco': double.tryParse(_precoController.text) ?? 0.0,
          'descricao': _descricaoController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
      }
      _limparCampos();
    }
  }

  // Função para remover produto
  Future<void> _removerProduto(String produtoId) async {
    await FirebaseFirestore.instance.collection('Produtos').doc(produtoId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produto removido com sucesso!')),
    );
  }

  // Função para preencher os campos ao editar
  void _preencherCamposParaEdicao(
      String produtoId, String nome, double preco, String descricao) {
    setState(() {
      _produtoId = produtoId;
      _nomeController.text = nome;
      _precoController.text = preco.toString();
      _descricaoController.text = descricao;
    });
  }

  // Função para limpar os campos
  void _limparCampos() {
    setState(() {
      _produtoId = null;
      _nomeController.clear();
      _precoController.clear();
      _descricaoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome do Produto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o nome do produto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _precoController,
                    decoration: InputDecoration(labelText: 'Preço do Produto'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o preço do produto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descricaoController,
                    decoration:
                        InputDecoration(labelText: 'Descrição do Produto'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _salvarProduto,
                    child: Text(_produtoId == null
                        ? 'Salvar Produto'
                        : 'Atualizar Produto'),
                  ),
                  if (_produtoId != null)
                    TextButton(
                      onPressed: _limparCampos,
                      child: Text('Cancelar Edição'),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Produtos')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var produtos = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      var produto = produtos[index].data() as Map<String, dynamic>;
                      var produtoId = produtos[index].id;
                      return ListTile(
                        title: Text(produto['nome']),
                        subtitle: Text(
                            'Preço: R\$${produto['preco'].toStringAsFixed(2)}\nDescrição: ${produto['descricao']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _preencherCamposParaEdicao(
                                  produtoId,
                                  produto['nome'],
                                  produto['preco'],
                                  produto['descricao'],
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removerProduto(produtoId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
