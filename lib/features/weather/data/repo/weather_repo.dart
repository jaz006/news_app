import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';
import 'package:news_app/features/weather/data/models/weather_model.dart';

class WeatherRepo {
  final ApiHelper apiHelper;

  WeatherRepo(this.apiHelper);

  Future<WeatherModel> getWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await apiHelper.getRequest(
        endPoint: EndPoints.weatherEndPoint,
        queryParams: {
          'lat': lat,
          'lon': lon,
          'appid': EndPoints.weatherApiKey,
          'units': 'metric',
        },
      );

      return WeatherModel.fromJson(response.data);
    } catch (e) {
      throw Exception(apiHelper.handleException(e));
    }
  }
}