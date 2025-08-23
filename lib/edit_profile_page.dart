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
  File? _imagemTemporaria;
  List<String> interessesSelecionados = [];

  final Map<String, List<String>> interessesPorCategoria = {
    '🎵 Música': [
      'Rock', 'Sertanejo', 'Pop', 'Rap', 'Samba', 'Jazz',
      'Tocar instrumento', 'Cantar', 'Ir a shows',
    ],
    '🎬 Entretenimento': [
      'Comédia', 'Romance', 'Terror', 'Ação',
      'Séries/Streaming', 'Livros favoritos', 'Podcasts',
    ],
    '🏋️ Estilo de vida': [
      'Futebol', 'Corrida', 'Natação', 'Academia', 'Yoga',
      'Vegetariano', 'Vegano', 'Fitness', 'Gourmet', 'Churrasco',
      'Praia', 'Campo', 'Mochilão', 'Turismo cultural',
      'Cachorro', 'Gato', 'Animais exóticos',
    ],
    '🎨 Criatividade': [
      'Fotografia', 'Desenho/Pintura', 'Escrita', 'Dança', 'Artesanato',
    ],
    '💻 Tecnologia & Jogos': [
      'Games (console)', 'Games (PC)', 'Games (mobile)',
      'Programação', 'Realidade virtual', 'Metaverso',
    ],
    '🌱 Causas & Valores': [
      'Sustentabilidade', 'Trabalho voluntário',
      'Espiritualidade', 'Religião', 'Política', 'Ativismo',
    ],
    '🍷 Social': [
      'Baladas', 'Bares', 'Festas',
      'Restaurantes', 'Gastronomia', 'Viagens em grupo',
    ],
  };

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.usuario.nome);
    idadeController = TextEditingController(text: widget.usuario.idade.toString());
    interessesSelecionados = widget.usuario.interesses.split(', ').where((i) => i.isNotEmpty).toList();
  }

  Future<void> escolherFoto() async {
    final picker = ImagePicker();
    final imagemSelecionada = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (imagemSelecionada != null) {
      setState(() {
        _imagemTemporaria = File(imagemSelecionada.path);
      });
    }
  }

  Future<void> salvarPerfil() async {
    if (_imagemTemporaria != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final caminhoFinal = '${appDir.path}/$nomeArquivo';

      final imagemSalva = await _imagemTemporaria!.copy(caminhoFinal);
      widget.usuario.fotoUrl = imagemSalva.path;
    }

    widget.usuario.nome = nomeController.text.trim();
    widget.usuario.idade = int.tryParse(idadeController.text.trim()) ?? widget.usuario.idade;
    widget.usuario.interesses = interessesSelecionados.join(', ');
    widget.usuario.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
    Navigator.pop(context);
  }

  Widget buildInteresses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: interessesPorCategoria.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: entry.value.map((item) {
                final selecionado = interessesSelecionados.contains(item);
                return ChoiceChip(
                  label: Text(item),
                  selected: selecionado,
                  onSelected: (bool value) {
                    setState(() {
                      if (value) {
                        interessesSelecionados.add(item);
                      } else {
                        interessesSelecionados.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imagem;

    if (_imagemTemporaria != null) {
      imagem = FileImage(_imagemTemporaria!);
    } else if (widget.usuario.fotoUrl.startsWith('http')) {
      imagem = NetworkImage(widget.usuario.fotoUrl);
    } else {
      imagem = FileImage(File(widget.usuario.fotoUrl));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Center(
              child: ClipOval(
                child: Image(
                  image: imagem,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Escolher foto do dispositivo'),
              onPressed: escolherFoto,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Idade'),
            ),
            const SizedBox(height: 24),
            Text('Selecione seus interesses:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            buildInteresses(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: salvarPerfil,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}