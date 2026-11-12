# Cafeteria Tem Café — Trabalho NP2 (Desenvolvimento Mobile)

App em Flutter para pedir café e lanches: **peça e retire** no balcão ou **delivery**.

## Telas (pasta `lib/`)
- `home_page.dart` — cardápio
- `pedido_page.dart` — escolher o item (quantidade, açúcar, observação)
- `sacola_page.dart` — sacola, dados de entrega + ViaCEP (recurso extra) e horário de funcionamento (06:00 às 22:30)
- `pedidos_page.dart` — lista de pedidos em tempo real (Firestore)
- `main.dart` — inicia o Firebase e o app
- `cores.dart` — cores do app
- `firebase_options.dart` — chaves do Firebase

## Como rodar
1. Clonar o repositório e abrir a pasta no VSCode.
2. No terminal: `flutter pub get`
3. Rodar: `flutter run -d chrome`
   (ou `flutter run -d web-server --web-port 5000` e abrir http://localhost:5000)

## Como contribuir
1. Antes de começar: `git pull` (pegar o que os colegas fizeram).
2. Depois de terminar uma parte: `git add .` → `git commit -m "o que você fez"` → `git push`.
3. Combinar no grupo quem mexe em qual arquivo, para não editarem o mesmo arquivo ao mesmo tempo.
