import 'package:concentrador_delpim/app/core/controller/controller_produtos.dart';
import 'package:concentrador_delpim/app/core/controller/controller_contagem_impressoes.dart';
import 'package:concentrador_delpim/app/core/controller/controller_websocket.dart';
import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/button_header.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/container_eleveted.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/d_text_form_fild.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/windown.dart';
import 'package:concentrador_delpim/app/modules/caminho_server/controller_caminho_server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaminhoServerPage extends StatelessWidget {
  const CaminhoServerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ControllerCaminhoServer controller = ControllerCaminhoServer(
        controllerProdutos: context.read<ControllerProdutos>(),
        controllerWebSocket: context.read<ControllerWebSocket>());
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: DTextFormFild(
                                    controller: controller.pathHistoricoLogEC,
                                    label: const Text("PATH HISTORICO_LOG"),
                                  )),
                              const SizedBox(width: 50),
                              Expanded(
                                  flex: 3,
                                  child: DTextFormFild(
                                      controller: controller.pathPdvCadEC, label: const Text("PATH PDV_CAD"))),
                              Expanded(
                                  flex: 0,
                                  child: IconButton(
                                      tooltip: "Salvar",
                                      onPressed: () {
                                        controller.salvarPaths();
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("SALVO COM SUCESSO!"), backgroundColor: Colors.green));
                                      },
                                      icon: const Icon(Icons.save, color: ColorEx.primary))),
                              Expanded(
                                  flex: 0,
                                  child: IconButton(
                                      tooltip: "Restaurar Paths",
                                      onPressed: () {
                                        controller.restaurarPaths();
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("PATHS RESTAURADOS"), backgroundColor: Colors.green));
                                      },
                                      icon: const Icon(Icons.restore, color: ColorEx.primary))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.39,
                              child: TextFormField(
                                controller: controller.cnpjClienteEC,
                                decoration: const InputDecoration(labelText: "CNPJ DO CLIENTE"),
                              ))
                        ],
                      ),
                    ),
                    const Divider(),
                    AnimatedBuilder(
                        animation: context.read<ContadorImpressao>(),
                        builder: (BuildContext value, _) {
                          return Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: Center(
                                child: Text("Contagem de impressoes: ${context.read<ContadorImpressao>().contagem} ")),
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
