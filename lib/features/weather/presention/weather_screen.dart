import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/helper/app_navigation.dart';
import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Good Morning + date + small icon/temp
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFDCE6F7),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning,', style: TextStyle(fontSize: 14.sp)),
                    Text(
                      _todayDate,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('☀️'),
                    SizedBox(width: 4.w),
                    Text(
                      '${weather.main} ${weather.temp.round()}°C',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // City name
          Text(
            '${weather.cityName} - ${weather.country}',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12.h),

          // Big temp + icon
          Row(
            children: [
              Text(
                '${weather.temp.round()}',
                style: TextStyle(fontSize: 56.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 12.w),
              Text('☀️', style: TextStyle(fontSize: 60.sp)),
            ],
          ),

          Text(
            '${weather.main} - ${weather.description[0].toUpperCase()}${weather.description.substring(1)}',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            'Feels like ${weather.feelsLike.round()}',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),

          SizedBox(height: 24.h),

          // Grid of stats
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.thermostat,
                  value: '${weather.tempInFahrenheit.round()}°',
                  label: 'Fahrenheit',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _statCard(
                  icon: Icons.air,
                  value: '${weather.windSpeed} m/h',
                  label: 'Wind Speed',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.water_drop,
                  value: '${weather.humidity}%',
                  label: 'Humidity',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _statCard(
                  icon: Icons.speed,
                  value: '${weather.pressure} hPa',
                  label: 'Pressure',
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h),

          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () {
                MyNavigator.goTo(context, toPage: MapScreen());
              },
              icon: const Icon(Icons.location_on, color: Colors.white),
              label: const Text(
                'Change Location',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5BD0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2D5BD0)),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
