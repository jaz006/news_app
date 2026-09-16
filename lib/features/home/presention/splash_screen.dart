import 'package:flutter/material.dart';
import 'package:news_app/core/helper/app_navigation.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/features/home/presention/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      MyNavigator.goTo(context, toPage: OnboardingScreen(), type: NavigatorType.pushReplacement);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: Image.asset(AppImages.logo)),
    );
  }
}
