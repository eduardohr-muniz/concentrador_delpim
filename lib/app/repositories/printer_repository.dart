import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/impressora.dart';

//Função de repositorie fazer o crud de uma lista de models
abstract class PrinterRepository {
  Future<Impressora?> get();
  Future<void> save(Impressora printer);
}

class PrinterRepositorySharedPreferences extends PrinterRepository {
  static const String _keyPrinter = 'selectedPrinter';
  @override
  Future<Impressora?> get() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyPrinter);
    if (jsonString != null) {
      return Impressora.fromJson(jsonDecode(jsonString));
    } else {
      return null;
    }
  }

  @override
  Future<void> save(Impressora printer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPrinter, jsonEncode(printer.toJson()));
  }
}

class PrinterRepositoryCloud extends PrinterRepository {
  @override
  Future<Impressora?> get() async {
    //Faz de conta que estamos buscand de uma api
    return null;
  }

  @override
  Future<void> save(Impressora printer) async {
    //Faz de conta que estamos salvando de uma api
  }
}
