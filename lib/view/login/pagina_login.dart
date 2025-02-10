import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_quanto_custa_the/view/homepage/homepage.dart';
import 'package:projeto_quanto_custa_the/view/login/pagina_cadastro_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

//importar o arquivo pagina_cadastro_login.dart ou chamar pela rota(configurada em my_app.dart('/cadastro_login'))

//classe já no formato tabBarViewer(de um lado a tela de login e do outro a tela de cadastro de login)

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para login com email e senha
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Realizando login com email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      print("Login bem-sucedido: ${userCredential.user?.email}");
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao fazer login: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha no login: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Autenticação - Quanto Custa THE"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Login'),
            Tab(text: 'Registrar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        /*construir dentro do children página de login(textfield pra email, senha e o botão de login e o titulo. 
        E chamar a classe RegisterLoginPage() */

        children: [
          // Tela de Login
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _senhaController,
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        child: Text('Acessar'),
                      ),
              ],
            ),
          ),
          // Tela de Registro
          const RegisterLoginPage(), // Certifique-se de que esta classe esteja importada ou configurada corretamente
        ],
      ),
    );
  }
}
