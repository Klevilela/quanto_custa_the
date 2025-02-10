import 'package:flutter/material.dart';
import 'package:projeto_quanto_custa_the/view/homepage/cadastrar_local.dart';
import 'package:projeto_quanto_custa_the/view/homepage/homepage.dart';
import 'package:projeto_quanto_custa_the/view/login/pagina_cadastro_login.dart';
import 'package:projeto_quanto_custa_the/view/login/pagina_login.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/login': (context) => const LoginPage(),
        '/cadastrar_login': (context) => const RegisterLoginPage(),
        '/home':(context) => HomePage(),
        '/cadastrar_local':(context) => CadastrarLocal(),
      },
    );
  }
}
