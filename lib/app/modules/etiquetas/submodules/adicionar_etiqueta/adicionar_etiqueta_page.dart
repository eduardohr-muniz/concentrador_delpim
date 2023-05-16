import 'package:concentrador_delpim/app/core/controller/controller_impressao.dart';
import 'package:concentrador_delpim/app/core/controller/controller_contagem_impressoes.dart';
import 'package:concentrador_delpim/app/models/etiqueta.dart';
import 'package:concentrador_delpim/app/repositories/etiqueta_repository.dart';
import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/button_header.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/container_eleveted.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/d_text_form_fild.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/windown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdicionarEtiquetaPage extends StatefulWidget {
  const AdicionarEtiquetaPage({Key? key}) : super(key: key);

  @override
  State<AdicionarEtiquetaPage> createState() => _AdicionarEtiquetaPageState();
}

class _AdicionarEtiquetaPageState extends State<AdicionarEtiquetaPage> {
  final numeroEtiquetaEC = TextEditingController();
  final descricaoEtiquetaEC = TextEditingController();
  final scriptEtiquetaEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    numeroEtiquetaEC.dispose();
    descricaoEtiquetaEC.dispose();
    scriptEtiquetaEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void limpar() {
      numeroEtiquetaEC.text = "";
      descricaoEtiquetaEC.text = "";
      scriptEtiquetaEC.text = "";
    }

    return Scaffold(
      body: Windown(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.arrow_back_ios_new_outlined,
          child: Consumer<EtiquetaRepository>(
            builder: (_, etiqueta, __) {
              return Column(
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
                            text: "ETIQUETAS",
                            selected: true,
                            onTap: () => Navigator.of(context).pushNamed("etiquetas")),
                        // ButtonHeader(text: "XML", selected: false, onTap: () => Navigator.of(context).pushNamed("xml")),
                        ButtonHeader(
                            text: "CAMINHO SERVER",
                            selected: false,
                            onTap: () => Navigator.of(context).pushNamed("caminhoServer")),
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
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Tooltip(
                                  message: """
Tags:
#sCodBarras# = Codigo de Barras
#sDescricao# = Descrição Produto
#bAtivo# = Produto Ativo
#iTopoPromo# = Produto em promoção
#rPreco_Promo# = Preço de venda promoção
#rPreco_Venda1# = Preço de venda 1
#rPreco_Venda2# = Preço de venda 2
#rPreco_Venda3# =  Preço de venda 3
#sUndMedida# = Unidade de medida""",
                                  child: Icon(
                                    Icons.help_outline,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                      child: Center(child: Text("CADASTRO DE ETIQUETA"))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: DTextFormFild(
                                        controller: descricaoEtiquetaEC,
                                        label: const Text("DESCRIÇÃO"),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: scriptEtiquetaEC,
                              maxLines: null,
                              expands: true,
                              decoration: const InputDecoration(label: Text("SCRIPT")),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (scriptEtiquetaEC.text.isNotEmpty) {
                                      context.read<ContadorImpressao>().somarImpressao();
                                      context.read<ControllerImpressao>().imprimirEtiqueta(text: scriptEtiquetaEC.text);
                                    }
                                  },
                                  icon: const Icon(Icons.print_outlined, color: ColorEx.primary)),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Text("CANCELAR"),
                                  label: const Icon(Icons.close)),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    var navegacao = Navigator.of(context);
                                    Etiqueta newEtiqueta = Etiqueta(
                                        id: 0, descricao: descricaoEtiquetaEC.text, script: scriptEtiquetaEC.text);
                                    List<Etiqueta> etiquetas = await etiqueta.getEtiquetas();
                                    etiqueta.saveEtiquetas(etiquetas, newEtiqueta);
                                    limpar();
                                    navegacao.pop();
                                  },
                                  icon: const Text("SALVAR"),
                                  label: const Icon(Icons.save)),
                            ],
                          ),
                        )
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
