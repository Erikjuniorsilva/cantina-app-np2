import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cores.dart';

// TELA 3 - LISTA DE PEDIDOS EM TEMPO REAL (Aula 09)
class PedidosPage extends StatelessWidget {
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
        stream: FirebaseFirestore.instance.collection('pedidos').snapshots(),
        builder: (context, snapshot) {
          // enquanto os dados não chegam, mostra o carregando
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var pedidos = snapshot.data!.docs;

          // se ainda não tem nenhum pedido salvo
          if (pedidos.isEmpty) {
            return Center(child: Text('Nenhum pedido ainda.'));
          }

          // monta uma linha para cada pedido
          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, i) {
              var pedido = pedidos[i].data();
              return ListTile(
                leading: Icon(Icons.local_cafe, color: corCafe),
                title: Text('${pedido['produto']} (${pedido['acucar']})'),
                subtitle: Text('${pedido['cliente']} - ${pedido['onde']}'),
                trailing: Text('R\$ ${pedido['total'].toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
