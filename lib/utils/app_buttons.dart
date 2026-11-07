
import '../features/export.dart';




class AppButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  // Sizing
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final Gradient? gradientColor;

  // Radius and borders
  final double? radius;
  final double borderWidth;
  final Color? borderColor;

  // Colors
  final Color? buttonColor;
  final Color? textColor;

  // Typography
  final FontWeight fontWeight;
  final double? fontSize;

  // Alignment
  final Alignment alignment;

  // Loader
  final bool loader;
  final bool isGradient,isGradientDisable;

  // Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const AppButtonWidget({
    super.key,
    required this.text,
    this.gradientColor,
    this.onPressed,
    this.height,
    this.width,
    this.padding,
    this.radius,
    this.borderWidth = 1,
    this.borderColor,
    this.buttonColor,
    this.textColor,
    this.fontWeight = FontWeight.w400,
    this.fontSize,
    this.alignment = Alignment.center,
    this.loader = false,
    this.isGradient = false,
    this.isGradientDisable = false,
    this.prefixIcon,
    this.suffixIcon,
   });

  @override
  Widget build(BuildContext context) {
    final bool hasBorder = borderColor != null;

    return GestureDetector(
      onTap: loader ? null : onPressed,
      child: Align(
        alignment: alignment,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 12),
          child: Container(

            decoration: BoxDecoration(
              gradient: isGradient ? AppColors.primaryGradient : null,
              // gradient: isGradientDisable ? AppColors.disable : isGradient ? AppColors.gradient : null,
            ),
            child: Container(
              height: height,
              width: width,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
            color: isGradient ? null : (buttonColor ?? AppColors.primary),
            gradient: isGradient
                ? (gradientColor ?? AppColors.primaryGradient)
                : null,
            borderRadius: BorderRadius.circular(radius ?? 12),
            border: hasBorder
                ? Border.all(
              color: borderColor!,
              width: borderWidth,
            )
                : Border.all(color: Colors.transparent),
          ),
              child: loader
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: AppText( text,
                      textAlign: TextAlign.center,

                      type: AppTextType.micro,
                      color: textColor ?? Colors.white,
                      fontWeight: fontWeight,
                      fontSize: fontSize ?? 16,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    suffixIcon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}