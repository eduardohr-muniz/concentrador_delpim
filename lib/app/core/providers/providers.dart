import 'package:concentrador_delpim/app/core/controller/controller_bloqueio.dart';
import 'package:concentrador_delpim/app/core/controller/controller_impressao.dart';
import 'package:concentrador_delpim/app/core/controller/controller_produtos.dart';
import 'package:concentrador_delpim/app/core/controller/controller_websocket.dart';
import 'package:concentrador_delpim/app/repositories/etiqueta_repository.dart';
import 'package:concentrador_delpim/app/repositories/printer_repository.dart';
import 'package:concentrador_delpim/app/core/controller/controller_contagem_impressoes.dart';
import 'package:provider/provider.dart';

class Providers {
  static final providers = [
    ChangeNotifierProvider<ControllerWebSocket>(
        create: (context) => ControllerWebSocket(controllerBloqueio: ControllerBloqueio()), lazy: false),
    Provider(create: (context) => ControllerProdutos()),
    ChangeNotifierProvider<EtiquetaRepository>(create: (context) => EtiquetaRepository()),
    ChangeNotifierProvider<ContadorImpressao>(create: (context) => ContadorImpressao()),
    ChangeNotifierProvider<ControllerImpressao>(
        create: (context) =>
            ControllerImpressao(PrinterRepositorySharedPreferences(), context.read<EtiquetaRepository>())),
  ];
}
