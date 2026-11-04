import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cores.dart';
import 'package:http/http.dart' as http;

// Aula 08: enums com as opções dos Radios
enum Acucar { comAcucar, adocante, semAcucar }

enum Recebimento { retirar, entregar }

// TELA 2 - FORMULÁRIO DO PEDIDO
class PedidoPage extends StatefulWidget {
  // Aula 05: dados recebidos da tela do cardápio
  String nome;
  double preco;
  String url;

  PedidoPage(this.nome, this.preco, this.url);

  @override
  State<PedidoPage> createState() => PedidoPageState();
}

class PedidoPageState extends State<PedidoPage> {
  // Aula 07: um controller para cada TextField
  TextEditingController clienteController = TextEditingController(text: 'Aluno Teste');
  TextEditingController horarioController = TextEditingController(text: '10:30');
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();

  // Aula 08: valores dos Radios e do Checkbox
  Recebimento recebimento = Recebimento.retirar;
  Acucar acucar = Acucar.comAcucar;
  bool paraViagem = false;

  // Aula 06: o total é recalculado sempre que a tela atualiza (setState)
  double calcularTotal() {
    double total = widget.preco;
    if (paraViagem) {
      total = total + 1; // embalagem para viagem
    }
    return total;
  }

  // RECURSO EXTRA: busca o endereço no ViaCEP e preenche os campos
  Future<void> buscarCep() async {
    String cep = cepController.text;
    var resposta = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    var endereco = jsonDecode(resposta.body);

    // se o CEP não existir, o ViaCEP devolve {"erro": true}
    if (endereco['erro'] == null) {
      setState(() {
        ruaController.text = endereco['logradouro'];
        bairroController.text = endereco['bairro'];
        cidadeController.text = endereco['localidade'];
      });
    }
  }

  // Aula 09: salva o pedido no Firestore com add()
  Future<void> salvarPedido() async {
    // o texto de "onde" muda conforme a forma de receber
    String onde;
    if (recebimento == Recebimento.retirar) {
      onde = 'Retirar no balcão às ${horarioController.text}';
    } else {
      onde = 'Entregar em ${ruaController.text}, ${bairroController.text} - ${cidadeController.text}';
    }

    await FirebaseFirestore.instance.collection('pedidos').add({
      'cliente': clienteController.text,
      'produto': widget.nome,
      'acucar': acucar.name,
      'paraViagem': paraViagem,
      'total': calcularTotal(),
      'recebimento': recebimento.name,
      'onde': onde,
      'data': DateTime.now(),
    });
    Navigator.of(context).pop(); // volta para o cardápio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido: ${widget.nome}'),
        centerTitle: true,
        backgroundColor: corCafe,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.url, width: double.infinity, height: 160, fit: BoxFit.cover),

            // Aula 07: TextField do nome
            TextField(
              controller: clienteController,
              decoration: InputDecoration(label: Text('Seu nome')),
            ),

            // Aula 08: Radio para escolher retirar ou entregar
            SizedBox(height: 16),
            Text('Como quer receber?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioGroup<Recebimento>(
              groupValue: recebimento,
              onChanged: (valor) {
                setState(() {
                  recebimento = valor!;
                });
              },
              child: Column(
                children: [
                  RadioListTile(
                    value: Recebimento.retirar,
                    title: Text('Peça e retire'),
                    subtitle: Text('Peça durante a aula e busque no balcão'),
                  ),
                  RadioListTile(
                    value: Recebimento.entregar,
                    title: Text('Delivery'),
                    subtitle: Text('Receba no endereço informado'),
                  ),
                ],
              ),
            ),

            // Só aparece quando escolher "Peça e retire"
            Visibility(
              visible: recebimento == Recebimento.retirar,
              child: TextField(
                controller: horarioController,
                decoration: InputDecoration(
                  label: Text('Horário para retirar'),
                  hintText: 'ex: 10:30 (no intervalo)',
                  icon: Icon(Icons.access_time),
                ),
              ),
            ),

            // Só aparece quando escolher "Delivery"
            Visibility(
              visible: recebimento == Recebimento.entregar,
              child: Column(
                children: [
                  TextField(
                    controller: cepController,
                    decoration: InputDecoration(label: Text('CEP'), hintText: 'Só números, ex: 01310100'),
                    // quando o CEP tiver 8 números, busca no ViaCEP
                    onChanged: (texto) {
                      if (texto.length == 8) {
                        buscarCep();
                      }
                    },
                  ),
                  TextField(
                    controller: ruaController,
                    decoration: InputDecoration(label: Text('Rua')),
                  ),
                  TextField(
                    controller: bairroController,
                    decoration: InputDecoration(label: Text('Bairro')),
                  ),
                  TextField(
                    controller: cidadeController,
                    decoration: InputDecoration(label: Text('Cidade')),
                  ),
                ],
              ),
            ),

            // Aula 08: grupo de Radio com enum
            SizedBox(height: 16),
            Text('Açúcar (para bebidas)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioGroup<Acucar>(
              groupValue: acucar,
              onChanged: (valor) {
                setState(() {
                  acucar = valor!;
                });
              },
              child: Column(
                children: [
                  RadioListTile(value: Acucar.comAcucar, title: Text('Com açúcar')),
                  RadioListTile(value: Acucar.adocante, title: Text('Com adoçante')),
                  RadioListTile(value: Acucar.semAcucar, title: Text('Sem açúcar')),
                ],
              ),
            ),

            // Aula 08: Checkbox
            CheckboxListTile(
              title: Text('Para viagem (+R\$ 1)'),
              value: paraViagem,
              onChanged: (valor) {
                setState(() {
                  paraViagem = valor!;
                });
              },
            ),

            // Aula 06: total muda na tela com o setState
            Text(
              'Total: R\$ ${calcularTotal().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: corCafe),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: salvarPedido,
              child: Text('Fazer pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
