import 'package:hive/hive.dart';

part 'match.g.dart';

@HiveType(typeId: 1)
class Match extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  String interesses;

  @HiveField(2)
  String fotoUrl;

  @HiveField(3)
  bool favorito;

  @HiveField(4)
  String usuarioAlvoId;

  Match({
    required this.nome,
    required this.interesses,
    required this.fotoUrl,
    this.favorito = false,
    required this.usuarioAlvoId,
  });
}