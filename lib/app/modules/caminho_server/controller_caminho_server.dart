// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:concentrador_delpim/app/core/controller/controller_produtos.dart';
import 'package:concentrador_delpim/app/core/controller/controller_websocket.dart';

class ControllerCaminhoServer {
  ControllerWebSocket controllerWebSocket;
  ControllerProdutos controllerProdutos;
  ControllerCaminhoServer({
    required this.controllerWebSocket,
    required this.controllerProdutos,
  }) {
    init();
  }

  final pathHistoricoLogEC = TextEditingController();
  final pathPdvCadEC = TextEditingController();
  final cnpjClienteEC = TextEditingController();

  Future<void> init() async {
    pathHistoricoLogEC.text = await controllerProdutos.getPathTxt("txt");
    pathPdvCadEC.text = await controllerProdutos.getPathPdvCad("pdvCad");
    cnpjClienteEC.text = await controllerWebSocket.getSlug();
  }

  restaurarPaths() {
    String pathPdv = "C:\\Server_PDV\\enviar\\tabela";
    String pathTxt = "C:\\Server_PDV\\Historico_Log";
    controllerProdutos.savePathPdvCad(pathPdv);
    pathPdvCadEC.text = pathPdv;
    controllerProdutos.savePathTxt(pathTxt);
    pathHistoricoLogEC.text = pathTxt;
  }

  salvarPaths() {
    controllerProdutos.savePathPdvCad(pathPdvCadEC.text);
    controllerProdutos.savePathTxt(pathHistoricoLogEC.text);
    controllerWebSocket.addSlug(cnpjClienteEC.text);
  }
}
