import 'package:concentrador_delpim/app/models/produto.dart';
import 'package:dio/dio.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ControllerProdutos {
  Future<List<Produto>?> buscarPordutos(String nomeProduto) async {
    List<Produto> produtos = [];
    final String pathDir = await getPathPdvCad("pdvCad");
    final sqliteDir = Directory('$pathDir/');
    final dbFile = File(path.join(sqliteDir.path, 'pdv_cad.s3db'));

    final db = sqlite3.open(dbFile.path);

    final ResultSet rows = db.select(
      'SELECT * FROM produtos WHERE sDescricao LIKE ? OR sCodBarras LIKE ?',
      ['%${nomeProduto.toUpperCase()}%', '%${nomeProduto.toUpperCase()}%'],
    );

    for (final Row row in rows) {
      Produto produto = Produto(
        bAtivo: row["bAtivo"] ?? 1,
        sCodBarras: row["sCodBarras"] ?? 0,
        sDescricao: row["sDescricao"] ?? "",
        rPreco_Venda1: row["rPreco_Venda1"] ?? 0,
        rPreco_Venda2: row["rPreco_Venda2"] ?? 0,
        rPreco_Venda3: row["rPreco_Venda3"] ?? 0,
        rPreco_Promo: row["rPreco_Promo"] ?? 0,
        sUndMedida: row["sUndMedida"] ?? "",
        iTopoPromo: row["iTopoPromo"] ?? 0,
      );
      produtos.add(produto);
    }

    if (produtos.isNotEmpty) {
      return produtos;
    }
    db.dispose();
    return null;
  }

  Future<void> savePathTxt(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("txt", value);
  }

  Future<void> savePathPdvCad(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("pdvCad", value);
  }

  Future<String> getPathPdvCad(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("pdvCad") ?? "C:\\Server_PDV\\enviar\\tabela";
  }

  Future<String> getPathTxt(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("txt") ?? "C:\\Server_PDV\\Historico_Log";
  }

  void observableTxt() {
    final dio = Dio();
    final String pathDir = getPathPdvCad("txt").toString();
    final dir = Directory(path.join('$pathDir/'));
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
}
