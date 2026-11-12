import 'package:flutter/material.dart';
import 'cores.dart';
import 'sacola_page.dart';

// Aula 08: enum com as opções do Radio
enum Acucar { comAcucar, adocante, semAcucar }

// TELA 2 - ESCOLHER O ITEM (quantidade, açúcar, observação)
class PedidoPage extends StatefulWidget {
  // Aula 05: dados recebidos da tela do cardápio
  String nome;
  double preco;
  String url;
  bool bebida; // salgado não tem opção de açúcar

  PedidoPage(this.nome, this.preco, this.url, this.bebida);

  @override
  State<PedidoPage> createState() => PedidoPageState();
}

class PedidoPageState extends State<PedidoPage> {
  // Aula 07: controller do TextField
  TextEditingController observacaoController = TextEditingController();

  // Aula 08: valor do Radio
  Acucar acucar = Acucar.comAcucar;

  // Aula 06: quantidade muda com os botões - e +
  int quantidade = 1;

  // Texto do açúcar para mostrar na sacola
  String textoAcucar() {
    if (!widget.bebida) {
      return '';
    }
    if (acucar == Acucar.comAcucar) {
      return 'Com açúcar';
    }
    if (acucar == Acucar.adocante) {
      return 'Com adoçante';
    }
    return 'Sem açúcar';
  }

  // Coloca o item na sacola e volta para o cardápio
  void adicionarNaSacola() {
    sacola.add(ItemSacola(widget.nome, widget.preco, quantidade, textoAcucar(), observacaoController.text));

    // SnackBar: mensagem rápida na parte de baixo da tela
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.nome} adicionado à sacola! 🛍️')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha seu item'),
        centerTitle: true,
        backgroundColor: corCafe,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Aula 04: Stack com Positioned (nome e preço em cima da foto)
            Stack(
              children: [
                Image.network(widget.url, width: double.infinity, height: 220, fit: BoxFit.cover),
                // faixa escura embaixo da foto para o texto aparecer bem
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(height: 90, color: Colors.black45),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    widget.nome,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: corAmarelo, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'R\$ ${widget.preco.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corCafe),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Aula 06: quantidade com setState
                  secao(
                    Icons.format_list_numbered,
                    'Quantidade',
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          style: IconButton.styleFrom(backgroundColor: corMarromClaro, foregroundColor: corCafe),
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            // não deixa ficar menor que 1
                            if (quantidade > 1) {
                              setState(() {
                                quantidade = quantidade - 1;
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text('$quantidade', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        IconButton.filled(
                          style: IconButton.styleFrom(backgroundColor: corAmarelo, foregroundColor: corCafe),
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantidade = quantidade + 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Aula 08: grupo de Radio com enum (só para bebidas)
                  Visibility(
                    visible: widget.bebida,
                    child: secao(
                      Icons.local_cafe,
                      'Açúcar',
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
                    ),
                  ),

                  // Aula 07: observação do item
                  secao(
                    Icons.edit_note,
                    'Observação',
                    TextField(
                      controller: observacaoController,
                      decoration: InputDecoration(
                        hintText: widget.bebida ? 'ex: bem quente, sem canela' : 'ex: sem cebola, bem passado',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Barra fixa embaixo: subtotal + botão
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: BoxDecoration(
          color: corCafe,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        // Aula 04: Row com alinhamento (valor na esquerda, botão na direita)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subtotal', style: TextStyle(color: corMarromClaro)),
                // Aula 06: valor muda na tela com o setState
                Text(
                  'R\$ ${(widget.preco * quantidade).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: adicionarNaSacola,
              icon: Icon(Icons.shopping_bag),
              label: Text('Adicionar à sacola', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
