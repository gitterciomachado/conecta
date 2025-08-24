import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/usuario.dart';
import 'models/match.dart';
import 'login_page.dart';
import 'chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registro dos adapters Hive
  Hive.registerAdapter(UsuarioAdapter());
  Hive.registerAdapter(MatchAdapter());

  // Abertura das boxes
  await Hive.openBox<Usuario>('usuarios');
  await Hive.openBox<Match>('matches');

  runApp(ConectaApp());
}

class ConectaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conecta ❤️',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
      routes: {
        '/chat': (context) {
          final match = ModalRoute.of(context)!.settings.arguments as Match;
          return ChatPage(match: match);
        },
      },
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bem-vindo ao Conecta ❤️',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text('Entrar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}