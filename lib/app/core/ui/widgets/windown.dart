// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:concentrador_delpim/app/repositories/etiqueta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'package:concentrador_delpim/app/core/ui/extensions/color_ex.dart';

class Windown extends StatefulWidget {
  final void Function()? onPressed;
  final IconData icon;
  final Widget child;

  const Windown({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.child,
  }) : super(key: key);

  @override
  State<Windown> createState() => _WindownState();
}

class _WindownState extends State<Windown> {
  @override
  Widget build(BuildContext context) {
    final isMaxmized = context.watch<EtiquetaRepository>();

    final windowManager = WindowManager.instance;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DragToMoveArea(
            child: SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    SvgPicture.asset(
                      "assets/images/g8.svg",
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          iconSize: 20,
                          splashRadius: 20,
                          onPressed: () {
                            windowManager.minimize();
                          },
                          icon: const Icon(
                            Icons.minimize,
                            color: ColorEx.primaryLight,
                          ),
                        ),
                        IconButton(
                          iconSize: 20,
                          splashRadius: 20,
                          onPressed: () {
                            windowManager.close();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: ColorEx.primaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: widget.child,
          )),
          const SizedBox(height: 15),
          Row(
            children: [
              Visibility(
                visible: !isMaxmized.isMaximized,
                child: IconButton(
                    iconSize: 25,
                    splashRadius: 25,
                    onPressed: () {
                      windowManager.maximize();
                      isMaxmized.maximize();
                    },
                    icon: const Icon(
                      Icons.zoom_out_map_outlined,
                      color: ColorEx.primaryLight,
                    )),
              ),
              const SizedBox(width: 5),
              Visibility(
                visible: isMaxmized.isMaximized,
                child: IconButton(
                    iconSize: 20,
                    splashRadius: 20,
                    onPressed: () {
                      windowManager.restore();
                      isMaxmized.maximize();
                    },
                    icon: const Icon(
                      Icons.zoom_in_map_outlined,
                      color: ColorEx.primaryLight,
                    )),
              ),
              const Expanded(child: SizedBox()),
              const Text(
                "V. 1.0",
                style: TextStyle(fontSize: 12),
              ),
              IconButton(
                  iconSize: 25,
                  splashRadius: 25,
                  onPressed: widget.onPressed,
                  icon: Icon(
                    widget.icon,
                    color: ColorEx.primaryLight,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
