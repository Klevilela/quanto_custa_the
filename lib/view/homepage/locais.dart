import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../locais/experiencia_local.dart';

class ListaLocais extends StatelessWidget {
  final String zona;

  const ListaLocais({required this.zona});

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
            .where('zona', isEqualTo: zona)  // Filtrando pela zona
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
              var local = locais[index].data() as Map<String, dynamic>;
              var nome = local['nome'] ?? 'Sem nome';
              var bairro = local['bairro'] ?? 'Sem bairro';

              // Verificar os valores antes de passar para a próxima tela
              print("Estabelecimento ID: ${local['id']}");
              print("Bairro ID: ${local['bairro_id']}");
              print("Zona ID: ${local['zona_id']}");

              return Card(
                child: ListTile(
                  title: Text(nome),
                  subtitle: Text(bairro),
                  onTap: () {
                    // Certificando-se de que o valor não é nulo ou vazio
                    if (local['id'] != null && local['bairro_id'] != null && local['zona_id'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExperienciaPage(
                            estabelecimentoId: local['id'], // Passando ID do estabelecimento
                            bairroId: local['bairro_id'],   // Passando ID do bairro
                            zonaId: local['zona_id'],       // Passando ID da zona
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro: Dados inválidos.')),
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
