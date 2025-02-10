import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListarExperienciasLocal extends StatelessWidget {
  final String estabelecimentoId;

  ListarExperienciasLocal({required this.estabelecimentoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiências do Local')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('experiencias')
            .where('estabelecimento_id', isEqualTo: estabelecimentoId) 
            .orderBy('data_hora', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar as experiências.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Não há experiências para este estabelecimento.'));
          }

          var experiencias = snapshot.data!.docs;

          return ListView.builder(
            itemCount: experiencias.length,
            itemBuilder: (context, index) {
              var experiencia = experiencias[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(experiencia['produto'] ?? 'Produto não informado'),
                subtitle: Text(experiencia['descricao'] ?? 'Descrição não informada'),
                trailing: Icon(
                  Icons.star,
                  color: experiencia['avaliacao'] >= 4 ? Colors.yellow : Colors.grey,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
