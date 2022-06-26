import 'package:flutter/material.dart';

class FixedHeightLinearProgressIndicator extends StatelessWidget {
  const FixedHeightLinearProgressIndicator({
    Key? key,
    required this.isShowing,
    this.height = 5.0,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  }) : super(key: key);

  final bool isShowing;
  final double height;

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    return isShowing
        ? LinearProgressIndicator(
            minHeight: height,
            value: value,
            backgroundColor: backgroundColor,
            color: color,
            valueColor: valueColor,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue,
          )
        : SizedBox(height: height);
  }
}
