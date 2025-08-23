import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/match.dart';
import 'match_detail_page.dart';

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({Key? key}) : super(key: key);

  @override
  State<MatchHistoryPage> createState() => _MatchHistoryPageState();
}

class _MatchHistoryPageState extends State<MatchHistoryPage> {
  final TextEditingController filtroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final matchBox = Hive.box<Match>('matches');

    return Scaffold(
      appBar: AppBar(title: const Text('Seus Matches')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: filtroController,
              decoration: InputDecoration(
                labelText: 'Buscar por nome ou interesse',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Match>>(
              valueListenable: matchBox.listenable(),
              builder: (context, box, _) {
                final filtro = filtroController.text.toLowerCase();
                final matches = box.values.where((match) {
                  return match.nome.toLowerCase().contains(filtro) ||
                      match.interesses.toLowerCase().contains(filtro);
                }).toList();

                if (matches.isEmpty) {
                  return const Center(child: Text('Nenhum match encontrado.'));
                }

                return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(match.fotoUrl),
                        ),
                        title: Text(match.nome),
                        subtitle: Text(match.interesses),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(match.favorito ? Icons.star : Icons.star_border),
                              onPressed: () {
                                match.favorito = !match.favorito;
                                match.save();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                match.delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${match.nome} removido')),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MatchDetailPage(match: match)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}