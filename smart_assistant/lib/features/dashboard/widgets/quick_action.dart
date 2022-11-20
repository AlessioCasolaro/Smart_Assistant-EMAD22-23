import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/shared/widgets/button.dart';

import '../../../../shared/res/res.dart';

class QuickAction extends StatelessWidget {
  //final String action;
  const QuickAction({
    Key? key,
    //required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const width = 120.0;
    const height = 55;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonIconNoBG(
          label: 'Search',
          height: height.h,
          width: width.w,
          icon: Icons.search,
          onPressed: () {},
        ),
        ButtonIconNoBG(
          label: 'Chatbot',
          height: height.h,
          width: width.w,
          icon: Icons.smart_toy,
          onPressed: () {},
        ),
        ButtonIconNoBG(
          label: 'Human Help',
          height: height.h,
          width: width.w,
          icon: Icons.engineering,
          onPressed: () {},
        ),
      ],
    );
  }
}
