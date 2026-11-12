import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'cores.dart';

// Aula 08: enum com as opções do Radio
enum Recebimento { retirar, entregar }

// Um item que o aluno colocou na sacola
class ItemSacola {
  String nome;
  double preco;
  int quantidade;
  String acucar;
  String observacao;

  ItemSacola(this.nome, this.preco, this.quantidade, this.acucar, this.observacao);
}

// A sacola é uma lista que todas as telas usam
List<ItemSacola> sacola = [];

// Horário de funcionamento da cafeteria (em minutos do dia)
int abre = 6 * 60; // 06:00
int fecha = 22 * 60 + 30; // 22:30

// Verifica se a cafeteria está aberta agora
bool lojaAberta() {
  DateTime agora = DateTime.now();
  int minutos = agora.hour * 60 + agora.minute;
  return minutos >= abre && minutos < fecha;
}

// Um bloco branco do formulário, com ícone e título
Widget secao(IconData icone, String titulo, Widget conteudo) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 14),
    padding: EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icone, color: corCafe),
            SizedBox(width: 8),
            Text(titulo, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: corCafe)),
          ],
        ),
        SizedBox(height: 6),
        conteudo,
      ],
    ),
  );
}

// TELA DA SACOLA - itens escolhidos + dados para finalizar o pedido
class SacolaPage extends StatefulWidget {
  @override
  State<SacolaPage> createState() => SacolaPageState();
}

class SacolaPageState extends State<SacolaPage> {
  // Aula 07: um controller para cada TextField
  TextEditingController clienteController = TextEditingController(text: 'Aluno Teste');
  TextEditingController horarioController = TextEditingController(text: '10:30');
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();

  // Aula 08: valor do Radio e do Checkbox
  Recebimento recebimento = Recebimento.retirar;
  bool paraViagem = false;

  // Aula 06: enquanto envia, o botão fica travado (evita pedido duplicado)
  bool enviando = false;

  // Delivery sempre vai embalado; no "Peça e retire" o aluno escolhe no Checkbox
  bool vaiParaViagem() {
    return paraViagem || recebimento == Recebimento.entregar;
  }

  // Aula 06: soma todos os itens da sacola
  double calcularTotal() {
    double total = 0;
    for (ItemSacola item in sacola) {
      total = total + item.preco * item.quantidade;
    }
    if (vaiParaViagem()) {
      total = total + 1; // embalagem para viagem
    }
    return total;
  }

  // Confere se o horário de retirada (ex: 10:30) está dentro do funcionamento
  bool horarioValido(String texto) {
    List<String> partes = texto.split(':');
    if (partes.length != 2) {
      return false;
    }
    int? hora = int.tryParse(partes[0]);
    int? minuto = int.tryParse(partes[1]);
    if (hora == null || minuto == null) {
      return false;
    }
    int minutos = hora * 60 + minuto;
    return minutos >= abre && minutos <= fecha;
  }

