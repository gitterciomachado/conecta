import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> tirarSelfie() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.camera);

    if (imagem != null) {
      setState(() {
        imagemSelfie = File(imagem.path);
      });
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
    return Scaffold(
      appBar: AppBar(title: Text('Verificação de Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text('Tire uma selfie para confirmar sua identidade'),
            SizedBox(height: 20),
            imagemSelfie != null
                ? Image.file(imagemSelfie!, height: 200)
                : Icon(Icons.person, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: tirarSelfie,
              child: Text('Tirar Selfie'),
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