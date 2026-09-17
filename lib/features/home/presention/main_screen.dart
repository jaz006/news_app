import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/helper/bottom_bar_items.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/features/bookmark/presention/bookmark_screen.dart';
import 'package:news_app/features/explore/presentation/view/explore_screen.dart';
import 'package:news_app/features/home/presention/home_screen.dart';
import 'package:news_app/features/weather/presention/weather_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final NotchBottomBarController controller =
      NotchBottomBarController(index: 0);



  final List<Widget> pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const bookmarkScreen(),
    const WeatherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: controller,
       

        showLabel: true,
        elevation: 1,
        removeMargins: false,
        bottomBarWidth: 500,
        showShadow: true,
        durationInMilliSeconds: 300,

        bottomBarItems: [
          bottomBarItem(
            imagepath: AppImages.home,
           
          ),
          bottomBarItem(
            imagepath: AppImages.earth,
           
          ),
          bottomBarItem(
            imagepath: AppImages.bookMark,
            
          ),
          bottomBarItem(
            imagepath: AppImages.weather,
            
          ),
        ],

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        }, kIconSize: 32, kBottomRadius: 20,  
      ),
    );
  }
}