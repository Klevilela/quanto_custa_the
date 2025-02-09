import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//importar o arquivo pagina_cadastro_login.dart ou chamar pela rota(configurada em my_app.dart('/cadastro_login'))

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}


//classe já no formato tabBarViewer(de um lado a tela de login e do outro a tela de cadastro de login)
class LoginPageState extends State<LoginPage>  with TickerProviderStateMixin{

  //variável pra fazer o controle do tabBar
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para login com email e senha
  Future<void> _login() async {
    try {
      // Realizando login com email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: 'email@example.com',  // Exemplo de email
        password: 'senha123',        // Exemplo de senha
      );
      print("Login bem-sucedido: ${userCredential.user?.email}");
    } catch (e) {
      print("Erro ao fazer login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha no login: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Text(''), //colocar login
              Text(''), //colocar registrar login(ou como preferir)

            ],
          )
      ),
      
      body: TabBarView(
        controller: _tabController,
        /*construir dentro do children página de login(textfield pra email, senha e o botão de login e o titulo. 
        E chamar a classe RegisterLoginPage() */
        children: [] 
      ),
    );
  }
}
