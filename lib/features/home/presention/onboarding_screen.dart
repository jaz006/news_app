import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/helper/app_navigation.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/features/home/presention/map_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 583.h,
            child: Container(
              color: const Color(0xFF2249D4),
              child: Image.asset(AppImages.onboarding, fit: BoxFit.cover),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 421.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Get The Latest News\nAnd Updates',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'From Politics to Entertainment, Your One-Stop Source for Comprehensive Coverage of the Latest News and Developments Across the Globe will be right on your hand.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.secondary_text,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                    width: 145.w,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        MyNavigator.goTo(context, toPage: MapScreen(), type: NavigatorType.pushReplacement);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5BD0),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ' Explore ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                    ],
                  ),  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
