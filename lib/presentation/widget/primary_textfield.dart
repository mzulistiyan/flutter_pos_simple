import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/common.dart';

class PrimaryTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final bool obscureText;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final Color? borderColor;
  final Function(String)? onChanged;
  final String? initialValue;
  final dynamic validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool? readOnly;
  const PrimaryTextField({
    Key? key,
    this.textEditingController,
    this.obscureText = false,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.fillColor,
    this.borderColor,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.readOnly = false,
    this.suffixIcon = false,
    this.isDense,
  }) : super(key: key);

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: widget.borderColor ?? Color(0xffD6E4EC),
        ),
      ),
      child: TextFormField(
        controller: widget.textEditingController,
        obscureText: (widget.obscureText && _obscureText),
        keyboardType: widget.keyboardType ?? TextInputType.text,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        initialValue: widget.initialValue,
        validator: widget.validator,
        readOnly: widget.readOnly!,
        style: FontsGlobal.mediumTextStyle14.copyWith(
          color: widget.readOnly == false ? Colors.black : const Color(0xFFB4B2AF),
        ),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.remove_red_eye : Icons.visibility_off_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          suffixIconConstraints: (widget.isDense != null) ? const BoxConstraints(maxHeight: 33) : null,
          // filled: true,
          hintText: widget.hintText ?? '',
          hintStyle: widget.hintStyle ?? FontsGlobal.mediumTextStyle14.copyWith(color: Colors.black54),
          prefixIcon: widget.prefixIcon,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
