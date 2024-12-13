import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgdejc/Telas/detalheDebitos.dart';
import '../servicos/debito_servico.dart';
import '../classes/Debito.dart';

class Consultadebitos extends StatefulWidget {
  const Consultadebitos({Key? key}) : super(key: key);

  @override
  State<Consultadebitos> createState() => _ConsultadebitosState();
}

class _ConsultadebitosState extends State<Consultadebitos> {
  final DebitoServico servico = DebitoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar Débitos"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: servico.conectarStreamDebitos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;

            if (documents.isEmpty) {
              return const Center(child: Text("Nenhum débito encontrado."));
            }

            // Agrupar débitos pelo nome do participante
            Map<String, List<Debito>> debitosPorParticipante = {};
            for (var doc in documents) {
              Debito debito = Debito.fromMap(doc.data() as Map<String, dynamic>, doc.id);
              if (debitosPorParticipante.containsKey(debito.nomeParticipante)) {
                debitosPorParticipante[debito.nomeParticipante]!.add(debito);
              } else {
                debitosPorParticipante[debito.nomeParticipante] = [debito];
              }
            }

            return ListView.builder(
              itemCount: debitosPorParticipante.keys.length,
              itemBuilder: (context, index) {
                String nomeParticipante = debitosPorParticipante.keys.elementAt(index);
                List<Debito> debitos = debitosPorParticipante[nomeParticipante]!;
                double totalDebitos = debitos.fold(0, (total, debito) => total + debito.valorTotal);

                // Pega o identificador do primeiro débito da lista para exibir
                String identificador = debitos.first.identificador;

                return ListTile(
                  title: Text(nomeParticipante),
                  subtitle: Text("Total de Débitos: R\$ ${totalDebitos.toStringAsFixed(2)}"),
                  trailing: Text("Identificador: $identificador"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DebitoDetalhes(debitos: debitos),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("Ainda nenhum débito encontrado."));
          }
        },
      ),
    );
  }
}
