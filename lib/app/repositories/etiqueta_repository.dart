import 'dart:convert';

import 'package:concentrador_delpim/app/models/etiqueta.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EtiquetaRepository with ChangeNotifier {
  EtiquetaRepository() {
    init();
  }

  List<Etiqueta>? _etiquetas;
  Etiqueta? _etiquetaSelecionada;
  bool isMaximized = false;

  Etiqueta? get etiquetaSelecionada => _etiquetaSelecionada;
  List<Etiqueta>? get etiquetas => _etiquetas;

  init() async {
    _etiquetas = await getEtiquetas();
    try {
      _etiquetaSelecionada = await getEtiquetaSelecionada();
    } on Exception catch (e) {
      return Text("$e");
    }
    notifyListeners();
    if (_etiquetas!.isEmpty) {
      criarEtiquetasPadrao();
    }
  }

  void maximize() {
    isMaximized = !isMaximized;
    notifyListeners();
  }

  Future<void> editarScript(Etiqueta etiqueta, String script) async {
    etiqueta.script = script;
    saveEtiquetas(_etiquetas!, null);
    notifyListeners();
  }

  Future<void> removeEtiqueta(Etiqueta value) async {
    _etiquetas!.remove(value);
    saveEtiquetas(_etiquetas!, null);
  }

  // função para pegar a Etiqueta Selecionada SharedPreferences
  Future<Etiqueta?> getEtiquetaSelecionada() async {
    final prefs = await SharedPreferences.getInstance();
    String? prefsEtiqueta = prefs.getString("etiquetaSelecionada");
    if (prefsEtiqueta != null && _etiquetas!.isNotEmpty) {
      Etiqueta result = Etiqueta.fromJson(jsonDecode(prefsEtiqueta));
      return _etiquetas?.firstWhere((element) => element.id == result.id); //& first where
    } else {
      return null;
    }
  }

  // função para salvar a Etiqueta Selecionada SharedPreferences
  Future<void> saveEtiquetaSelecionada(Etiqueta etiqueta) async {
    final prefs = await SharedPreferences.getInstance();
    String etiquetaJson = jsonEncode(etiqueta);
    await prefs.setString("etiquetaSelecionada", etiquetaJson);
    _etiquetaSelecionada = etiqueta;
    notifyListeners();
  }

  // função para recuperar a lista de etiquetas do SharedPreferences
  Future<List<Etiqueta>> getEtiquetas() async {
    final prefs = await SharedPreferences.getInstance();
    String? etiquetasJson = prefs.getString('etiquetas');
    List<Map<String, dynamic>>? etiquetasMapList =
        etiquetasJson != null ? List<Map<String, dynamic>>.from(json.decode(etiquetasJson)) : null;
    List<Etiqueta> etiquetas =
        etiquetasMapList != null ? etiquetasMapList.map((etiquetaMap) => Etiqueta.fromMap(etiquetaMap)).toList() : [];
    return etiquetas;
  }

// função para salvar a lista de etiquetas no SharedPreferences
  Future<void> saveEtiquetas(List<Etiqueta> etiquetas, Etiqueta? newEtiqueta) async {
    final prefs = await SharedPreferences.getInstance();
    if (newEtiqueta != null) {
      int? id = prefs.getInt("id") ?? 4;
      newEtiqueta.id = id++;
      await prefs.setInt("id", id++);
      etiquetas.add(newEtiqueta);
    }
    List<Map<String, dynamic>> etiquetasMapList = etiquetas.map((etiqueta) => etiqueta.toMap()).toList();
    String etiquetasJson = json.encode(etiquetasMapList);
    await prefs.setString('etiquetas', etiquetasJson);
    init();
  }

  criarEtiquetasPadrao() {
    List<Etiqueta> etiquetasPadrao = [];
    var argoxPplb = Etiqueta(id: 1, descricao: "ARGOX PPLB", script: """I8,A
ZN
q853
O
JF
ZT
Q240,25
N
A829,214,2,1,3,3,N,"#sDescricao#"
A735,115,2,4,3,3,N,"#rPreco_Venda1#"
A813,102,2,4,2,2,N,"R\$"
B422,128,2,1,3,6,49,N,"#sCodBarras#"
A357,73,2,3,2,2,N,"#sCodBarras#"
P1""");
    var zebra = Etiqueta(id: 2, descricao: "ZEBRA", script: """N
Y96,N,8,1
Q240,8
S2
D10
A40,24,0,4,1,3,N,"#sDescricao#"
B560,104,0,E30,2,6,80,B,"#CodBarras#"
A160,104,0,5,1,2,N,"#rPreco_Venda1#"
A48,144,0,5,1,1,N,"R\$"
P1""");
    var argoxPpla = Etiqueta(id: 3, descricao: "ARGOX PPLA", script: """m
e
O0559
M1200
L
H10
z
191100400300050R\$
191100700100200#rPreco_Venda1#
1F1107000300720#sCodBarras#
191200101650020#sDescricao#
Q0001
E""");

    etiquetasPadrao.add(argoxPplb);
    etiquetasPadrao.add(zebra);
    etiquetasPadrao.add(argoxPpla);
    saveEtiquetas(etiquetasPadrao, null);
    notifyListeners();
  }
}
