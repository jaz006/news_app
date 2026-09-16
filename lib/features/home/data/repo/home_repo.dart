import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';

import '../models/home_model.dart';


class HomeRepo {
  final ApiHelper apiHelper;

  static const String _apiKey = '836086f05b344448a16dd41ee51c6320';

  HomeRepo(this.apiHelper);

  Future<NewsResponse> getTopHeadlines({
    String? q,
    String category = 'science',
    String country = 'us',
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await apiHelper.getRequest(
        endPoint: EndPoints.topHeadlines,
        queryParams: {
          if (q != null) 'q': q,
          'apiKey': _apiKey,
          'category': category,
          'country': country,
          'pageSize': pageSize,
          'page': page,
        },
      );
      return NewsResponse.fromJson(response.data);
    } catch (e) {
      throw apiHelper.handleException(e);
    }
  }
}