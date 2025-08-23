import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/usuario.dart';
import 'match_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final box = Hive.box<Usuario>('usuarios');

  void login() {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();
    final usuario = box.get(email);

    if (usuario != null && usuario.senha == senha) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => MatchPage(usuario: usuario)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login inválido')),
      );
    }
  }

  void registrar() {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (box.containsKey(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário já existe')),
      );
    } else {
      final novoUsuario = Usuario(
        email: email,
        senha: senha,
        nome: 'Tércio',
        idade: 30,
        interesses: 'Música, Viagens',
        fotoUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      );
      box.put(email, novoUsuario);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => MatchPage(usuario: novoUsuario)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'E-mail')),
            TextField(controller: senhaController, obscureText: true, decoration: InputDecoration(labelText: 'Senha')),
            SizedBox(height: 20),
            ElevatedButton(child: Text('Entrar'), onPressed: login),
            TextButton(child: Text('Criar conta'), onPressed: registrar),
          ],
        ),
      ),
    );
  }
}