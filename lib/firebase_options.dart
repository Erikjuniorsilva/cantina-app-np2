import 'package:firebase_core/firebase_core.dart';

// Copie os valores do firebaseConfig do console do Firebase (aula 09):
// Configurações do projeto > Seus apps > app web </>
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "COLE-AQUI-O-SEU-apiKey",
      authDomain: "COLE-AQUI-O-SEU-authDomain",
      projectId: "COLE-AQUI-O-SEU-projectId",
      storageBucket: "COLE-AQUI-O-SEU-storageBucket",
      messagingSenderId: "COLE-AQUI-O-SEU-messagingSenderId",
      appId: "COLE-AQUI-O-SEU-appId",
    );
  }
}
