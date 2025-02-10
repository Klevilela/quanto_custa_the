import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login/pagina_login.dart';

class PerfilPage extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    // Navegar primeiro, depois realizar o logout para evitar usar o context após a operação assíncrona
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Substitua com a sua página de login
      (Route<dynamic> route) => false, // Remove todas as rotas anteriores
    );

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Se ocorrer um erro durante o logout, mostrar o erro após a navegação
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao sair: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Obtém o usuário autenticado

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator()) // Exibe carregando caso o usuário não esteja autenticado
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    user.displayName ?? 'Nome não disponível', // Exibe o nome do usuário (ou um valor padrão)
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email ?? 'Email não disponível', // Exibe o e-mail do usuário (ou um valor padrão)
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _logout(context), // Chama o logout
                    child: const Text('Sair'),
                  ),
                ],
              ),
            ),
    );
  }
}
