import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  String email;

  @HiveField(1)
  String senha;

  @HiveField(2)
  String nome;

  @HiveField(3)
  int idade;

  @HiveField(4)
  String interesses;

  @HiveField(5)
  String fotoUrl;

  @HiveField(6)
  double latitude;

  @HiveField(7)
  double longitude;

  Usuario({
    required this.email,
    required this.senha,
    required this.nome,
    required this.idade,
    required this.interesses,
    required this.fotoUrl,
    required this.latitude,
    required this.longitude,
  });
}