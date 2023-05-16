// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:concentrador_delpim/app/models/produto.dart';
import 'package:concentrador_delpim/app/models/modelo_impressao.dart';
import 'package:concentrador_delpim/app/repositories/etiqueta_repository.dart';
import 'package:concentrador_delpim/app/repositories/printer_repository.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:intl/intl.dart';
import '../../models/impressora.dart';

class ControllerImpressao extends ChangeNotifier {
  List<Impressora> _printers = [];
  int _indexSelectedPrinter = -1;
  Impressora? _printer;
  final EtiquetaRepository etiquetaRepository;

  final PrinterRepository printerRepository;
  ControllerImpressao(this.printerRepository, this.etiquetaRepository) {
    _init();
  }

  _init() {
    scanPrinters().then((value) {
      printers = value;
      getLastUsedPrinter().then((value) {
        setSelectedPrinter(value);
      });
    });
  }

  List<Impressora> get printers => _printers;
  Impressora? get printer => _printer;

  set printers(List<Impressora> value) {
    _printers = value;
    notifyListeners();
  }

  bool get hasSelectedPrinter => _indexSelectedPrinter >= 0;
  Impressora? get selectedPrinter => hasSelectedPrinter ? _printers[_indexSelectedPrinter] : null;

  setSelectedPrinter(Impressora? value) {
    if (value == null) {
      _indexSelectedPrinter = -1;
    } else {
      _indexSelectedPrinter = _printers.indexWhere((printer) => printer.deviceName == value.deviceName);
      saveLastUsedPrinter(value);
      _printer = value;
    }
    notifyListeners();
  }

  Future<void> imprimirEtiqueta({required String text}) async {
    List<int> bytes = [];
    Impressora? selectedPrinter;

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text('$text\n');
    selectedPrinter = _printer;
    if (selectedPrinter == null) return;
    var printerManager = PrinterManager.instance;
    var printer = selectedPrinter;
    bytes += generator.feed(2);
    bytes += generator.cut();
    await printerManager.connect(
      type: printer.typePrinter,
      model: UsbPrinterInput(
        name: printer.deviceName,
        productId: printer.productId,
        vendorId: printer.vendorId,
      ),
    );
    printerManager.send(type: printer.typePrinter, bytes: bytes);
  }

  String formatarText({required String text, required Produto produto}) {
    final formatadorPreco = NumberFormat("#,##0.00", "pt_BR");
    text = text.replaceAll('#sCodBarras#', produto.sCodBarras);
    text = text.replaceAll('#sDescricao#', produto.sDescricao);
    text = text.replaceAll('#bAtivo#', '${produto.bAtivo}');
    text = text.replaceAll('#iTopoPromo#', '${produto.iTopoPromo}');
    text = text.replaceAll('#rPreco_Promo#', formatadorPreco.format(produto.rPreco_Promo));
    text = text.replaceAll('#rPreco_Venda1#', formatadorPreco.format(produto.rPreco_Venda1));
    text = text.replaceAll('#rPreco_Venda2#', formatadorPreco.format(produto.rPreco_Venda2));
    text = text.replaceAll('#rPreco_Venda3#', formatadorPreco.format(produto.rPreco_Venda3));
    text = text.replaceAll('#sUndMedida#', '${produto.sUndMedida}');

    return text;
  }

  Future<List<Impressora>> scanPrinters({
    PrinterType defaultPrinterType = PrinterType.usb,
    bool isBle = false,
  }) async {
    final printerManager = PrinterManager.instance;
    final discoveredDevices = <Impressora>[];
    final completer = Completer<List<Impressora>>();
    StreamSubscription<PrinterDevice> subscription;

    subscription = printerManager
        .discovery(
      type: defaultPrinterType,
      isBle: isBle,
    )
        .listen((device) {
      discoveredDevices.add(Impressora(
        deviceName: device.name,
        address: device.address,
        isBle: isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
    }, onDone: () => completer.complete(discoveredDevices));

    final devices = await completer.future;
    subscription.cancel();

    return devices;
  }

  Future<Impressora?> getLastUsedPrinter() async {
    final printer = await printerRepository.get();
    return printer;
  }

  saveLastUsedPrinter(Impressora value) {
    printerRepository.save(value);
  }

  connectPrinter({required Impressora selectedPrinter}) async {
    var printerManager = PrinterManager.instance;
    printerManager.disconnect(type: selectedPrinter.typePrinter);
    await Future.delayed(const Duration(microseconds: 500));
    printerManager.connect(
        type: selectedPrinter.typePrinter,
        model: UsbPrinterInput(
            name: selectedPrinter.deviceName,
            productId: selectedPrinter.productId,
            vendorId: selectedPrinter.vendorId));
  }

  desconnectPrinter({required Impressora selectedPrinter}) {
    var printerManager = PrinterManager.instance;
    printerManager.disconnect(type: selectedPrinter.typePrinter);
  }

  imprimir({required String text, Produto? produto}) {
    if (produto != null) {
      text = etiquetaRepository.etiquetaSelecionada!.script;
      final resutlText = formatarText(text: text, produto: produto);
      imprimirEtiqueta(text: resutlText);
    } else {
      imprimirEtiqueta(text: text);
    }
  }

  imprimirLista({required List<ModeloImpressao> produtos}) {
    if (etiquetaRepository.etiquetaSelecionada != null) {
      for (var produto in produtos) {
        for (var i = 0; i < produto.qtd; i++) {
          imprimir(text: etiquetaRepository.etiquetaSelecionada!.script, produto: produto.produto);
        }
      }
    }
  }

  bool checkNumeroCharacters(String text) {
    final numericCharacters = text.replaceAll(RegExp(r'[^0-9]'), '');
    final count = numericCharacters.length;
    if (count >= 7) {
      return true;
    }
    return false;
  }
}
