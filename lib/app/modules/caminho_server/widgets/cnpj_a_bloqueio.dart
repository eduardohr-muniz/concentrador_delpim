// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:concentrador_delpim/app/core/ui/widgets/d_text_form_fild.dart';
import 'package:concentrador_delpim/app/modules/caminho_server/controller_caminho_server.dart';

class CnpjABloqueio extends StatelessWidget {
  final ControllerCaminhoServer controller;
  const CnpjABloqueio({
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
              Expanded(child: CwTextFild(controller: controller.cnpjClienteEC, label: "CNPJ DO CLIENTE")),
              const SizedBox(width: 50),
              Expanded(child: CwTextFild(controller: controller.pathErpGestao, label: "PATH ERP_GESTAO")),
            ],
          ),
        ),
        const SizedBox(width: 80)
      ],
    );
  }
}