  // Mostra uma mensagem rápida na parte de baixo da tela
  void avisar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
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
    } else {
      avisar('CEP não encontrado');
    }
  }

  // Aula 09: salva o pedido no Firestore com add()
  Future<void> salvarPedido() async {
    // depois das 22:30 a cafeteria está fechada
    if (!lojaAberta()) {
      avisar('Estamos fechados! Pedidos só das 06:00 às 22:30.');
      return;
    }
    if (recebimento == Recebimento.retirar && !horarioValido(horarioController.text)) {
      avisar('Horário de retirada deve ser entre 06:00 e 22:30 (ex: 10:30).');
      return;
    }

    // o texto de "onde" muda conforme a forma de receber
    String onde;
    if (recebimento == Recebimento.retirar) {
      onde = 'Retirar no balcão às ${horarioController.text}';
    } else {
      onde = 'Entregar em ${ruaController.text}, ${numeroController.text}';
      // complemento é opcional: só entra no texto se foi preenchido
      if (complementoController.text != '') {
        onde = '$onde (${complementoController.text})';
      }
      onde = '$onde - ${bairroController.text} - ${cidadeController.text}';
    }

    // monta a lista de itens para salvar (ex: "2x Café coado")
    List<String> produtos = [];
    List<Map<String, dynamic>> itens = [];
    for (ItemSacola item in sacola) {
      produtos.add('${item.quantidade}x ${item.nome}');
      itens.add({
        'nome': item.nome,
        'quantidade': item.quantidade,
        'preco': item.preco,
        'acucar': item.acucar,
        'observacao': item.observacao,
      });
    }

    setState(() {
      enviando = true;
    });

    try {
      await FirebaseFirestore.instance.collection('pedidos').add({
        'cliente': clienteController.text,
        'produto': produtos.join(', '),
        'itens': itens,
        'paraViagem': vaiParaViagem(),
        'total': calcularTotal(),
        'recebimento': recebimento.name,
        'onde': onde,
        'data': DateTime.now(),
      });

      sacola.clear(); // pedido feito: esvazia a sacola
      avisar('Pedido enviado! ☕');
      Navigator.of(context).pop(); // volta para o cardápio
    } catch (erro) {
      avisar('Erro ao enviar o pedido. Tente de novo.');
      setState(() {
        enviando = false; // libera o botão para tentar de novo
      });
    }
  }

  // Uma linha da lista de itens: quantidade, nome, preço e lixeira
  Widget linhaItem(int i) {
    ItemSacola item = sacola[i];

    // detalhes do item (açúcar e observação), se tiver
    String detalhes = item.acucar;
    if (item.observacao != '') {
      detalhes = '$detalhes ${item.observacao}';
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: corAmarelo,
          child: Text('${item.quantidade}x', style: TextStyle(fontSize: 12, color: corCafe)),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.nome, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(detalhes, style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
        Text('R\$ ${(item.preco * item.quantidade).toStringAsFixed(2)}'),
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              sacola.removeAt(i);
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool aberta = lojaAberta();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sacola'),
        centerTitle: true,
        backgroundColor: corCafe,
        foregroundColor: Colors.white,
      ),
      body: sacola.isEmpty
          // sacola vazia
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 72, color: corMarromClaro),
                  Text('Sua sacola está vazia', style: TextStyle(fontSize: 18, color: corCafe)),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ver cardápio'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // aviso de loja fechada
                  Visibility(
                    visible: !aberta,
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 14),
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_clock, color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Estamos fechados agora.\nFuncionamos das 06:00 às 22:30.',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // itens da sacola
                  secao(
                    Icons.shopping_bag,
                    'Itens (${sacola.length})',
                    Column(
                      children: [
                        for (int i = 0; i < sacola.length; i++) linhaItem(i),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop(); // volta para escolher mais
                          },
                          icon: Icon(Icons.add, color: corCafe),
                          label: Text('Adicionar mais itens', style: TextStyle(color: corCafe)),
                        ),
                      ],
                    ),
                  ),

                  // Aula 07: TextField do nome
                  secao(
                    Icons.person,
                    'Seus dados',
                    TextField(
                      controller: clienteController,
                      decoration: InputDecoration(label: Text('Seu nome')),
                    ),
                  ),

                  // Aula 08: Radio para escolher retirar ou entregar
                  secao(
                    Icons.storefront,
                    'Como quer receber?',
                    Column(
                      children: [
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
                                secondary: Icon(Icons.storefront),
                              ),
                              RadioListTile(
                                value: Recebimento.entregar,
                                title: Text('Delivery'),
                                subtitle: Text('Receba no endereço informado'),
                                secondary: Icon(Icons.delivery_dining),
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
                              hintText: 'entre 06:00 e 22:30',
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
                                decoration: InputDecoration(
                                  label: Text('CEP'),
                                  hintText: 'Só números, ex: 01310100',
                                  icon: Icon(Icons.location_on),
                                ),
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
                              // Aula 04: Row com número e complemento lado a lado
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: numeroController,
                                      decoration: InputDecoration(label: Text('Número')),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: complementoController,
                                      decoration: InputDecoration(
                                        label: Text('Complemento'),
                                        hintText: 'ex: apto 12, bloco B',
                                      ),
                                    ),
                                  ),
                                ],
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
                      ],
                    ),
                  ),

                  // Aula 08: Checkbox (só no "Peça e retire")
                  secao(
                    Icons.takeout_dining,
                    'Embalagem',
                    Column(
                      children: [
                        Visibility(
                          visible: recebimento == Recebimento.retirar,
                          child: CheckboxListTile(
                            title: Text('Para viagem (+R\$ 1)'),
                            value: paraViagem,
                            onChanged: (valor) {
                              setState(() {
                                paraViagem = valor!;
                              });
                            },
                          ),
                        ),
                        // No Delivery já vai embalado, então só mostra um aviso
                        Visibility(
                          visible: recebimento == Recebimento.entregar,
                          child: ListTile(
                            title: Text('Embalagem para viagem (+R\$ 1)'),
                            subtitle: Text('No delivery o pedido já vai embalado'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

      // Barra fixa embaixo: total + botão (só aparece se tiver itens)
      bottomNavigationBar: sacola.isEmpty
          ? null
          : Container(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: BoxDecoration(
                color: corCafe,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              // Aula 04: Row com alinhamento (total na esquerda, botão na direita)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total', style: TextStyle(color: corMarromClaro)),
                      // Aula 06: total muda na tela com o setState
                      Text(
                        'R\$ ${calcularTotal().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  // fechada ou enviando: onPressed fica null e o botão desativa
                  ElevatedButton.icon(
                    onPressed: (enviando || !aberta) ? null : salvarPedido,
                    icon: Icon(aberta ? Icons.send : Icons.lock_clock),
                    label: Text(
                      !aberta ? 'Fechado' : (enviando ? 'Enviando...' : 'Fazer pedido'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
