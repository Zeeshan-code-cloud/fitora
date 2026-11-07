import 'package:fitoraa/features/export.dart';

class AppFormField extends StatelessWidget {
  final String title;
  final Widget? prefic_icons;
  final IconData? icon;
  final bool isObsecured;
  final VoidCallback? onTap;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final bool isMultiline;
  final bool readOnly;
  final bool isFilled;
  final int? wordCount,maxLength;
  final bool showBorder;
  final bool showPretixIcon ;
  final Color? focusedBorderColor,borderColor;
  final Color? filledColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Widget? iconWidget;
  final double? prefixIconheight;
  final double? preficIconwidth;
  final TextInputType keyboardType;
  int maxLines ;

  AppFormField({
    super.key,
    required this.title,
    this.prefic_icons,
    this.showPretixIcon = false,
    this.icon,
    this.isObsecured = false,
    this.readOnly = false,
    this.onTap,
    required this.textEditingController,
    this.validator,
    this.textInputType = TextInputType.text,
    this.isMultiline = false,
    this.wordCount,
    this.borderColor,
    this.maxLength,
    this.showBorder = false,
    this.focusedBorderColor,
    this.iconWidget,
    this.preficIconwidth,
    this.prefixIconheight,
    this.isFilled = false,
    this.filledColor = AppColors.darkTextSecondary,
    this.maxLines = 1,
    this.textColor = Colors.black12,
    this.hintTextColor = Colors.black,
    this.keyboardType = TextInputType.text,
  });

  String? _validateWordCount(String? value) {
    if (wordCount != null && value != null && value.trim().isNotEmpty) {
      final words = value.trim().split(RegExp(r'\s+'));
      if (words.length > wordCount!) {
        return 'Maximum $wordCount words allowed';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      style: TextStyle(
        color: textColor,
      ),
      keyboardType: isMultiline ? TextInputType.multiline : textInputType,
      validator: (value) {
        final baseValidation = validator?.call(value);
        final wordLimitValidation = _validateWordCount(value);
        return baseValidation ?? wordLimitValidation;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: readOnly,
      maxLength: maxLength,
      controller: textEditingController,
      obscureText: isObsecured,
      maxLines: isMultiline ? maxLines : 1,

      decoration: InputDecoration(

        filled: isFilled,
        fillColor: filledColor,
         prefixIcon: showPretixIcon? SizedBox(
          height: prefixIconheight,
          width: preficIconwidth,
          child:  Center(child: prefic_icons),
        ) : null,
         hintText: title,
        hintStyle: TextStyle(
          color: hintTextColor,
          fontSize: 14,),
         border: showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.shade400,
            width: 1,
          ),
        )
            : InputBorder.none,

        enabledBorder: showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.shade400,
            width: 1,
          ),
        )
            : InputBorder.none,

        focusedBorder: showBorder
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.primary,
            width: 1.2,
          ),
        )
            : InputBorder.none,

        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: onTap,
            child: iconWidget ??
                Icon(
                  icon,
                  size: 28, // your desired size
                  color: Colors.redAccent,
                ),
          ),
        ),

        suffixIconConstraints: const BoxConstraints(
          minHeight: 15,
          minWidth: 15
        ),

        ),
      );

  }
}
