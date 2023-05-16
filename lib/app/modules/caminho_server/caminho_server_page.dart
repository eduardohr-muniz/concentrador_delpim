import 'package:concentrador_delpim/app/core/controller/controller_produtos.dart';
import 'package:concentrador_delpim/app/core/controller/controller_contagem_impressoes.dart';
import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/button_header.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/container_eleveted.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/d_text_form_fild.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/windown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaminhoServerPage extends StatefulWidget {
  const CaminhoServerPage({Key? key}) : super(key: key);

  @override
  State<CaminhoServerPage> createState() => _CaminhoServerPageState();
}

class _CaminhoServerPageState extends State<CaminhoServerPage> {
  final controller = ControllerProdutos();
  final pathTxtEC = TextEditingController();
  final pathPdvCadEC = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var txt = await controller.getPathTxt("txt");
    var pdvCad = await controller.getPathPdvCad("pdvCad");
    setState(() {
      pathTxtEC.text = txt;
      pathPdvCadEC.text = pdvCad;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pathPdvCadEC.dispose();
    pathTxtEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Windown(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back_ios_new_outlined,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: ColorEx.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    ButtonHeader(
                        text: "ETIQUETAS", selected: false, onTap: () => Navigator.of(context).pushNamed("etiquetas")),
                    // ButtonHeader(text: "XML", selected: false, onTap: () => Navigator.of(context).pushNamed("xml")),
                    const ButtonHeader(text: "CAMINHO SERVER", selected: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ContainerEleveted(
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      child: const Padding(
                          padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                          child: Center(child: Text("CAMINHOS SERVER"))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: DTextFormFild(
                                    controller: pathTxtEC,
                                    label: const Text("PATH HISTORICO_LOG"),
                                  )),
                              const SizedBox(width: 50),
                              Expanded(
                                  flex: 3,
                                  child: DTextFormFild(controller: pathPdvCadEC, label: const Text("PATH PDV_CAD"))),
                              Expanded(
                                  flex: 0,
                                  child: IconButton(
                                      tooltip: "Salvar",
                                      onPressed: () {
                                        controller.savePathPdvCad(pathPdvCadEC.text);
                                        controller.savePathTxt(pathTxtEC.text);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("SALVO COM SUCESSO!"), backgroundColor: Colors.green));
                                      },
                                      icon: const Icon(Icons.save, color: ColorEx.primary))),
                              Expanded(
                                  flex: 0,
                                  child: IconButton(
                                      tooltip: "Restaurar Paths",
                                      onPressed: () {
                                        String pathPdv = "C:\\Server_PDV\\enviar\\tabela";
                                        String pathTxt = "C:\\Server_PDV\\Historico_Log";
                                        controller.savePathPdvCad(pathPdv);
                                        pathPdvCadEC.text = pathPdv;
                                        controller.savePathTxt(pathTxt);
                                        pathTxtEC.text = pathTxt;
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("PATHS RESTAURADOS"), backgroundColor: Colors.green));
                                      },
                                      icon: const Icon(Icons.restore, color: ColorEx.primary))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    AnimatedBuilder(
                        animation: context.read<ContadorImpressao>(),
                        builder: (BuildContext value, _) {
                          return InkWell(
                            onTap: () => context.read<ContadorImpressao>().somarImpressao(),
                            child: Container(
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200,
                              ),
                              child: Center(
                                  child:
                                      Text("Contagem de impressoes: ${context.read<ContadorImpressao>().contagem} ")),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
