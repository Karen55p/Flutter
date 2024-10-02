import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //Import para formatar a moeda em Real

void main() => runApp(BankApp());

class BankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Transferencia> _transferencias = [];
  final List<Contato> _contatos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: Color(0xffff9500))),
        backgroundColor: Color(0xff000000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff002fff),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaTransferencia(_transferencias),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              child:
                  Text('Transferências', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffff9500),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaContatos(_contatos),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              child: Text('Contatos', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias;

  ListaTransferencia(this._transferencias);

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Transferências', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xffff9500),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xff002fff),
        onPressed: () {
          final Future<Transferencia?> future = Navigator.push<Transferencia>(
            context,
            MaterialPageRoute(builder: (context) {
              return FormularioTransferencia();
            }),
          );
          future.then((transferenciaRecebida) {
            if (transferenciaRecebida != null) {
              setState(() {
                widget._transferencias.add(transferenciaRecebida);
              });
            }
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia, {super.key});

  @override
  Widget build(BuildContext context) {
    //Formatação para exibir o valor em Real (R$)
    final formatoReal = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: Color(0xff002fff)),
        title: Text(formatoReal.format(_transferencia.valor)), //Valor formatado
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferência',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff002fff),
      ),
      body: Column(
        children: <Widget>[
          Editor(
            controlador: _controladorCampoNumeroConta,
            rotulo: 'Número da Conta',
            dica: '0000',
          ),
          Editor(
            controlador: _controladorCampoValor,
            rotulo: 'Valor',
            dica: '0.00',
            icone: Icons.monetization_on,
          ),
          ElevatedButton(
            child: Text('Confirmar'),
            onPressed: () {
              _criaTransferencia(context, _controladorCampoNumeroConta,
                  _controladorCampoValor);
            },
          ),
        ],
      ),
    );
  }

  void _criaTransferencia(
      BuildContext context,
      TextEditingController controladorCampoNumeroConta,
      TextEditingController controladorCampoValor) {
    final int? numeroConta = int.tryParse(controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}

class ListaContatos extends StatefulWidget {
  final List<Contato> _contatos;

  ListaContatos(this._contatos);

  @override
  State<StatefulWidget> createState() {
    return ListaContatosState();
  }
}

class ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff002fff),
      ),
      body: ListView.builder(
        itemCount: widget._contatos.length,
        itemBuilder: (context, indice) {
          final contato = widget._contatos[indice];
          return ItemContato(contato);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Color(0xffff9500),
        onPressed: () {
          final Future<Contato?> future = Navigator.push<Contato>(
            context,
            MaterialPageRoute(builder: (context) {
              return FormularioContato();
            }),
          );
          future.then((contatoRecebido) {
            if (contatoRecebido != null) {
              setState(() {
                widget._contatos.add(contatoRecebido);
              });
            }
          });
        },
      ),
    );
  }
}

class ItemContato extends StatelessWidget {
  final Contato _contato;

  const ItemContato(this._contato, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person, color: Color(0xffff9500)),
        title: Text(_contato.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Endereço: ${_contato.endereco}'),
            SizedBox(height: 2),
            Text('Telefone: ${_contato.telefone}'),
            SizedBox(height: 2),
            Text('Email: ${_contato.email}'),
            SizedBox(height: 2),
            Text('CPF: ${_contato.cpf}'),
          ],
        ),
      ),
    );
  }
}

class FormularioContato extends StatelessWidget {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorEndereco = TextEditingController();
  final TextEditingController _controladorTelefone = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorCPF = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Contato', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xffff9500),
      ),
      body: Column(
        children: <Widget>[
          Editor(
            controlador: _controladorNome,
            rotulo: 'Nome',
            dica: 'Nome completo',
          ),
          Editor(
            controlador: _controladorEndereco,
            rotulo: 'Endereço',
            dica: 'Endereço completo',
          ),
          Editor(
            controlador: _controladorTelefone,
            rotulo: 'Telefone',
            dica: '(00) 00000-0000',
          ),
          Editor(
            controlador: _controladorEmail,
            rotulo: 'Email',
            dica: 'email@dominio.com',
          ),
          Editor(
            controlador: _controladorCPF,
            rotulo: 'CPF',
            dica: '000.000.000-00',
          ),
          ElevatedButton(
            child: Text('Confirmar'),
            onPressed: () {
              _criaContato(context, _controladorNome, _controladorEndereco,
                  _controladorTelefone, _controladorEmail, _controladorCPF);
            },
          ),
        ],
      ),
    );
  }

  void _criaContato(
    BuildContext context,
    TextEditingController controladorNome,
    TextEditingController controladorEndereco,
    TextEditingController controladorTelefone,
    TextEditingController controladorEmail,
    TextEditingController controladorCPF,
  ) {
    final String nome = controladorNome.text;
    final String endereco = controladorEndereco.text;
    final String telefone = controladorTelefone.text;
    final String email = controladorEmail.text;
    final String cpf = controladorCPF.text;

    if (nome.isNotEmpty &&
        endereco.isNotEmpty &&
        telefone.isNotEmpty &&
        email.isNotEmpty &&
        cpf.isNotEmpty) {
      final contatoCriado = Contato(nome, endereco, telefone, email, cpf);
      Navigator.pop(context, contatoCriado);
    }
  }
}

class Contato {
  final String nome;
  final String endereco;
  final String telefone;
  final String email;
  final String cpf;

  Contato(this.nome, this.endereco, this.telefone, this.email, this.cpf);

  @override
  String toString() {
    return 'Contato{nome: $nome, endereco: $endereco, telefone: $telefone, email: $email, cpf: $cpf}';
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
          hintStyle: TextStyle(fontSize: 24.0),
          labelStyle: TextStyle(fontSize: 24.0),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
