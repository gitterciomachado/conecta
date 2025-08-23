// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 0;

  @override
  Usuario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usuario(
      email: fields[0] as String,
      senha: fields[1] as String,
      nome: fields[2] as String,
      idade: fields[3] as int,
      interesses: fields[4] as String,
      fotoUrl: fields[5] as String,
      latitude: fields[6] as double?,
      longitude: fields[7] as double?,
      genero: fields[8] as String?,
      estadoCivil: fields[9] as String?,
      filhos: fields[10] as String?,
      religiao: fields[11] as String?,
      habitosSaude: fields[12] as String?,
      atividadeFisica: fields[13] as String?,
      escolaridade: fields[14] as String?,
      profissao: fields[15] as String?,
      signo: fields[16] as String?,
      linguagemAmor: fields[17] as String?,
      valoresPessoais: fields[18] as String?,
      estiloViagem: fields[19] as String?,
      estiloVida: fields[20] as String?,
      verificado: fields[21] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.senha)
      ..writeByte(2)
      ..write(obj.nome)
      ..writeByte(3)
      ..write(obj.idade)
      ..writeByte(4)
      ..write(obj.interesses)
      ..writeByte(5)
      ..write(obj.fotoUrl)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.genero)
      ..writeByte(9)
      ..write(obj.estadoCivil)
      ..writeByte(10)
      ..write(obj.filhos)
      ..writeByte(11)
      ..write(obj.religiao)
      ..writeByte(12)
      ..write(obj.habitosSaude)
      ..writeByte(13)
      ..write(obj.atividadeFisica)
      ..writeByte(14)
      ..write(obj.escolaridade)
      ..writeByte(15)
      ..write(obj.profissao)
      ..writeByte(16)
      ..write(obj.signo)
      ..writeByte(17)
      ..write(obj.linguagemAmor)
      ..writeByte(18)
      ..write(obj.valoresPessoais)
      ..writeByte(19)
      ..write(obj.estiloViagem)
      ..writeByte(20)
      ..write(obj.estiloVida)
      ..writeByte(21)
      ..write(obj.verificado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
