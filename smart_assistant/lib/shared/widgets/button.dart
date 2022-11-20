import 'package:flutter/material.dart';

import '../res/res.dart';

enum BtnState { active, inactive }

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    Key? key,
    this.onPressed,
    required this.label,
    this.btnColor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String label;
  final Color? btnColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = btnColor ?? SmartAssistantColors.primary;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyles.body.copyWith(color: SmartAssistantColors.white),
        ),
        style: TextButton.styleFrom(
          foregroundColor: effectiveBackgroundColor,
          backgroundColor: effectiveBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
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
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String label;
  final double width, height;

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
          size: 36,
          color: SmartAssistantColors.primary,
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyles.body
              .copyWith(color: SmartAssistantColors.primary, fontSize: 24),
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
          size: 36,
          color: SmartAssistantColors.white,
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyles.body
              .copyWith(color: SmartAssistantColors.white, fontSize: 24),
        ),
      ]),
    );
  }
}
