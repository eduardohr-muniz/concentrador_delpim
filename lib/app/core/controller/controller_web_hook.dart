// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:path/path.dart' as path;

class ServiceController {}

void observableTxt() {
  final dio = Dio();
  var dir = Directory("/arquivos_txt/");
  var folder = dir;
  folder.watch().listen((event) async {
    List<FileSystemEntity> files = dir.listSync();
    var file = File(files.last.path);
    var ped = await file.readAsString();

    List<String> pedidos = ped.split('------------------------------------------------------');
    List<String> ultimoPedido = pedidos[pedidos.length - 3].split(',');

    await dio.post('https://webhook.site/6d367e2b-7b4a-4343-8a44-d1ebc20e5401', data: ultimoPedido);
  });
}
