import 'package:concentrador_delpim/app/core/controller/controller_impressao.dart';
import 'package:concentrador_delpim/app/core/controller/controller_contagem_impressoes.dart';
import 'package:concentrador_delpim/app/repositories/etiqueta_repository.dart';
import 'package:concentrador_delpim/app/repositories/printer_repository.dart';
import 'package:concentrador_delpim/app/modules/etiquetas/widgets/dialog_editing_etiqueta.dart';
import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/button_header.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/container_eleveted.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/windown.dart';
import 'package:concentrador_delpim/app/modules/etiquetas/widgets/printer_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EtiquetasPage extends StatefulWidget {
  const EtiquetasPage({Key? key}) : super(key: key);

  @override
  State<EtiquetasPage> createState() => _EtiquetasPageState();
}

class _EtiquetasPageState extends State<EtiquetasPage> {
  late final PrinterRepository printerRepository = PrinterRepositorySharedPreferences();
  late final controllerPrint = ControllerImpressao(printerRepository, context.read<EtiquetaRepository>());

  @override
  void dispose() {
    controllerPrint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Windown(
          onPressed: () => Navigator.of(context).pushNamed("home"),
          icon: Icons.arrow_back_ios_new_outlined,
          child: Consumer<EtiquetaRepository>(
            builder: (_, etiqProvider, __) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(color: ColorEx.primary, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const ButtonHeader(text: "ETIQUETAS", selected: true),
                        // ButtonHeader(text: "XML", selected: false, onTap: () => Navigator.of(context).pushNamed("xml")),
                        ButtonHeader(
                            text: "CAMINHO SERVER",
                            selected: false,
                            onTap: () => Navigator.of(context).pushNamed("caminhoServer")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("addEtiqueta");
                        },
                        child: const Row(
                          children: [Text("ADICONAR ETIQUETA"), Icon(Icons.add)],
                        ),
                      ),
                      const SizedBox(width: 300, child: PrinterDropDown()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ContainerEleveted(
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(flex: 2, child: Text("Nº")),
                                Expanded(flex: 6, child: Text("NOME ETIQUETA")),
                                Expanded(flex: 3, child: Text("ETIQUETA PADRÃO")),
                                Expanded(flex: 1, child: SizedBox(child: Text("AÇÕES"))),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: etiqProvider.etiquetas?.length,
                            itemBuilder: (context, index) {
                              final etiqueta = etiqProvider.etiquetas?[index];
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {},
                                    title: etiqueta != null
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(flex: 2, child: Text(etiqueta.id.toString())),
                                              Expanded(flex: 6, child: Text(etiqueta.descricao)),
                                              Expanded(
                                                  flex: 2,
                                                  child: IconButton(
                                                    icon: Icon(etiqProvider.etiquetaSelecionada?.id == etiqueta.id
                                                        ? Icons.check_box
                                                        : Icons.check_box_outline_blank),
                                                    onPressed: () {
                                                      etiqProvider.saveEtiquetaSelecionada(etiqueta);
                                                    },
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return DialogEditingEtiqueta(etiqueta: etiqueta);
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(Icons.edit)),
                                                      IconButton(
                                                          onPressed: () {
                                                            context.read<ContadorImpressao>().somarImpressao();
                                                            controllerPrint.imprimir(
                                                                text: etiqueta.script, produto: null);
                                                          },
                                                          icon: const Icon(Icons.print)),
                                                      IconButton(
                                                          onPressed: () async {
                                                            await etiqProvider.removeEtiqueta(etiqueta);
                                                            setState(() {});
                                                          },
                                                          icon: const Icon(Icons.delete_outline)),
                                                    ],
                                                  )),
                                            ],
                                          )
                                        : null,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
