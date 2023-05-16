import 'package:concentrador_delpim/app/modules/home/submodules/imprimir_quantidade/imprimir_quantidade_page.dart';
import 'package:concentrador_delpim/app/core/ui/ui_config.dart';
import 'package:concentrador_delpim/app/modules/etiquetas/submodules/adicionar_etiqueta/adicionar_etiqueta_page.dart';
import 'package:concentrador_delpim/app/modules/caminho_server/caminho_server_page.dart';
import 'package:concentrador_delpim/app/modules/etiquetas/etiquetas_page.dart';
import 'package:concentrador_delpim/app/modules/home/home_page.dart';
import 'package:concentrador_delpim/app/core/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: Providers.providers,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: UiConfig.theme,
          initialRoute: "home",
          routes: {
            "home": (context) => const HomePage(),
            "imprimir": (context) => const ImprimirQuantidadePage(),
            "etiquetas": (context) => const EtiquetasPage(),
            "addEtiqueta": (context) => const AdicionarEtiquetaPage(),
            "caminhoServer": (context) => const CaminhoServerPage(),
          },
        ));
  }
}
