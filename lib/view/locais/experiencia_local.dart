import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';  // Importando o url_launcher

import 'listar_experiencias_local.dart'; // Importando Google Maps

class ExperienciaPage extends StatefulWidget {
  final String estabelecimentoId;
  final String bairroId;
  final String zonaId;
  final double? latitude; 
  final double? longitude; 

  ExperienciaPage({
    required this.estabelecimentoId,
    required this.bairroId,
    required this.zonaId,
    this.latitude, // Adicionando a latitude e longitude
    this.longitude,
  });

  @override
  _ExperienciaPageState createState() => _ExperienciaPageState();
}

class _ExperienciaPageState extends State<ExperienciaPage> {
  final TextEditingController produtoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  int avaliacao = 3; // Nota inicial (padrão)
  late GoogleMapController mapController;

  // Método para adicionar a experiência no Firestore
  Future<void> _adicionarExperiencia() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não autenticado!')),
      );
      return;
    }

    if (produtoController.text.isNotEmpty &&
        precoController.text.isNotEmpty &&
        descricaoController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('experiencias').add({
          'usuario': user.displayName ?? 'Anônimo',
          'user_id': user.uid,
          'produto': produtoController.text,
          'preco': precoController.text,
          'descricao': descricaoController.text,
          'avaliacao': avaliacao,
          'bairro_id': widget.bairroId,
          'zona_id': widget.zonaId,
          'estabelecimento_id': widget.estabelecimentoId,
          'data_hora': Timestamp.now(),
        });

        produtoController.clear();
        precoController.clear();
        descricaoController.clear();
        setState(() {
          avaliacao = 3;  // Resetando a avaliação
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Experiência registrada com sucesso!')),
        );

        // Usando Future.delayed para garantir que a navegação aconteça após a inserção
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) { // Verificar se o widget ainda está montado
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListarExperienciasLocal(
                  estabelecimentoId: widget.estabelecimentoId,
                ),
              ),
            );
          }
        });
      } catch (e) {
        // Exibe erro em caso de falha na inserção
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar a experiência: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
    }
  }

  // Função para mover o mapa até a localização do estabelecimento
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // Verificando se latitude e longitude são válidas
    final LatLng? location = widget.latitude != null && widget.longitude != null
        ? LatLng(widget.latitude!, widget.longitude!)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Experiência')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: produtoController,
              decoration: const InputDecoration(labelText: 'Produto ou Serviço'),
            ),
            TextFormField(
              controller: precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            Row(
              children: [
                const Text('Avaliação:'),
                IconButton(
                  icon: Icon(Icons.star, color: avaliacao >= 1 ? Colors.yellow : Colors.grey),
                  onPressed: () {
                    setState(() {
                      avaliacao = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: avaliacao >= 2 ? Colors.yellow : Colors.grey),
                  onPressed: () {
                    setState(() {
                      avaliacao = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: avaliacao >= 3 ? Colors.yellow : Colors.grey),
                  onPressed: () {
                    setState(() {
                      avaliacao = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: avaliacao >= 4 ? Colors.yellow : Colors.grey),
                  onPressed: () {
                    setState(() {
                      avaliacao = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star, color: avaliacao >= 5 ? Colors.yellow : Colors.grey),
                  onPressed: () {
                    setState(() {
                      avaliacao = 5;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Mapa
            if (location != null)
              Container(
                height: 200,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('localizacao_estabelecimento'),
                      position: location,
                    ),
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _adicionarExperiencia,
              child: const Text('Adicionar Experiência'),
            ),
            const SizedBox(height: 16),
            // Link para o Google Maps
            if (location != null)
              TextButton(
                onPressed: () {
                  final googleMapsUrl = 'https://www.google.com/maps?q=${location.latitude},${location.longitude}';
                  // Abre o Google Maps no navegador ou app
                  launchUrl(Uri.parse(googleMapsUrl));
                },
                child: const Text('Ver no Google Maps'),
              ),
          ],
        ),
      ),
    );
  }
}
