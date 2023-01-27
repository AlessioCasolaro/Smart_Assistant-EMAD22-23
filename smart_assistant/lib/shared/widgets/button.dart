import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res/res.dart';

enum BtnState { active, inactive }

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    Key? key,
    this.onPressed,
    required this.label,
    required this.width,
    required this.height,
    required this.fontSize,
    this.btnColor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String label;
  final Color? btnColor;
  final double width, height, fontSize;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = btnColor ?? SmartAssistantColors.primary;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style:
              TextStyle(color: SmartAssistantColors.white, fontSize: fontSize),
        ),
        style: TextButton.styleFrom(
            foregroundColor: effectiveBackgroundColor,
            backgroundColor: effectiveBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(width, height)),
      ),
    );
  }
}

class ButtonIconNoBG extends StatelessWidget {
  final IconData icon;
  const ButtonIconNoBG({
    Key? key,
    this.onPressed,
    required this.label,
    required this.height,
    required this.width,
    required this.icon,
    required this.fontSize,
    required this.iconSize,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String label;
  final double width, height, fontSize, iconSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height), //Grandezza bottone
        backgroundColor: SmartAssistantColors.white, //Colore sfondo bottone
        shape: RoundedRectangleBorder(
          //Forma bottone
          borderRadius: BorderRadius.circular(5),
        ),
        side: BorderSide(
            color: SmartAssistantColors.primary,
            width: 3), //colore del bordo del bottone
      ),
      onPressed: onPressed,
      child: Row(children: [
        Icon(
          icon,
          size: iconSize,
          color: SmartAssistantColors.primary,
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(
              color: SmartAssistantColors.primary, fontSize: fontSize),
        ),
      ]),
    );
  }
}

class ButtonIconPrimary extends StatelessWidget {
  final IconData icon;
  const ButtonIconPrimary({
    Key? key,
    this.onPressed,
    required this.label,
    required this.height,
    required this.width,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String label;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height), //Grandezza bottone
        backgroundColor: SmartAssistantColors.primary, //Colore sfondo bottone
        shape: RoundedRectangleBorder(
          //Forma bottone
          borderRadius: BorderRadius.circular(5),
        ),
        side: BorderSide(
            color: SmartAssistantColors.primary,
            width: 3), //colore del bordo del bottone
      ),
      onPressed: onPressed,
      child: Row(children: [
        Icon(
          icon,
          size: 36.sp,
          color: SmartAssistantColors.white,
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(color: SmartAssistantColors.white, fontSize: 22.sp),
        ),
      ]),
    );
  }
}
