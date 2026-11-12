import 'package:flutter/material.dart';
import 'cores.dart';
import 'pedido_page.dart';
import 'pedidos_page.dart';
import 'sacola_page.dart';

// TELA 1 - CARDÁPIO
// É StatefulWidget para atualizar o número de itens da sacola
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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

  // Título de uma categoria: ícone + nome + linha
  Widget tituloCategoria(IconData icone, String titulo) {
    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: 10),
      child: Row(
        children: [
          Icon(icone, color: corCafe),
          SizedBox(width: 8),
          Text(titulo, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corCafe)),
          SizedBox(width: 12),
          Expanded(child: Divider(color: corMarromClaro, thickness: 2)),
        ],
      ),
    );
  }

  // Card de um produto: foto em cima, nome, preço e botão "+"
  Widget cardProduto(BuildContext context, String nome, double preco, String url, bool bebida) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aula 03: imagem com BoxFit (cantos de cima arredondados)
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(url, width: double.infinity, height: 110, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                // Aula 04: Row com alinhamento (preço na esquerda, botão na direita)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${preco.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: corCafe),
                    ),
                    // Aula 05: abre o pedido passando o produto como parâmetro
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: corAmarelo, foregroundColor: corCafe),
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => PedidoPage(nome, preco, url, bebida),
                          ),
                        );
                        setState(() {}); // atualiza o número da sacola
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Uma linha da grade com dois produtos lado a lado
  Widget linha(Widget esquerda, Widget direita) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: esquerda),
        SizedBox(width: 12),
        Expanded(child: direita),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Aula 02: AppBar personalizada
      appBar: AppBar(
        title: Text('Cafeteria Tem Café', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: corCafe,
        foregroundColor: Colors.white,
        leading: Icon(Icons.local_cafe, color: corAmarelo),
        actions: [
          // botão da sacola com a quantidade de itens
          IconButton(
            icon: Badge(
              label: Text('${sacola.length}'),
              isLabelVisible: sacola.isNotEmpty,
              backgroundColor: corAmarelo,
              textColor: corCafe,
              child: Icon(Icons.shopping_bag),
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => SacolaPage(),
                ),
              );
              setState(() {}); // atualiza o número da sacola
            },
          ),
        ],
      ),
      // Aula 04: tela longa com rolagem
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho marrom com cantos de baixo arredondados
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
              decoration: BoxDecoration(
                color: corCafe,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Olá! ☕', style: TextStyle(fontSize: 16, color: corMarromClaro)),
                  Text(
                    'O que vai ser hoje?',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  // aberto ou fechado (fecha às 22:30)
                  Row(
                    children: [
                      Icon(Icons.circle, size: 12, color: lojaAberta() ? Colors.greenAccent : Colors.redAccent),
                      SizedBox(width: 6),
                      Text(
                        lojaAberta() ? 'Aberto agora • até 22:30' : 'Fechado agora • abre às 06:00',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Aula 04: Stack com Positioned (textos em cima da foto)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://images.unsplash.com/photo-1600093463592-8e36ae95ef56?w=1200',
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 14,
                          bottom: 14,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: corAmarelo,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Peça sem fila!',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corCafe),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 14,
                          top: 14,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Icon(Icons.storefront, color: corCafe),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Cardápio em grade de 2 colunas
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  tituloCategoria(Icons.coffee, 'Café Tradicional'),
                  linha(
                    cardProduto(context, 'Café coado', 4.50, fotoCafe, true),
                    cardProduto(context, 'Café com leite', 7.00, fotoCafeComLeite, true),
                  ),

                  tituloCategoria(Icons.coffee_maker, 'Café Expresso'),
                  linha(
                    cardProduto(context, 'Expresso P', 7.50, fotoExpresso, true),
                    cardProduto(context, 'Expresso M', 9.60, fotoExpresso, true),
                  ),
                  linha(
                    cardProduto(context, 'Expresso c/ leite P', 8.90, fotoExpressoComLeite, true),
                    cardProduto(context, 'Expresso c/ leite M', 10.90, fotoExpressoComLeite, true),
                  ),

                  tituloCategoria(Icons.emoji_food_beverage, 'Cappuccinos e Bebidas'),
                  linha(
                    cardProduto(context, 'Cappuccino P', 8.50, fotoCappuccino, true),
                    cardProduto(context, 'Cappuccino M', 12.00, fotoCappuccino, true),
                  ),
                  linha(
                    cardProduto(context, 'Cappuccino c/ borda P', 12.00, fotoCappuccinoBorda, true),
                    cardProduto(context, 'Cappuccino c/ borda M', 14.00, fotoCappuccinoBorda, true),
                  ),
                  linha(
                    cardProduto(context, 'Chocolate Quente P', 7.00, fotoChocolate, true),
                    cardProduto(context, 'Chocolate Quente M', 9.90, fotoChocolate, true),
                  ),
                  linha(
                    cardProduto(context, 'Milkshake', 15.00, fotoMilkshake, true),
                    SizedBox(),
                  ),

                  tituloCategoria(Icons.bakery_dining, 'Salgados'),
                  linha(
                    cardProduto(context, 'Bauru', 8.50, fotoBauru, false),
                    cardProduto(context, 'Croissant', 10.50, fotoCroissant, false),
                  ),
                  linha(
                    cardProduto(context, 'Folheado', 10.50, fotoFolheado, false),
                    cardProduto(context, 'Pizza', 12.00, fotoPizza, false),
                  ),
                  linha(
                    cardProduto(context, 'Hambúrguer', 12.00, fotoHamburguer, false),
                    SizedBox(),
                  ),
                  SizedBox(height: 80), // espaço para o botão flutuante
                ],
              ),
            ),
          ],
        ),
      ),
      // Aula 01: botão flutuante -> abre a lista de pedidos
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corAmarelo,
        foregroundColor: corCafe,
        icon: Icon(Icons.receipt_long),
        label: Text('Meus pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => PedidosPage(),
            ),
          );
        },
      ),
    );
  }
}
