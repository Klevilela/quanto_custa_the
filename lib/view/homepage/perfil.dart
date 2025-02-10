import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login/pagina_login.dart';

class PerfilPage extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), 
      (Route<dynamic> route) => false,
    );

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao sair: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator()) 
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    user.displayName ?? 'Nome não disponível', 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email ?? 'Email não disponível', 
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _logout(context), 
                    child: const Text('Sair'),
                  ),
                ],
              ),
            ),
    );
  }
}
