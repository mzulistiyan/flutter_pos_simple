import 'package:flutter/material.dart';

import '../../../common/common.dart';

class PrimaryButton extends StatelessWidget {
  String? text;
  final Function()? onPressed;
  Color? color;
  Color? backgroundColor;
  Color? textColor;

  PrimaryButton({super.key, this.onPressed, this.text, this.color, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.safeBlockVertical * 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor ?? ColorConstant.primaryColor,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            text!,
            style: FontsGlobal.semiBoldTextStyle14.copyWith(
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
