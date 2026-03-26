import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/utils/color.dart';

class ProgressDialog extends StatelessWidget {
  final Widget? child;
  final bool? inAsyncCall;
  final double? opacity;
  final Color? color;
  final Animation<Color>? valueColor;

  const ProgressDialog({
    Key? key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.0,
    this.color = Colors.transparent,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child!);
    if (inAsyncCall!) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity!,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow:  const [
                  BoxShadow(
                    color: AppColor.colorGray,
                    spreadRadius: 0.1,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(30),
              height: 100,
              width: 100,
              child: const CircularProgressIndicator(
                color: AppColor.colorTheme,
              ),
            ),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
