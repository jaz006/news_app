import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/helper/app_navigation.dart';
import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/features/home/presention/map_screen.dart';
import 'package:news_app/features/weather/data/models/weather_model.dart';
import 'package:news_app/features/weather/data/repo/weather_repo.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherRepo _weatherRepo;
  Future<WeatherModel>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherRepo = WeatherRepo(ApiHelper(EndPoints.weatherBaseUrl));
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _weatherFuture = _getWeatherWithLocation();
    });
  }

  Future<WeatherModel> _getWeatherWithLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location Service please enable it.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever.');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return _weatherRepo.getWeather(
      lat: position.latitude,
      lon: position.longitude,
    );
  }

  String get _todayDate =>
      DateFormat('EEE d MMMM, yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<WeatherModel>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.error.toString().replaceAll('Exception: ', ''),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: _loadWeather,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final weather = snapshot.data!;
            return _buildWeatherBody(weather);
          },
        ),
      ),
    );
  }

  Widget _buildWeatherBody(WeatherModel weather) {
    return SingleChildScrollView(
      
      child: Padding(
        
        padding: const EdgeInsets.symmetric( vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Good Morning + date + small icon/temp
            Container(
              width: 430.w,
              height:92.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE9EEFA),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning :)', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400)),
                      SizedBox(height: 10.h),
                      Text(
                        _todayDate,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('☀️', style: TextStyle(fontSize: 32.sp)),
                      SizedBox(width: 4.w),
                      Text(
                        '${weather.main} ${weather.temp.round()}°C',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        
            SizedBox(height: 24.h),
        
            // City name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${weather.cityName} - ${weather.country}',
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
              ),
            ),
        
            SizedBox(height: 12.h),
        
            // Big temp + icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '${weather.temp.round()}',
                    style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Image.asset(AppImages.sun, width: 76.w, height: 76.h),
                ],
              ),
            ),
         
          SizedBox(height: 8.h),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${weather.main} - ${weather.description[0].toUpperCase()}${weather.description.substring(1)}',
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500),
              ),
            ),

           

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Feels like ${weather.feelsLike.round()}',
                style: TextStyle(fontSize: 16.sp, color: AppColors.secondary_text),
              ),
            ),
        
            SizedBox(height: 32.h),
        
            // Grid of stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _statCard(
                      imagepath: AppImages.temp1,
                      value: '${weather.tempInFahrenheit.round()}°',
                      label: 'Fahrenheit',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _statCard(
                      imagepath: AppImages.temp2,
                      value: '${weather.windSpeed} m/h',
                      label: 'Wind Speed',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _statCard(
                      imagepath: AppImages.temp3,
                      value: '${weather.pressure} hPa',
                      label: 'Pressure',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _statCard(
                      imagepath: AppImages.temp4,
                      value: '${weather.humidity}%',
                      label: 'Humidity',
                    ),
                  ),
                  
                  
                ],
              ),
            ),
        
            SizedBox(height: 80.h),
        
            Center(
              child: SizedBox(
                width: 244.w,
                height: 56.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    MyNavigator.goTo(context, toPage: MapScreen());
                  },
                  label: const Text(
                    'Change Location',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D5BD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(128.r),
                    ),
                    
                  ),
                  icon: const Icon(Icons.location_on, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String imagepath,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20.r),
        
      ),
      child: Row(
        children: [
          Image.asset(
            imagepath,
            width: 42.w,
            height: 42.h,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp, color: Color(0xFF2D5BD0)),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                 color: AppColors.secondary_text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
