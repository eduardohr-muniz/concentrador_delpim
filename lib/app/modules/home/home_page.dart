import 'dart:async';
import 'package:concentrador_delpim/app/core/controller/controller_impressao.dart';
import 'package:concentrador_delpim/app/core/controller/controller_produtos.dart';
import 'package:concentrador_delpim/app/core/controller/controller_contagem_impressoes.dart';
import 'package:concentrador_delpim/app/models/produto.dart';
import 'package:concentrador_delpim/app/models/modelo_impressao.dart';
import 'package:concentrador_delpim/app/modules/home/widgets/dialog_password.dart';
import 'package:concentrador_delpim/app/modules/home/widgets/drop_etiqueta.dart';
import 'package:concentrador_delpim/app/core/ui/extensions/theme_ex.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/my_list_title_model.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/windown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/controller/controller_web_hook.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  snackBProdutoErro() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Produto não encontrado"),
      backgroundColor: Colors.amber,
    ));
  }

  final produtosController = ControllerProdutos();
  final serviceController = ServiceController();
  final searchProdutoFC = FocusNode();

  List<ModeloImpressao> produtosLista = [];
  final searchProdutoEC = TextEditingController();
  Timer? searchTimer;
  List<Produto> produtos = [];

  void startSearch() {
    searchTimer = Timer(const Duration(milliseconds: 300), () async {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (searchProdutoEC.text.characters.length >= 3) {
        produtos.clear();
        List<Produto>? result = await produtosController.buscarPordutos(searchProdutoEC.text);
        if (result != null) {
          setState(() {
            produtos.addAll(result);
          });
        } else if (searchProdutoEC.text.characters.length > 4) {
          snackBProdutoErro();
        }
      }
    });
  }

  void cancelSearchTimer() {
    searchTimer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    searchProdutoEC.dispose();
    searchProdutoFC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Windown(
        icon: Icons.construction_outlined,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const DialogPassword(),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                DropEtiqueta(),
                Expanded(
                  flex: 10,
                  child: SizedBox(),
                )
              ]),
            ),
            const Divider(),
            Container(
              height: MediaQuery.of(context).size.height * 0.69,
              decoration: BoxDecoration(
                  color: context.secondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: searchProdutoFC,
                        onChanged: (value) async {
                          if (searchProdutoEC.text.characters.length >= 3) {
                            produtos.clear();
                            cancelSearchTimer();
                            startSearch();
                          }
                          if (searchProdutoEC.text.characters.isEmpty) {
                            setState(() {
                              produtos.clear();
                              searchProdutoEC.text = "";
                            });
                          }
                        },
                        onFieldSubmitted: (_) async {
                          Future.delayed(const Duration(seconds: 1), () async {
                            context.read<ContadorImpressao>().somarImpressao();
                            await context.read<ControllerImpressao>().imprimir(text: "", produto: produtos.first);
                            setState(() {
                              searchProdutoEC.text = "";
                              produtos.clear();
                              searchProdutoFC.requestFocus();
                            });
                          });
                        },
                        autofocus: true,
                        controller: searchProdutoEC,
                        decoration: const InputDecoration(
                          labelText: "CODIGO PRODUTO",
                          hintText: "REALIZE A LEITURA DO CODIGO ||",
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("imprimir");
                      },
                      child: const Row(
                        children: [Text("IMPRIMIR MULTIPLOS"), Icon(Icons.add_shopping_cart)],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const Divider(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: produtos.length,
                        itemBuilder: (context, index) {
                          final produto = produtos[index];
                          return Column(children: [
                            MyListTitleModel(
                              onTap: () async {
                                context.read<ContadorImpressao>().somarImpressao();
                                await context.read<ControllerImpressao>().imprimir(text: "", produto: produto);
                                setState(() {
                                  searchProdutoEC.text = "";
                                  produtos.clear();
                                });
                              },
                              title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(produto.sCodBarras),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Text(produto.sDescricao),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("R\$ ${produto.rPreco_Venda1.toString()}"),
                                ),
                              ]),
                            ),
                          ]);
                        }),
                  )
                ]),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: produtosLista.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: FloatingActionButton(
                  onPressed: () async {
                    context.read<ContadorImpressao>().somarImpressao();
                    await context.read<ControllerImpressao>().imprimirLista(produtos: produtosLista);
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        produtosLista.clear();
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${produtosLista.length}"),
                      const Icon(Icons.print),
                    ],
                  )),
            )
          : null,
    );
  }
}
