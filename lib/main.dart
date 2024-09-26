import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'page/notes_page.dart';
import 'my_botton_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static String title = 'Notes SQLite';

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 181, 116, 24),
        scaffoldBackgroundColor: const Color.fromARGB(255, 191, 191, 191),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 2, 48, 71),
          elevation: 0,
        ),
      ),
      home: MyApp(),
    );
  }
}


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light().copyWith(
//         // Define aquí los colores para el tema claro
//         // Por ejemplo:
//         primaryColor: Colors.white,
//         accentColor: Colors.blue,
//         // ...
//       ),
//       darkTheme: ThemeData.dark().copyWith(
//         // Define aquí los colores para el tema oscuro
//         // Por ejemplo:
//         primaryColor: Colors.black,
//         accentColor: Colors.blueAccent,
//         // ...
//       ),
//       themeMode: ThemeMode.system, // Puedes cambiar esto a ThemeMode.dark si quieres forzar el modo oscuro
//       home: MyHomePage(),
//     );
//   }
// }
// class MyWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).backgroundColor,
//       child: Text(
//         'Texto en modo ${Theme.of(context).brightness == Brightness.dark ? 'oscuro' : 'claro'}',
//         style: TextStyle(
//           color: Theme.of(context).textTheme.bodyText1!.color,
//         ),
//       ),
//     );
//   }
// }
