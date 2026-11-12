import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cores.dart';

// TELA 3 - LISTA DE PEDIDOS EM TEMPO REAL (Aula 09)
class PedidosPage extends StatelessWidget {
  // Card de um pedido
  Widget cardPedido(Map<String, dynamic> pedido) {
    // ícone muda conforme a forma de receber
    IconData icone = Icons.storefront;
    if (pedido['recebimento'] == 'entregar') {
      icone = Icons.delivery_dining;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: corMarromClaro,
            child: Icon(icone, color: corCafe),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${pedido['produto']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${pedido['cliente']}', style: TextStyle(color: corCafe)),
                Text('${pedido['onde']}', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(
            'R\$ ${pedido['total'].toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: corCafe),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        centerTitle: true,
        backgroundColor: corCafe,
        foregroundColor: Colors.white,
      ),
      // StreamBuilder redesenha a lista sempre que o Firestore muda
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .orderBy('data', descending: true) // mais novos primeiro
            .snapshots(),
        builder: (context, snapshot) {
          // enquanto os dados não chegam, mostra o carregando
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: corCafe));
          }

          var pedidos = snapshot.data!.docs;

          // se ainda não tem nenhum pedido salvo
          if (pedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.coffee, size: 64, color: corMarromClaro),
                  Text('Nenhum pedido ainda.', style: TextStyle(fontSize: 18, color: corCafe)),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // contador de pedidos
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  '${pedidos.length} pedidos recebidos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corCafe),
                ),
              ),
              // monta um card para cada pedido
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: pedidos.length,
                  itemBuilder: (context, i) {
                    return cardPedido(pedidos[i].data());
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
