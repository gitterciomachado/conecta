import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String senha;

  @HiveField(3)
  String nome;

  @HiveField(4)
  int idade;

  @HiveField(5)
  String interesses;

  @HiveField(6)
  String fotoUrl;

  @HiveField(7)
  double? latitude;

  @HiveField(8)
  double? longitude;

  @HiveField(9)
  String? genero;

  @HiveField(10)
  String? estadoCivil;

  @HiveField(11)
  String? filhos;

  @HiveField(12)
  String? religiao;

  @HiveField(13)
  String? habitosSaude;

  @HiveField(14)
  String? atividadeFisica;

  @HiveField(15)
  String? escolaridade;

  @HiveField(16)
  String? profissao;

  @HiveField(17)
  String? signo;

  @HiveField(18)
  String? linguagemAmor;

  @HiveField(19)
  String? valoresPessoais;

  @HiveField(20)
  String? estiloViagem;

  @HiveField(21)
  String? estiloVida;

  @HiveField(22)
  bool verificado;

  @HiveField(23)
  List<String> bloqueados;

  Usuario({
    required this.id,
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
    this.verificado = false,
    this.bloqueados = const [],
  });

  /// Busca um usuário pelo ID dentro da box Hive
  static Usuario buscarPorId(String id) {
    final box = Hive.box<Usuario>('usuarios');
    return box.values.firstWhere((usuario) => usuario.id == id);
  }
}