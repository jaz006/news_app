
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/features/home/presention/map_screen.dart';
import 'package:news_app/features/home/presention/splash_screen.dart';
import 'package:news_app/features/weather/presention/weather_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 945),
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                fontSize: 16,
                color: Colors.black,
              )
            )
            // colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)
              
          ),
          home:
           SplashScreen(),
           
            
        );
      },
    );
  }
}