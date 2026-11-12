import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'cores.dart';
import 'home_page.dart';

// Aula 09: liga o Firebase antes de abrir o app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Cores do app: tons de café, fundo creme e botões amarelos
      theme: ThemeData(
        colorSchemeSeed: corCafe,
        scaffoldBackgroundColor: corFundo,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corAmarelo,
            foregroundColor: corCafe,
          ),
        ),
      ),
      // No PC a tela é larga demais: o app fica centralizado com
      // largura máxima de 480 (tamanho de celular) e fundo marrom nas laterais
      builder: (context, tela) {
        return Container(
          color: corCafe,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 480),
              child: tela,
            ),
          ),
        );
      },
      home: HomePage(),
    );
  }
}
