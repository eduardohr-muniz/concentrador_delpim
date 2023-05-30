import 'dart:async';
import 'package:concentrador_delpim/app/core/controller/controller_bloqueio.dart';
import 'package:concentrador_delpim/app/models/solicitacao.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class ControllerWebSocket extends ChangeNotifier {
  ControllerBloqueio controllerBloqueio;
  ControllerWebSocket({required this.controllerBloqueio}) {
    init();
  }
  late IOWebSocketChannel channel;
  String slugPadrao = "Insira o cnpj do cliente";
  String ipPort = "95.111.254.20:2323";
  bool? isConectado;

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

  // Future<String> getIpPort() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('ipPort') ?? "95.111.254.20:2323";
  // }

  Future<void> addIpPort(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("IpPort", value);
  }

  Future<void> init() async {
    String slug = await getSlug();
    if (slug != "") {
      initConnection(slug);
    }
    // broadcastNotifications(slug);
  }

  Future initConnection(String slug) async {
    // print("--------initConnection---------");

    if (slug != slugPadrao) {
      // ipPort = await getIpPort();
      channel = IOWebSocketChannel.connect("ws://$ipPort", pingInterval: const Duration(seconds: 5));
      Future.delayed(const Duration(seconds: 1), () {
        // print("--------ENVIANDO ID---------");
        channel.sink.add('{"slug": "$slug"}');
        broadcastNotifications(slug);
        var conectado = channel.innerWebSocket;
        conectado != null ? isConectado = true : null;
        notifyListeners();
        // Messages.of(context).showSucess("CONECTADO COM SUCESSO") : null;
      });
    }
  }

  Future broadcastNotifications(String slug) async {
    channel.stream.listen(
      (event) async {
        var solicitacao = Solicitacao.fromJson(event);
        if (solicitacao.bloquear == true) {
          controllerBloqueio.bloquear();
        } else {
          controllerBloqueio.desbloquear();
        }
      },
      onError: (_) async {
        // print("onError");
        //Uma mensagem com erro
        isConectado = false;
        _retryConnectio(slug);
        notifyListeners();
      },
      onDone: () async {
        // print("onDone");
        isConectado = false;
        //Quando fecha a conexão
        _retryConnectio(slug);
        notifyListeners();
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
