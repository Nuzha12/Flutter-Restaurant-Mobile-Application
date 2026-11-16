import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final String                    label;
  final String?                   hint;
  final String?                   helperText;
  final TextEditingController?    controller;
  final String? Function(String?)? validator;
  final bool                      isPassword;
  final TextInputType             keyboardType;
  final IconData?                 prefixIcon;
  final Widget?                   suffix;
  final Widget?                   prefix;
  final bool                      readOnly;
  final VoidCallback?             onTap;
  final void Function(String)?    onChanged;
  final void Function(String)?    onSubmitted;
  final int                       maxLines;
  final int?                      maxLength;
  final TextInputAction           textInputAction;
  final List<TextInputFormatter>  inputFormatters;
  final bool                      autofocus;
  final FocusNode?                focusNode;
  final String?                   initialValue;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.isPassword       = false,
    this.keyboardType     = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.prefix,
    this.readOnly         = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.maxLines         = 1,
    this.maxLength,
    this.textInputAction  = TextInputAction.next,
    this.inputFormatters  = const [],
    this.autofocus        = false,
    this.focusNode,
    this.initialValue,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:        widget.controller,
      initialValue:      widget.initialValue,
      validator:         widget.validator,
      obscureText:       widget.isPassword && _obscure,
      keyboardType:      widget.keyboardType,
      readOnly:          widget.readOnly,
      onTap:             widget.onTap,
      onChanged:         widget.onChanged,
      onFieldSubmitted:  widget.onSubmitted,
      maxLines:          widget.isPassword ? 1 : widget.maxLines,
      maxLength:         widget.maxLength,
      textInputAction:   widget.textInputAction,
      inputFormatters:   widget.inputFormatters,
      autofocus:         widget.autofocus,
      focusNode:         widget.focusNode,
      style:             AppTextStyles.bodyMedium,
      cursorColor:       AppColors.primary,
      decoration: InputDecoration(
        labelText:   widget.label,
        hintText:    widget.hint,
        helperText:  widget.helperText,
        helperStyle: AppTextStyles.caption,
        prefixIcon:  widget.prefixIcon != null
            ? Icon(widget.prefixIcon, size: 20, color: AppColors.textHint)
            : widget.prefix,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 20, color: AppColors.textHint,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : widget.suffix,
        counterText: '',
      ),
    );
  }
}