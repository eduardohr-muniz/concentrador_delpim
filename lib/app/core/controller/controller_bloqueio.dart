import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ControllerBloqueio {
  ControllerBloqueio() {
    init();
  }
  Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
  late Directory folderErpGestao;
  late List<String> pos;
  late List<String> mobilityPos;

  init() async {
    folderErpGestao = Directory(await getPreferencesString("erpGestao"));
    String posL = await getPreferencesString("pos");
    String mobilityPosL = await getPreferencesString("mobilityPos");
    pos.addAll(posL.split("|").toList());
    mobilityPos.addAll(mobilityPosL.split("|").toList());
  }

  Future<String> getPreferencesString(String key) async {
    var prefs = await sharedPreferences;
    return prefs.getString(key) ?? "";
  }

  Future<void> setPreferencesString(String key, String value) async {
    var prefs = await sharedPreferences;
    prefs.setString(key, value);
  }

  bloquear() {
    bool fileEG = File(path.join(folderErpGestao.path, "Erp_Gestao.exe")).existsSync();
    fileEG
        ? File(path.join(folderErpGestao.path, "Erp_Gestao.exe"))
            .rename(path.join(folderErpGestao.path, "bloqueado.exe"))
        : null;
    for (var pasta in pos) {
      var file = File(path.join(pasta, "POS.exe"));
      bool exist = file.existsSync();
      exist ? File(file.path).rename(path.join(pasta, "bloqueado.exe")) : null;
    }
    for (var pasta in mobilityPos) {
      var file = File(path.join(pasta, "Mobility_POS.exe"));
      bool exist = file.existsSync();
      exist ? File(file.path).rename(path.join(pasta, "bloqueado.exe")) : null;
    }
    debugPrint("------Bloqueado------");
  }

  desbloquear() {
    bool fileEG = File(path.join(folderErpGestao.path, "bloqueado.exe")).existsSync();
    fileEG
        ? File(path.join(folderErpGestao.path, "bloqueado.exe"))
            .rename(path.join(folderErpGestao.path, "Erp_Gestao.exe"))
        : null;
    for (var pasta in pos) {
      var file = File(path.join(pasta, "bloqueado.exe"));
      bool exist = file.existsSync();
      exist ? File(file.path).rename(path.join(pasta, "POS.exe")) : null;
    }
    for (var pasta in mobilityPos) {
      var file = File(path.join(pasta, "bloqueado.exe"));
      bool exist = file.existsSync();
      exist ? File(file.path).rename(path.join(pasta, "Mobility_POS.exe")) : null;
    }
    debugPrint("------Desbloqueado------");
  }
}
