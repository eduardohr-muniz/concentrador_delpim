// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';
import 'package:flutter/material.dart';

import 'package:concentrador_delpim/app/core/ui/widgets/d_text_form_fild.dart';
import 'package:concentrador_delpim/app/modules/caminho_server/controller_caminho_server.dart';

class HistoricoLogARestaurar extends StatelessWidget {
  final ControllerCaminhoServer controller;
  const HistoricoLogARestaurar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: CwTextFild(controller: controller.pathHistoricoLogEC, label: "PATH HISTORICO LOG")),
              const SizedBox(width: 50),
              Expanded(child: CwTextFild(controller: controller.pathPdvCadEC, label: "PATH PDV_CAD")),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
                tooltip: "Salvar",
                onPressed: () {
                  controller.salvarPaths();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("SALVO COM SUCESSO!"), backgroundColor: Colors.green));
                },
                icon: const Icon(Icons.save, color: ColorEx.primary)),
            IconButton(
                tooltip: "Restaurar Paths",
                onPressed: () {
                  controller.restaurarPaths();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("PATHS RESTAURADOS"), backgroundColor: Colors.green));
                },
                icon: const Icon(Icons.restore, color: ColorEx.primary)),
          ],
        ),
      ],
    );
  }
}
