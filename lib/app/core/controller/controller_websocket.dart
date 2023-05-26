import 'dart:async';
import 'package:concentrador_delpim/app/core/controller/messages.dart';
import 'package:concentrador_delpim/app/models/solicitacao.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class ControllerWebSocket {
  BuildContext context;
  ControllerWebSocket({required this.context});

  late IOWebSocketChannel channel;
  String slugPadrao = "Insira o cnpj do cliente";
  String ipPort = "";

  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

  Future<void> addSlug(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("slug", value);
  }

  Future<String> getSlug() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('slug') ?? slugPadrao;
  }

  Future<String> getIpPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ipPort') ?? "144.91.88.240:1769";
  }

  Future<void> addIpPort(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("IpPort", value);
  }

  void init(String slug) {
    initConnection(slug);
    broadcastNotifications(slug);
  }

  Future initConnection(String slug) async {
    // print("--------initConnection---------");
    if (slug != slugPadrao) {
      ipPort = await getIpPort();
      channel = IOWebSocketChannel.connect("ws://$ipPort", pingInterval: const Duration(seconds: 5));
      Future.delayed(const Duration(seconds: 1), () {
        // print("--------ENVIANDO ID---------");
        channel.sink.add('{"idSave": "$slug"}');
        broadcastNotifications(slug);
        var conectado = channel.innerWebSocket;
        conectado != null ? Messages.of(context).showSucess("CONECTADO COM SUCESSO") : null;
      });
    }
  }

  Future broadcastNotifications(String slug) async {
    channel.stream.listen(
      (event) async {
        var solicitacao = Solicitacao.fromJson(event);
        if (solicitacao.bloquear == true) {
          //TODO Implementar logica de bloqueio
        } else {
          //TODO Implementar Logica de Desbloqueio
        }
      },
      onError: (_) async {
        // print("onError");
        //Uma mensagem com erro
        Messages.of(context).showError("INTERNET INSTÁVEL TENTANDO RECONECTAR ⚠️");
        _retryConnectio(slug);
      },
      onDone: () async {
        // print("onDone");
        Messages.of(context).showError("INTERNET INSTÁVEL TENTANDO RECONECTAR ⚠️");
        //Quando fecha a conexão
        _retryConnectio(slug);
      },
      cancelOnError: true,
    );
  }

  Future _retryConnectio(String slug) async {
    // print("retry");
    await Future.delayed(const Duration(seconds: 5));
    await initConnection(slug);
    await broadcastNotifications(slug);
  }

  void showSnackb(String mensagem, BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
        ),
      );
    });
  }
}
