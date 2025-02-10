import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CadastrarLocal extends StatefulWidget {
  const CadastrarLocal({super.key});
  @override
  CadastrarLocalState createState() => CadastrarLocalState();
}

class CadastrarLocalState extends State<CadastrarLocal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  double? latitude;
  double? longitude;
  String? zonaSelecionada = 'Zona Leste';
  bool _useCurrentLocation = false;

  List<String> zonas = ['Zona Leste', 'Zona Sudeste', 'Zona Norte', 'Zona Sul', 'Centro'];

  Future<void> _obterLocalizacao() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ative a permissão de localização nas configurações.')),
        );
      }
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    if (mounted) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }
  }

  Future<void> _salvarNoFirestore() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro: Usuário não autenticado!')),
          );
        }
        return;
      }

      try {
        await FirebaseFirestore.instance.collection('estabelecimentos').add({
          'nome': _nomeController.text,
          'categoria': _categoriaController.text,
          'zona': zonaSelecionada,
          'bairro': _bairroController.text,
          'latitude': latitude ?? 0.0,
          'longitude': longitude ?? 0.0,
          'usuario_id': user.uid,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastro realizado com sucesso!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao cadastrar: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Local')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Local'),
                validator: (value) => value!.isEmpty ? 'Digite o nome' : null,
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(labelText: 'Categoria'),
                validator: (value) => value!.isEmpty ? 'Digite a categoria' : null,
              ),
              DropdownButtonFormField<String>(
                value: zonaSelecionada,
                decoration: const InputDecoration(labelText: 'Zona'),
                items: zonas.map((zona) {
                  return DropdownMenuItem<String>(
                    value: zona,
                    child: Text(zona),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    zonaSelecionada = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione a zona' : null,
              ),
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(labelText: 'Bairro'),
                validator: (value) => value!.isEmpty ? 'Digite o bairro' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _useCurrentLocation,
                    onChanged: (bool? value) {
                      setState(() {
                        _useCurrentLocation = value!;
                        if (_useCurrentLocation) {
                          _obterLocalizacao();
                        } else {
                          latitude = null;
                          longitude = null;
                        }
                      });
                    },
                  ),
                  const Text('Usar minha localização atual'),
                ],
              ),
              if (_useCurrentLocation && latitude != null && longitude != null)
                Text('Latitude: $latitude, Longitude: $longitude'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarNoFirestore,
                child: const Text('Cadastrar Local'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
