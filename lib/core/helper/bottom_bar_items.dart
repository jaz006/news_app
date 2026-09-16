import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BottomBarItem bottomBarItem({
  required String imagepath,
 
}) {
  return BottomBarItem(
    activeItem: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagepath,     
        ),
      ],
    ),

    inActiveItem: Image.asset(
      imagepath,
      width: 24.w,
      height: 24.h,
    ),
  );
}