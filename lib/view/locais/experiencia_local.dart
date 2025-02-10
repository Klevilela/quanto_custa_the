import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'listar_experiencias_local.dart';

class ExperienciaPage extends StatefulWidget {
  final String estabelecimentoNome;
  final String bairroNome;
  final String zonaNome;
  final double? latitude;
  final double? longitude;
  final String localId;

  const ExperienciaPage({
    super.key,
    required this.estabelecimentoNome,
    required this.bairroNome,
    required this.zonaNome,
    this.latitude,
    this.longitude,
    required this.localId,
  });

  @override
  _ExperienciaPageState createState() => _ExperienciaPageState();
}

class _ExperienciaPageState extends State<ExperienciaPage> {
  final TextEditingController produtoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  int avaliacao = 3;
  late GoogleMapController mapController;

  Future<void> _adicionarExperiencia() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Usuário não autenticado!')),
        );
      }
      return;
    }

    if (produtoController.text.isNotEmpty &&
        precoController.text.isNotEmpty &&
        descricaoController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('experiencias').add({
          'usuario': user.displayName ?? 'Anônimo',
          'produto': produtoController.text,
          'preco': precoController.text,
          'descricao': descricaoController.text,
          'avaliacao': avaliacao,
          'bairroNome': widget.bairroNome,
          'zonaNome': widget.zonaNome,
          'estabelecimento_id': widget.localId,
          'data_hora': Timestamp.now(),
        });

        produtoController.clear();
        precoController.clear();
        descricaoController.clear();
        setState(() {
          avaliacao = 3;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Experiência registrada com sucesso!')),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListarExperienciasLocal(
                    estabelecimentoId: widget.localId,
                  ),
                ),
              );
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar a experiência: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos!')),
        );
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
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
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: avaliacao > index ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      avaliacao = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            if (location != null)
              SizedBox(
                height: 200,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('localizacao_estabelecimento'),
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
            if (location != null)
              TextButton(
                onPressed: () async {
                  final googleMapsUrl =
                      'https://www.google.com/maps?q=${location.latitude},${location.longitude}';
                  await launchUrl(Uri.parse(googleMapsUrl));
                },
                child: const Text('Ver no Google Maps'),
              ),
          ],
        ),
      ),
    );
  }
}
