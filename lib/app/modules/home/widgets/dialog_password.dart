// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DialogPassword extends StatefulWidget {
  const DialogPassword({Key? key}) : super(key: key);

  @override
  State<DialogPassword> createState() => _DialogPasswordState();
}

class _DialogPasswordState extends State<DialogPassword> {
  final passwordEC = TextEditingController();

  void verificarSenha() {
    DateTime agora = DateTime.now();
    String senhaCode =
        "${agora.day.toString()}${agora.month.toString().padLeft(2, "0")}${agora.hour.toString()}${agora.year % 100}";
    if (passwordEC.text == senhaCode.toString()) {
      Navigator.of(context).pushNamed("etiquetas");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Senha incorreta "),
        backgroundColor: Colors.amber,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Requer acesso de administrador"),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 250,
          child: TextFormField(
            autofocus: true,
            obscureText: true,
            onFieldSubmitted: (_) {
              verificarSenha();
            },
            controller: passwordEC,
            decoration: const InputDecoration(label: Text("Insira a senha")),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar")),
        TextButton(
            onPressed: () {
              verificarSenha();
            },
            child: const Text("Verificar")),
      ],
    );
  }
}
