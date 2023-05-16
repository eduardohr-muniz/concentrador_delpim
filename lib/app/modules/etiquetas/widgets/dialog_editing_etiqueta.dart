// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:concentrador_delpim/app/repositories/etiqueta_repository.dart';
import 'package:flutter/material.dart';
import 'package:concentrador_delpim/app/models/etiqueta.dart';
import 'package:provider/provider.dart';

class DialogEditingEtiqueta extends StatefulWidget {
  final Etiqueta etiqueta;
  const DialogEditingEtiqueta({
    Key? key,
    required this.etiqueta,
  }) : super(key: key);

  @override
  State<DialogEditingEtiqueta> createState() => _DialogEditingEtiquetaState();
}

class _DialogEditingEtiquetaState extends State<DialogEditingEtiqueta> {
  @override
  Widget build(BuildContext context) {
    EtiquetaRepository etiquetaRepository = context.read<EtiquetaRepository>();
    final scriptEC = TextEditingController();
    scriptEC.text = widget.etiqueta.script;
    return AlertDialog(
      title: const Text("Editar Script"),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 500,
          child: TextFormField(
            controller: scriptEC,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(label: Text("SCRIPT")),
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
              etiquetaRepository.editarScript(widget.etiqueta, scriptEC.text);
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text("Salvar")),
      ],
    );
  }
}
