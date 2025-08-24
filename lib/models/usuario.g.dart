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
      id: fields[0] as String,
      email: fields[1] as String,
      senha: fields[2] as String,
      nome: fields[3] as String,
      idade: fields[4] as int,
      interesses: fields[5] as String,
      fotoUrl: fields[6] as String,
      latitude: fields[7] as double?,
      longitude: fields[8] as double?,
      genero: fields[9] as String?,
      estadoCivil: fields[10] as String?,
      filhos: fields[11] as String?,
      religiao: fields[12] as String?,
      habitosSaude: fields[13] as String?,
      atividadeFisica: fields[14] as String?,
      escolaridade: fields[15] as String?,
      profissao: fields[16] as String?,
      signo: fields[17] as String?,
      linguagemAmor: fields[18] as String?,
      valoresPessoais: fields[19] as String?,
      estiloViagem: fields[20] as String?,
      estiloVida: fields[21] as String?,
      verificado: fields[22] as bool,
      bloqueados: (fields[23] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.senha)
      ..writeByte(3)
      ..write(obj.nome)
      ..writeByte(4)
      ..write(obj.idade)
      ..writeByte(5)
      ..write(obj.interesses)
      ..writeByte(6)
      ..write(obj.fotoUrl)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.genero)
      ..writeByte(10)
      ..write(obj.estadoCivil)
      ..writeByte(11)
      ..write(obj.filhos)
      ..writeByte(12)
      ..write(obj.religiao)
      ..writeByte(13)
      ..write(obj.habitosSaude)
      ..writeByte(14)
      ..write(obj.atividadeFisica)
      ..writeByte(15)
      ..write(obj.escolaridade)
      ..writeByte(16)
      ..write(obj.profissao)
      ..writeByte(17)
      ..write(obj.signo)
      ..writeByte(18)
      ..write(obj.linguagemAmor)
      ..writeByte(19)
      ..write(obj.valoresPessoais)
      ..writeByte(20)
      ..write(obj.estiloViagem)
      ..writeByte(21)
      ..write(obj.estiloVida)
      ..writeByte(22)
      ..write(obj.verificado)
      ..writeByte(23)
      ..write(obj.bloqueados);
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
