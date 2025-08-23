import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/usuario.dart';
import 'models/match.dart';
import 'login_page.dart';
import 'chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UsuarioAdapter());
  Hive.registerAdapter(MatchAdapter());

  await Hive.openBox<Usuario>('usuarios');
  await Hive.openBox<Match>('matches');

  runApp(ConectaApp());
}

class ConectaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conecta ❤️',
      theme: ThemeData(primarySwatch: Colors.pink),
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
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bem-vindo ao Conecta ❤️',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              ElevatedButton(
                child: Text('Entrar'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}