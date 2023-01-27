import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res/res.dart';

//Widget containing image,
class OnboardingWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const OnboardingWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 46.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          Text(
            title,
            style: TextStyles.headline2.copyWith(
                color: SmartAssistantColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: TextStyles.headline2.fontSize),
          ),
          SizedBox(height: 16.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: TextStyles.body.fontSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
