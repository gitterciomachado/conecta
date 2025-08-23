import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'models/usuario.dart';

class EditProfilePage extends StatefulWidget {
  final Usuario usuario;

  const EditProfilePage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nomeController;
  late TextEditingController idadeController;
  late TextEditingController interessesController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.usuario.nome);
    idadeController = TextEditingController(text: widget.usuario.idade.toString());
    interessesController = TextEditingController(text: widget.usuario.interesses);
  }

  Future<void> escolherFoto() async {
    final picker = ImagePicker();
    final imagemSelecionada = await picker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final caminhoFinal = '${appDir.path}/$nomeArquivo';

      final imagemSalva = await File(imagemSelecionada.path).copy(caminhoFinal);

      setState(() {
        widget.usuario.fotoUrl = imagemSalva.path;
        widget.usuario.save();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto salva com sucesso!')),
      );
    }
  }

  void salvarPerfil() {
    widget.usuario.nome = nomeController.text.trim();
    widget.usuario.idade = int.tryParse(idadeController.text.trim()) ?? widget.usuario.idade;
    widget.usuario.interesses = interessesController.text.trim();
    widget.usuario.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final imagem = widget.usuario.fotoUrl.startsWith('http')
        ? NetworkImage(widget.usuario.fotoUrl)
        : FileImage(File(widget.usuario.fotoUrl)) as ImageProvider;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            CircleAvatar(radius: 60, backgroundImage: imagem),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Escolher foto do dispositivo'),
              onPressed: escolherFoto,
            ),
            const SizedBox(height: 16),
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 16),
            TextField(controller: idadeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Idade')),
            const SizedBox(height: 16),
            TextField(controller: interessesController, decoration: const InputDecoration(labelText: 'Interesses')),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: salvarPerfil, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}