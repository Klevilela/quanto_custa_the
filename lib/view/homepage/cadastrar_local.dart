import 'package:flutter/material.dart';

class CadastrarLocal extends StatefulWidget {
  CadastrarLocal({super.key});
  @override
  CadastrarLocalState createState() => CadastrarLocalState();
}

// integrar depois com o firebase
class Produto {
  late String nome;
  late String descricao;
  late double valor;

  Produto(this.nome, this.descricao, this.valor) {}
}

class CadastrarLocalState extends State<CadastrarLocal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _restauranteController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  DateTime? _dataVisita;
  List<Produto> _produtos = [];

  void _adicionarProduto(Produto produto) {
    setState(() {
      _produtos.add(produto);
    });
  }

  void _removerProduto(int index) {
    setState(() {
      _produtos.removeAt(index);
    });
  }

  void _selecionarData() async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada != null) {
      setState(() {
        _dataVisita = dataSelecionada;
      });
    }
  }

  void _concluirCadastro() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode processar os dados do formulário conforme necessário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro concluído com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Visita'),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Visitante'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do visitante';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _restauranteController,
                decoration: InputDecoration(labelText: 'Nome do Restaurante'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do restaurante';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                  _dataVisita == null
                      ? 'Selecione a Data da Visita'
                      : 'Data da Visita: ${_dataVisita!.day}/${_dataVisita!.month}/${_dataVisita!.year}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _selecionarData,
              ),
              SizedBox(height: 20),
              Text(
                'Produtos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._produtos.asMap().entries.map((entry) {
                int index = entry.key;
                Produto produto = entry.value;
                return ListTile(
                  title: Text(produto.nome),
                  subtitle: Text(produto.descricao),
                  trailing: Text('R\$ ${produto.valor.toStringAsFixed(2)}'),
                  onLongPress: () => _removerProduto(index),
                );
              }).toList(),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    Produto? novoProduto = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CadastroProdutoPage(),
                      ),
                    );
                    if (novoProduto != null) {
                      _adicionarProduto(novoProduto);
                    }
                  },
                  child: Icon(Icons.add),
                  backgroundColor: colorScheme.primary,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _concluirCadastro,
                child: Text('Concluir Cadastro'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CadastroProdutoPage extends StatefulWidget {
  @override
  CadastroProdutoPageState createState() => CadastroProdutoPageState();
}

class CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  void _concluirCadastroProduto() {
    if (_formKey.currentState!.validate()) {
      
      Produto novoProduto = Produto(
        _nomeController.text,
        _descricaoController.text,
        double.parse(_valorController.text),
      );
      Navigator.pop(context, novoProduto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produto'),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor do Produto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor do produto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um valor numérico válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _concluirCadastroProduto,
                child: Text('Concluir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
