import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../locais/experiencia_local.dart';

class ListaLocais extends StatelessWidget {
  final String zona;

  const ListaLocais({super.key, required this.zona});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$zona - Locais'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('estabelecimentos')
            .where('zona', isEqualTo: zona)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar locais.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum local encontrado.'));
          }

          var locais = snapshot.data!.docs;

          return ListView.builder(
            itemCount: locais.length,
            itemBuilder: (context, index) {
              var doc = locais[index];
              var local = doc.data() as Map<String, dynamic>;

              // Obtendo as informações do local
              var nome = local['nome'] ?? 'Sem nome';
              var bairro = local['bairro'] ?? 'Sem bairro';
              var zonaNome = local['zona'] ?? 'Sem zona';
              var latitude = local['latitude'] ?? 0.0;
              var longitude = local['longitude'] ?? 0.0;
              String localId = doc.id; // ID do local no Firestore

              return Card(
                child: ListTile(
                  title: Text(nome),
                  subtitle: Text(bairro),
                  onTap: () {
                    if (nome != 'Sem nome' && bairro != 'Sem bairro' && zonaNome != 'Sem zona') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExperienciaPage(
                            estabelecimentoNome: nome,
                            bairroNome: bairro,
                            zonaNome: zonaNome,
                            latitude: latitude,
                            longitude: longitude,
                            localId: localId, // Agora o ID é passado corretamente
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro: Dados inválidos no Firestore.')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
