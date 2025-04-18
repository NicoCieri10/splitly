import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    super.key,
    this.height,
    this.width,
    this.border = BorderSide.none,
    this.backgroundColor,
    this.loadingColor = Colors.white,
    this.disabledBackgroundColor = Colors.grey,
    this.textStyle,
    this.onPressed,
    this.loading = false,
    this.borderRadius,
    this.loadingWidth = 3,
    this.suffixIcon,
    this.preffixIcon,
    this.elevation = 1,
    this.textScaleFactor = 1,
    this.splashColor = const Color.fromARGB(31, 255, 255, 255),
    this.iconsColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.textAlign,
  });

  /// The text to display on the button.
  final String text;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The background color when the button is disabled.
  final Color disabledBackgroundColor;

  /// The color of the loading indicator (only shown when [loading] is true).
  final Color loadingColor;

  /// The callback executed when the button is pressed.
  final void Function()? onPressed;

  /// Whether the button is currently loading.
  final bool loading;

  /// The border radius of the button.
  final double? borderRadius;

  /// The height of the button.
  final double? height;

  /// The width of the button.
  final double? width;

  /// The width of the loading indicator.
  final double loadingWidth;

  /// The icon to display on the button, if there's one.
  final IconData? suffixIcon;

  /// The icon to display on the button, if there's one.
  final IconData? preffixIcon;

  /// The style of the text in the button.
  final TextStyle? textStyle;

  /// The style of the border of the button.
  final BorderSide border;

  /// The elevation of the button.
  final double elevation;

  /// The text scale factor to force the text to be bigger or smaller.
  final double textScaleFactor;

  /// The color of the splash effect when the button is pressed.
  final Color splashColor;

  /// The color of the icons.
  final Color iconsColor;

  /// The inner padding of the button.
  final EdgeInsets padding;

  /// The alignment of the text.
  final TextAlign? textAlign;

  /// The buttom margin.
  final EdgeInsets margin;

  bool get isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: MaterialButton(
        height: height ?? 25.sp,
        minWidth: width ?? double.maxFinite,
        onPressed: onPressed,
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        padding: padding,
        elevation: 0,
        splashColor: splashColor,
        disabledColor: disabledBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 15.sp),
          side: border,
        ),
        child: loading
            ? SizedBox.square(
                dimension: 22.sp,
                child: CircularProgressIndicator(
                  color: loadingColor,
                  strokeWidth: loadingWidth,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (preffixIcon != null)
                    Icon(
                      preffixIcon,
                      color: isDisabled
                          ? Colors.black.withValues(alpha: 0.38)
                          : iconsColor,
                    ),
                  Flexible(
                    child: Text(
                      text,
                      style: textStyle?.copyWith(
                            color: isDisabled
                                ? Colors.black.withValues(alpha: 0.38)
                                : null,
                          ) ??
                          TextStyle(
                            fontSize: 18.sp,
                            color: isDisabled
                                ? Colors.black.withValues(alpha: 0.38)
                                : Colors.white,
                          ),
                      textScaler: TextScaler.linear(textScaleFactor),
                      maxLines: 1,
                      textAlign: textAlign,
                    ),
                  ),
                  if (suffixIcon != null)
                    Icon(
                      suffixIcon,
                      color: isDisabled
                          ? Colors.black.withValues(alpha: 0.38)
                          : iconsColor,
                    ),
                ],
              ),
      ),
    );
  }
}
