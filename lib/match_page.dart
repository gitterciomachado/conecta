import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
import 'models/usuario.dart';
import 'models/match.dart';
import 'edit_profile_page.dart';
import 'match_history_page.dart';
import 'mapa_page.dart';
import 'verificacao_page.dart';

class MatchPage extends StatefulWidget {
  final Usuario usuario;

  const MatchPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<Map<String, dynamic>> perfisOriginais = [
    {
      'id': 'bruno123',
      'nome': 'Bruno',
      'foto': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
      'interesses': 'Filmes, Corrida, Música',
      'latitude': -5.800,
      'longitude': -35.200,
      'verificado': true,
    },
    {
      'id': 'carla456',
      'nome': 'Carla',
      'foto': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      'interesses': 'Leitura, Yoga, Música',
      'latitude': -5.810,
      'longitude': -35.220,
      'verificado': false,
    },
  ];

  List<Map<String, dynamic>> perfis = [];
  final PageController _controller = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    carregarPerfis();
  }

  void carregarPerfis() {
    final filtrados = filtrarPorDistancia(
      perfisOriginais,
      widget.usuario.latitude,
      widget.usuario.longitude,
      20,
    );

    final bloqueados = widget.usuario.bloqueados ?? [];

    final visiveis = filtrados.where((perfil) {
      final id = perfil['id'];
      return id != null && !bloqueados.contains(id);
    }).toList();

    setState(() {
      perfis = visiveis;
      ordenarPorCompatibilidade();
    });
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

  double? calcularDistanciaKm(double? lat1, double? lon1, double? lat2, double? lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return null;
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  List<Map<String, dynamic>> filtrarPorDistancia(
    List<Map<String, dynamic>> lista,
    double? latUser,
    double? lonUser,
    double raioKm,
  ) {
    return lista.where((perfil) {
      final lat = perfil['latitude'];
      final lon = perfil['longitude'];
      if (latUser == null || lonUser == null || lat == null || lon == null) return false;

      final distancia = Geolocator.distanceBetween(latUser, lonUser, lat, lon) / 1000;
      return distancia <= raioKm;
    }).toList();
  }

  void salvarMatch(Map<String, dynamic> perfil) {
    final matchBox = Hive.box<Match>('matches');

    final jaExiste = matchBox.values.any((m) => m.usuarioAlvoId == perfil['id']);
    if (jaExiste) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${perfil['nome']} já está nos seus matches')),
      );
      return;
    }

    matchBox.add(Match(
      nome: perfil['nome'],
      interesses: perfil['interesses'],
      fotoUrl: perfil['foto'],
      usuarioAlvoId: perfil['id'],
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você curtiu ${perfil['nome']}!')),
    );
  }

  void bloquearPerfil(Map<String, dynamic> perfil, int index) {
    final id = perfil['id'];
    if (widget.usuario.bloqueados.contains(id)) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Bloquear ${perfil['nome']}?'),
        content: Text('Você não verá mais este perfil nas sugestões.'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Bloquear'),
            onPressed: () {
              Navigator.pop(context);
              widget.usuario.bloqueados.add(id);
              widget.usuario.save();
              carregarPerfis();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${perfil['nome']} foi bloqueado')),
              );
            },
          ),
        ],
      ),
    );
  }

  void restaurarPerfisBloqueados() {
    setState(() {
      widget.usuario.bloqueados.clear();
      widget.usuario.save();
      carregarPerfis();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Perfis desbloqueados e restaurados')),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${widget.usuario.nome}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Restaurar perfis',
            onPressed: restaurarPerfisBloqueados,
          ),
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
                  builder: (_) => MatchHistoryPage(usuarioAtual: widget.usuario),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapaPage(usuario: widget.usuario, perfis: perfis),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.verified_user),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificacaoPage(usuario: widget.usuario),
                ),
              );
            },
          ),
        ],
      ),
      body: perfis.isEmpty
          ? Center(child: Text('Nenhum perfil disponível no momento.'))
          : PageView.builder(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            perfil['nome'],
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          if (perfil['verificado'] == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Icon(Icons.verified, color: Colors.blue, size: 20),
                            ),
                        ],
                      ),
                      Text(
                        perfil['interesses'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 10),
                      Text('Compatibilidade: $compatibilidade pontos'),
                      if (distanciaKm != null)
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
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: Icon(Icons.block),
                        label: Text('Bloquear'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => bloquearPerfil(perfil, index),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}