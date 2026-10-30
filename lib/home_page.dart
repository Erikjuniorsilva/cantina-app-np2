import 'package:flutter/material.dart';
import 'pedido_page.dart';
import 'pedidos_page.dart';

// TELA 1 - CARDÁPIO
class HomePage extends StatelessWidget {
  // Monta o card de um produto (foto, nome, preço e botão "Pedir")
  Widget cardProduto(BuildContext context, String nome, double preco, String url) {
    return Card(
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
                  Text('R\$ ${preco.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.deepOrange)),
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
        title: Text('Cantina da Faculdade'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
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
                  'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=1200',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      'Peça sem fila!',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                  Text('Cardápio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  cardProduto(context, 'X-Burguer', 18.00,
                      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400'),
                  cardProduto(context, 'Pizza Brotinho', 15.00,
                      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400'),
                  cardProduto(context, 'Salada Fit', 16.50,
                      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400'),
                  cardProduto(context, 'Suco Natural', 7.00,
                      'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400'),
                ],
              ),
            ),
          ],
        ),
      ),
      // Aula 01: botão flutuante -> abre a lista de pedidos
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
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
