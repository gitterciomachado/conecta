import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/usuario.dart';
import 'models/match.dart';
import 'edit_profile_page.dart';
import 'match_history_page.dart';

class MatchPage extends StatefulWidget {
  final Usuario usuario;

  const MatchPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final List<Map<String, String>> perfis = [
    {
      'nome': 'Bruno',
      'foto': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
      'interesses': 'Filmes, Corrida'
    },
    {
      'nome': 'Carla',
      'foto': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      'interesses': 'Leitura, Yoga'
    },
  ];

  final PageController _controller = PageController(viewportFraction: 0.9);

  void salvarMatch(Map<String, String> perfil) {
    final matchBox = Hive.box<Match>('matches');
    matchBox.add(Match(
      nome: perfil['nome']!,
      interesses: perfil['interesses']!,
      fotoUrl: perfil['foto']!,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você curtiu ${perfil['nome']}!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${widget.usuario.nome}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(usuario: widget.usuario),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MatchHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: perfis.length,
        controller: _controller,
        itemBuilder: (context, index) {
          final perfil = perfis[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(perfil['foto']!),
                ),
                SizedBox(height: 20),
                Text(
                  perfil['nome']!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  perfil['interesses']!,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: Text('Passar'),
                      onPressed: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                      child: Text('Curtir'),
                      onPressed: () {
                        salvarMatch(perfil);
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}