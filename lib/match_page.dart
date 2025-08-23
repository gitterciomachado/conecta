import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
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
  List<Map<String, dynamic>> perfis = [
    {
      'nome': 'Bruno',
      'foto': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
      'interesses': 'Filmes, Corrida, Música',
      'latitude': -5.800,
      'longitude': -35.200,
    },
    {
      'nome': 'Carla',
      'foto': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      'interesses': 'Leitura, Yoga, Música',
      'latitude': -5.810,
      'longitude': -35.220,
    },
  ];

  final PageController _controller = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    ordenarPorCompatibilidade();
  }

  void ordenarPorCompatibilidade() {
    perfis.sort((a, b) {
      final scoreA = calcularCompatibilidade(widget.usuario.interesses, a['interesses']);
      final scoreB = calcularCompatibilidade(widget.usuario.interesses, b['interesses']);
      return scoreB.compareTo(scoreA);
    });
  }

  int calcularCompatibilidade(String interessesA, String interessesB) {
    final listaA = interessesA.split(', ');
    final listaB = interessesB.split(', ');
    return listaA.where((i) => listaB.contains(i)).length;
  }

  double calcularDistanciaKm(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  void salvarMatch(Map<String, dynamic> perfil) {
    final matchBox = Hive.box<Match>('matches');
    matchBox.add(Match(
      nome: perfil['nome'],
      interesses: perfil['interesses'],
      fotoUrl: perfil['foto'],
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
          final compatibilidade = calcularCompatibilidade(widget.usuario.interesses, perfil['interesses']);
          final distanciaKm = calcularDistanciaKm(
            widget.usuario.latitude,
            widget.usuario.longitude,
            perfil['latitude'],
            perfil['longitude'],
          );

          return Card(
            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(perfil['foto']),
                ),
                SizedBox(height: 20),
                Text(
                  perfil['nome'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  perfil['interesses'],
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                Text('Compatibilidade: $compatibilidade pontos'),
                Text('Distância: ${distanciaKm.toStringAsFixed(1)} km'),
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