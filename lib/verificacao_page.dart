import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'models/usuario.dart';

class VerificacaoPage extends StatefulWidget {
  final Usuario usuario;

  const VerificacaoPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<VerificacaoPage> createState() => _VerificacaoPageState();
}

class _VerificacaoPageState extends State<VerificacaoPage> {
  File? imagemSelfie;

  Future<void> selecionarImagem() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final picker = ImagePicker();
        final imagem = await picker.pickImage(source: ImageSource.camera);

        if (imagem != null) {
          setState(() {
            imagemSelfie = File(imagem.path);
          });
        }
      } else {
        final resultado = await FilePicker.platform.pickFiles(type: FileType.image);
        if (resultado != null && resultado.files.single.path != null) {
          setState(() {
            imagemSelfie = File(resultado.files.single.path!);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nenhuma imagem selecionada')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagem')),
      );
    }
  }

  void confirmarVerificacao() {
    widget.usuario.verificado = true;
    widget.usuario.save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Perfil verificado com sucesso!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textoInstrucao = Platform.isAndroid || Platform.isIOS
        ? 'Tire uma selfie para confirmar sua identidade'
        : 'Selecione uma imagem do seu computador para verificação';

    return Scaffold(
      appBar: AppBar(title: Text('Verificação de Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(textoInstrucao),
            SizedBox(height: 20),
            imagemSelfie != null
                ? Image.file(imagemSelfie!, height: 200)
                : Icon(Icons.person, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selecionarImagem,
              child: Text(Platform.isAndroid || Platform.isIOS
                  ? 'Tirar Selfie'
                  : 'Selecionar Imagem'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: imagemSelfie != null ? confirmarVerificacao : null,
              child: Text('Confirmar Verificação'),
            ),
          ],
        ),
      ),
    );
  }
}