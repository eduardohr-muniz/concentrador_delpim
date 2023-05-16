import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContadorImpressao extends ChangeNotifier {
  ContadorImpressao() {
    init();
  }
  int contagem = 0;

  init() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    contagem = shared.getInt("contadorImpressao") ?? 0;
    notifyListeners();
  }

  somarImpressao() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    contagem++;
    shared.setInt("contadorImpressao", contagem);
    notifyListeners();
  }
}
