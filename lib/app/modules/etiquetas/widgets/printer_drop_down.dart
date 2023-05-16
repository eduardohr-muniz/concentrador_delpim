import 'package:concentrador_delpim/app/core/controller/controller_impressao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/impressora.dart';

class PrinterDropDown extends StatelessWidget {
  const PrinterDropDown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: context.read<ControllerImpressao>(),
        builder: (context, child) {
          return DropdownButtonFormField(
              decoration: InputDecoration(
                prefixIcon:
                    !context.read<ControllerImpressao>().hasSelectedPrinter ? const Icon(Icons.print_outlined) : null,
                label: Text(!context.read<ControllerImpressao>().hasSelectedPrinter
                    ? "Selecione uma impressora"
                    : "Impressora"),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              value: context.read<ControllerImpressao>().selectedPrinter,
              items: context.read<ControllerImpressao>().printers.map((Impressora printer) {
                return DropdownMenuItem(
                  value: printer,
                  child: Row(children: [
                    const Icon(Icons.print_outlined),
                    const SizedBox(width: 5),
                    Text(printer.deviceName.toString()),
                  ]),
                );
              }).toList(),
              onChanged: context.read<ControllerImpressao>().setSelectedPrinter);
        });
  }
}
