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
  double? latitude;

  @HiveField(7)
  double? longitude;

  @HiveField(8)
  String? genero;

  @HiveField(9)
  String? estadoCivil;

  @HiveField(10)
  String? filhos;

  @HiveField(11)
  String? religiao;

  @HiveField(12)
  String? habitosSaude;

  @HiveField(13)
  String? atividadeFisica;

  @HiveField(14)
  String? escolaridade;

  @HiveField(15)
  String? profissao;

  @HiveField(16)
  String? signo;

  @HiveField(17)
  String? linguagemAmor;

  @HiveField(18)
  String? valoresPessoais;

  @HiveField(19)
  String? estiloViagem;

  @HiveField(20)
  String? estiloVida;

  Usuario({
    required this.email,
    required this.senha,
    required this.nome,
    required this.idade,
    required this.interesses,
    required this.fotoUrl,
    this.latitude,
    this.longitude,
    this.genero,
    this.estadoCivil,
    this.filhos,
    this.religiao,
    this.habitosSaude,
    this.atividadeFisica,
    this.escolaridade,
    this.profissao,
    this.signo,
    this.linguagemAmor,
    this.valoresPessoais,
    this.estiloViagem,
    this.estiloVida,
  });
}