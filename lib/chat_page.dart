import 'package:flutter/material.dart';
import 'models/match.dart';

class ChatPage extends StatefulWidget {
  final Match match;

  const ChatPage({Key? key, required this.match}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController msgController = TextEditingController();
  final List<String> mensagens = [];

  void enviarMensagem() {
    final texto = msgController.text.trim();
    if (texto.isNotEmpty) {
      setState(() {
        mensagens.add(texto);
        msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat com ${widget.match.nome}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mensagens.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(mensagens[index]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(hintText: 'Digite sua mensagem'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: enviarMensagem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}