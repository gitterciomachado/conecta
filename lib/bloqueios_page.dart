import 'package:flutter/material.dart';
import 'models/usuario.dart';
import 'dart:io';

class BloqueiosPage extends StatefulWidget {
  final Usuario usuario;

  const BloqueiosPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<BloqueiosPage> createState() => _BloqueiosPageState();
}

class _BloqueiosPageState extends State<BloqueiosPage> {
  List<Usuario> perfisBloqueados = [];

  @override
  void initState() {
    super.initState();
    carregarBloqueados();
  }

  void carregarBloqueados() {
    // Simulação: substitua por sua lógica real de busca
    perfisBloqueados = widget.usuario.bloqueados.map((id) {
      return Usuario.buscarPorId(id); // método fictício
    }).toList();
  }

  void desbloquear(Usuario perfil) {
    setState(() {
      widget.usuario.bloqueados.remove(perfil.id);
      widget.usuario.save();
      carregarBloqueados();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${perfil.nome} foi desbloqueado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuários Bloqueados')),
      body: perfisBloqueados.isEmpty
          ? Center(child: Text('Você não bloqueou ninguém ainda.'))
          : ListView.builder(
              itemCount: perfisBloqueados.length,
              itemBuilder: (context, index) {
                final perfil = perfisBloqueados[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: perfil.fotoUrl.startsWith('http')
                        ? NetworkImage(perfil.fotoUrl)
                        : FileImage(File(perfil.fotoUrl)) as ImageProvider,
                  ),
                  title: Text(perfil.nome),
                  trailing: IconButton(
                    icon: Icon(Icons.undo, color: Colors.green),
                    onPressed: () => desbloquear(perfil),
                  ),
                );
              },
            ),
    );
  }
}