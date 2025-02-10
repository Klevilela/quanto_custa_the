import 'package:flutter/material.dart';
import 'cadastrar_local.dart';
import 'locais.dart'; // Certifique-se de importar a tela ListaLocais
import 'perfil.dart'; // Importe a tela de perfil

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> zonas = [
    {'nome': 'Zona Leste', 'cor': Colors.red[200]},
    {'nome': 'Zona Sul', 'cor': Colors.yellow[200]},
    {'nome': 'Zona Norte', 'cor': Colors.green[200]},
    {'nome': 'Zona Sudeste', 'cor': Colors.blue[200]},
    {'nome': 'Centro', 'cor': Colors.grey[400]},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CadastrarLocal()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PerfilPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quanto Custa THE'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: zonas.map((zona) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaLocais(
                              zona: zona['nome']),
                        ),
                      );
                    },
                    child: Card(
                      color: zona['cor'],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        child: Text(
                          zona['nome'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tela Inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: 'Locais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
