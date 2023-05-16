import 'dart:async';
import 'package:concentrador_delpim/app/core/controller/controller_impressao.dart';
import 'package:concentrador_delpim/app/core/controller/controller_produtos.dart';
import 'package:concentrador_delpim/app/core/controller/controller_contagem_impressoes.dart';
import 'package:concentrador_delpim/app/models/produto.dart';
import 'package:concentrador_delpim/app/models/modelo_impressao.dart';
import 'package:concentrador_delpim/app/modules/home/widgets/drop_etiqueta.dart';
import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';
import 'package:concentrador_delpim/app/core/ui/extensions/theme_ex.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/my_list_title_model.dart';
import 'package:concentrador_delpim/app/core/ui/widgets/windown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/controller/controller_web_hook.dart';

class ImprimirQuantidadePage extends StatefulWidget {
  const ImprimirQuantidadePage({super.key});

  @override
  State<ImprimirQuantidadePage> createState() => _ImprimirQuantidadePageState();
}

class _ImprimirQuantidadePageState extends State<ImprimirQuantidadePage> {
  final produtosController = ControllerProdutos();
  final serviceController = ServiceController();
  List<ModeloImpressao> produtosLista = [];
  final searchProdutoEC = TextEditingController();
  final searchProdutoFC = FocusNode();
  Timer? searchTimer;
  List<Produto> produtos = [];

  snackBProdutoErro() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Produto não encontrado"),
      backgroundColor: Colors.amber,
    ));
  }

  void adicionarProdutoALista(Produto produto) {
    ModeloImpressao novoProduto = ModeloImpressao(produto: produto, qtd: 1);
    produtosLista.add(novoProduto);
    setState(() {
      searchProdutoEC.text = "";
      produtos.clear();
    });
  }

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
  void initState() {
    super.initState();
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
        icon: Icons.arrow_back,
        onPressed: () => Navigator.of(context).pop(),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [DropEtiqueta(), Expanded(flex: 10, child: SizedBox())]),
            ),
            const Divider(),
            Container(
              height: MediaQuery.of(context).size.height * 0.69,
              decoration: BoxDecoration(
                  color: context.secondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))
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
                            produtos.clear;
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
                          await Future.delayed(const Duration(seconds: 1), () {
                            adicionarProdutoALista(produtos.first);
                          });
                          setState(() {
                            searchProdutoEC.text = "";
                            produtos.clear();
                            searchProdutoFC.requestFocus();
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
                    produtosLista.isNotEmpty
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                produtosLista.clear();
                              });
                            },
                            child: const Row(children: [Text("Limpar lista"), Icon(Icons.delete_outline)]))
                        : const SizedBox.square(),
                  ]),
                  const SizedBox(height: 8),
                  const Divider(),
                  searchProdutoEC.text.isNotEmpty && produtos.isNotEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: produtos.length,
                              itemBuilder: (context, index) {
                                final produto = produtos[index];
                                return Column(children: [
                                  MyListTitleModel(
                                    onTap: () async {
                                      adicionarProdutoALista(produto);
                                    },
                                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(produto.sCodBarras),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(produto.sDescricao),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text("R\$ ${produto.rPreco_Venda1.toString()}"),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                adicionarProdutoALista(produto);
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: ColorEx.primary,
                                              )),
                                        ],
                                      ),
                                    ]),
                                  ),
                                ]);
                              }),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: produtosLista.length,
                              itemBuilder: (context, index) {
                                final produto = produtosLista[index];
                                return Column(children: [
                                  MyListTitleModel(
                                    onTap: () async {
                                      setState(() {
                                        searchProdutoEC.text = "";
                                        Future.delayed(const Duration(milliseconds: 300));
                                      });
                                    },
                                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(produto.produto.sDescricao),
                                      Row(children: [
                                        IconButton(
                                            onPressed: () {
                                              if (produto.qtd == 1) {
                                                produtosLista.remove(produto);
                                              } else {
                                                produto.qtd--;
                                              }
                                              setState(() {});
                                            },
                                            icon: const Icon(Icons.remove)),
                                        Text("${produto.qtd}"),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                produto.qtd++;
                                              });
                                            },
                                            icon: const Icon(Icons.add)),
                                      ]),
                                    ]),
                                  ),
                                ]);
                              }),
                        ),
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
