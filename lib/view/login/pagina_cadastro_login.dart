import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterLoginPage extends StatefulWidget {
  const RegisterLoginPage({super.key});

  @override
  RegisterLoginPageState createState() => RegisterLoginPageState();
}

class RegisterLoginPageState extends State<RegisterLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Método para registrar o usuário
  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      // Verifica se a senha e a confirmação de senha são iguais
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('As senhas não coincidem!'),
        ));
        return;
      }

      try {
        // Cria o usuário no Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Aqui você pode adicionar os dados adicionais do usuário no Firestore
        // (se necessário, como o nome do usuário)
        await FirebaseAuth.instance.currentUser!.updateDisplayName(_nameController.text.trim());

        // Exemplo de sucesso
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
        ));

        // Redireciona para outra tela ou realiza alguma ação após o cadastro
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
        // Tratamento de erros de autenticação
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? 'Erro desconhecido!'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // colocar um titulo pra essa página
           //colocar os text field pra nome, email, senha e confirmar senha
            
            ElevatedButton(
              onPressed: _registrarUsuario,
              child: const Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
