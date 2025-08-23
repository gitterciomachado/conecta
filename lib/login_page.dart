import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<void> login() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();
    final usuario = box.get(email);

    if (usuario != null && usuario.senha == senha) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MatchPage(usuario: usuario)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login inválido')),
      );
    }
  }

  Future<void> registrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (box.containsKey(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário já existe')),
      );
    } else {
      bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ative o serviço de localização')),
        );
        return;
      }

      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Permissão de localização negada')),
          );
          return;
        }
      }

      if (permissao == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permissão de localização permanentemente negada')),
        );
        return;
      }

      final posicao = await Geolocator.getCurrentPosition();

      final novoUsuario = Usuario(
        email: email,
        senha: senha,
        nome: 'Tércio',
        idade: 30,
        interesses: 'Música, Viagens',
        fotoUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        latitude: posicao.latitude,
        longitude: posicao.longitude,
        genero: 'Masculino',
        estadoCivil: 'Solteiro',
        filhos: 'Não tem',
        religiao: 'Espiritualista',
        habitosSaude: 'Não fuma, bebe socialmente',
        atividadeFisica: 'Moderado',
        escolaridade: 'Faculdade',
        profissao: 'Desenvolvedor',
        signo: 'Leão',
        linguagemAmor: 'Tempo de qualidade',
        valoresPessoais: 'Família, liberdade',
        estiloViagem: 'Ama viajar',
        estiloVida: 'Mais social',
      );

      box.put(email, novoUsuario);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MatchPage(usuario: novoUsuario)),
      );
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
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Entrar'),
              onPressed: login,
            ),
            TextButton(
              child: Text('Criar conta'),
              onPressed: registrar,
            ),
          ],
        ),
      ),
    );
  }
}