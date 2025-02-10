import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CadastrarLocal extends StatefulWidget {
  CadastrarLocal({super.key});
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
  String? zonaSelecionada;  // Variável para armazenar a zona selecionada
  bool _useCurrentLocation = false; // Variável para controlar o checkbox

  List<String> zonas = ['Zona Leste', 'Zona Sudeste', 'Zona Norte', 'Zona Sul', 'Centro'];  // Lista de zonas (pode ser dinâmica se vindo do Firestore)

  // Função para obter a localização
  Future<void> _obterLocalizacao() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão de localização negada.')),
      );
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  // Função para salvar no Firestore
  Future<void> _salvarNoFirestore() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('estabelecimentos').add({
          'nome': _nomeController.text,
          'categoria': _categoriaController.text,
          'zona': zonaSelecionada,  // Usando a zona selecionada
          'bairro': _bairroController.text,
          'latitude': latitude,
          'longitude': longitude,
          'usuario_id': FirebaseAuth.instance.currentUser?.uid,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: $e')),
        );
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
              // Alterando o campo de zona para DropdownButtonFormField
              DropdownButtonFormField<String>(
                value: zonaSelecionada,
                decoration: InputDecoration(labelText: 'Zona'),
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

              // Checkbox para usar localização atual
              Row(
                children: [
                  Checkbox(
                    value: _useCurrentLocation,
                    onChanged: (bool? value) {
                      setState(() {
                        _useCurrentLocation = value!;
                        if (_useCurrentLocation) {
                          _obterLocalizacao(); // Captura a localização quando marcado
                        } else {
                          latitude = null;
                          longitude = null;
                        }
                      });
                    },
                  ),
                  Text('Usar minha localização atual'),
                ],
              ),
              // Exibe a localização se capturada
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
