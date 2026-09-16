import 'package:dartz/dartz.dart';
import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';
import 'package:news_app/features/explore/data/models/artical_model.dart';

class SearchRepo {
  ApiHelper apiHelper = ApiHelper(EndPoints.newsBaseUrl);

  Future<Either<String, Map<String, dynamic>>> searchArticles({
    required String searchText,
    String? category,
    String sortBy = 'publishedAt',
  }) async {
    try {
      String query = searchText.trim();

      if (category != null) {
        query = '$query AND $category';
      }

      var response = await apiHelper.getRequest(
        endPoint: EndPoints.everything,
        queryParams: {
          'apiKey': '836086f05b344448a16dd41ee51c6320',
          'q': query,
          'language': 'en',
          'sortBy': sortBy,
        },
      );

      var jsonResponse =
          response.data as Map<String, dynamic>;

      var articlesJson =
          jsonResponse['articles'] as List;

      int totalResults =
          jsonResponse['totalResults'] ?? 0;

      List<ArticleModel> articles = [];

      for (var article in articlesJson) {
        articles.add(
          ArticleModel.fromJson(article),
        );
      }

      return right({
        'articles': articles,
        'totalResults': totalResults,
      });
    } catch (e) {
      return left(
        apiHelper.handleException(e),
      );
    }
  }

  Future<Either<String, int>> getCategoryCount({
    required String searchText,
    required String category,
  }) async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.topHeadlines,
        queryParams: {
          'apiKey': '836086f05b344448a16dd41ee51c6320',
          'q': searchText,
          'category': category,
          'country': 'us',
        },
      );

      var jsonResponse =
          response.data as Map<String, dynamic>;

      int totalResults =
          jsonResponse['totalResults'] ?? 0;

      return right(totalResults);
    } catch (e) {
      return left(
        apiHelper.handleException(e),
      );
    }
  }
}