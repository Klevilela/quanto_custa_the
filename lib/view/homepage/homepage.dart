import 'package:flutter/material.dart';
import 'cadastrar_local.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) { // Índice do item "Formulário"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CadastrarLocal()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quanto Custa THE'),
        backgroundColor: colorScheme.primary,
      ),
      body: IndexedStack(
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tela Inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Formulário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurantes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

class FormularioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Formulário', style: TextStyle(fontSize: 24)));
  }
}

class RestaurantesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Restaurantes', style: TextStyle(fontSize: 24)));
  }
}

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Perfil', style: TextStyle(fontSize: 24)));
  }
}