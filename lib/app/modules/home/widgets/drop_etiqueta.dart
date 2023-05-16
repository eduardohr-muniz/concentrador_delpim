import 'package:concentrador_delpim/app/models/etiqueta.dart';
import 'package:concentrador_delpim/app/repositories/etiqueta_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropEtiqueta extends StatefulWidget {
  const DropEtiqueta({Key? key}) : super(key: key);
  @override
  State<DropEtiqueta> createState() => _DropEtiquetaState();
}

class _DropEtiquetaState extends State<DropEtiqueta> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EtiquetaRepository>(builder: (_, etiqueta, __) {
      return AnimatedBuilder(
          animation: etiqueta,
          builder: (context, child) {
            return Expanded(
              flex: 5,
              child: DropdownButtonFormField<Etiqueta>(
                decoration: InputDecoration(
                  label: Text(etiqueta.etiquetaSelecionada == null ? "Selecione um modelo" : "Modelo"),
                ),
                value: etiqueta.etiquetaSelecionada,
                items: etiqueta.etiquetas?.map((etiqueta) {
                  return DropdownMenuItem<Etiqueta>(
                    value: etiqueta,
                    key: Key(etiqueta.id.toString()),
                    child: Text(etiqueta.descricao),
                  );
                }).toList(),
                onChanged: (value) {
                  etiqueta.saveEtiquetaSelecionada(value!);
                },
              ),
            );
          });
    });
  }
}
