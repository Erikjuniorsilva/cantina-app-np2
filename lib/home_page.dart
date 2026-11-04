import 'package:flutter/material.dart';
import 'cores.dart';
import 'pedido_page.dart';
import 'pedidos_page.dart';

// TELA 1 - CARDÁPIO
class HomePage extends StatelessWidget {
  // Fotos usadas no cardápio (algumas se repetem entre produtos parecidos)
  final String fotoCafe = 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400';
  final String fotoCafeComLeite = 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400';
  final String fotoExpresso = 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400';
  final String fotoExpressoComLeite = 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=400';
  final String fotoCappuccino = 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400';
  final String fotoCappuccinoBorda = 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=400';
  final String fotoMilkshake = 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400';
  final String fotoChocolate = 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=400';
  final String fotoBauru = 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400';
  final String fotoCroissant = 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400';
  final String fotoFolheado = 'https://images.unsplash.com/photo-1530610476181-d83430b64dcd?w=400';
  final String fotoPizza = 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400';
  final String fotoHamburguer = 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400';

  // Monta a faixa com o nome da categoria (ex: "Cappuccinos")
  Widget tituloCategoria(String titulo) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, bottom: 4),
      padding: EdgeInsets.all(8),
      color: corMarromClaro,
      child: Text(
        titulo,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corCafe),
      ),
    );
  }

  // Monta o card de um produto (foto, nome, preço e botão "Pedir")
  Widget cardProduto(BuildContext context, String nome, double preco, String url) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            // Aula 03: imagem com BoxFit
            Image.network(url, width: 90, height: 90, fit: BoxFit.cover),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('R\$ ${preco.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: corCafe)),
                ],
              ),
            ),
            // Aula 05: abre o pedido passando o produto como parâmetro
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => PedidoPage(nome, preco, url),
                  ),
                );
              },
              child: Text('Pedir'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Aula 02: AppBar personalizada
      appBar: AppBar(
        title: Text('Cafeteria Tem Café'),
        centerTitle: true,
        backgroundColor: corCafe,
        foregroundColor: Colors.white,
      ),
      // Aula 04: tela longa com rolagem
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Aula 04: Stack com Positioned (texto em cima da foto)
            Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1600093463592-8e36ae95ef56?w=1200',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: corCafe,
                    child: Text(
                      'Peça sem fila!',
                      style: TextStyle(color: corAmarelo, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cardápio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: corCafe)),

                  tituloCategoria('Café Tradicional'),
                  cardProduto(context, 'Café coado', 4.50, fotoCafe),
                  cardProduto(context, 'Café com leite', 7.00, fotoCafeComLeite),

                  tituloCategoria('Café Expresso'),
                  cardProduto(context, 'Expresso P', 7.50, fotoExpresso),
                  cardProduto(context, 'Expresso M', 9.60, fotoExpresso),
                  cardProduto(context, 'Expresso com leite P', 8.90, fotoExpressoComLeite),
                  cardProduto(context, 'Expresso com leite M', 10.90, fotoExpressoComLeite),

                  tituloCategoria('Cappuccinos'),
                  cardProduto(context, 'Cappuccino P', 8.50, fotoCappuccino),
                  cardProduto(context, 'Cappuccino M', 12.00, fotoCappuccino),
                  cardProduto(context, 'Cappuccino c/ borda P', 12.00, fotoCappuccinoBorda),
                  cardProduto(context, 'Cappuccino c/ borda M', 14.00, fotoCappuccinoBorda),
                  cardProduto(context, 'Milkshake', 15.00, fotoMilkshake),
                  cardProduto(context, 'Chocolate Quente P', 7.00, fotoChocolate),
                  cardProduto(context, 'Chocolate Quente M', 9.90, fotoChocolate),

                  tituloCategoria('Salgados'),
                  cardProduto(context, 'Bauru', 8.50, fotoBauru),
                  cardProduto(context, 'Croissant', 10.50, fotoCroissant),
                  cardProduto(context, 'Folheado', 10.50, fotoFolheado),
                  cardProduto(context, 'Pizza', 12.00, fotoPizza),
                  cardProduto(context, 'Hambúrguer', 12.00, fotoHamburguer),
                ],
              ),
            ),
          ],
        ),
      ),
      // Aula 01: botão flutuante -> abre a lista de pedidos
      floatingActionButton: FloatingActionButton(
        backgroundColor: corAmarelo,
        foregroundColor: corCafe,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => PedidosPage(),
            ),
          );
        },
        child: Icon(Icons.receipt_long),
      ),
    );
  }
}
