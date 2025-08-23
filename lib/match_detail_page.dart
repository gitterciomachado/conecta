import 'package:flutter/material.dart';
import 'models/match.dart';

class MatchDetailPage extends StatelessWidget {
  final Match match;

  const MatchDetailPage({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(match.nome)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(match.fotoUrl),
            ),
            SizedBox(height: 20),
            Text(match.nome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Interesses: ${match.interesses}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 40),
            ElevatedButton(
              child: Text('Enviar mensagem'),
              onPressed: () {
                Navigator.pushNamed(context, '/chat', arguments: match);
              },
            ),
          ],
        ),
      ),
    );
  }
}