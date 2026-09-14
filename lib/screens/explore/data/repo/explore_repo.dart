import 'package:dartz/dartz.dart';
import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';
import 'package:news_app/screens/explore/data/models/artical_model.dart';

class ExploreRepo {

  ApiHelper apiHelper = ApiHelper(EndPoints.newsBaseUrl);

  Future<Either<String, List<ArticleModel>>> getArticles() async {

    try {

      var response = await apiHelper.getRequest(
        endPoint: EndPoints.everything,
        queryParams: {
          'q': 'we',
          'apiKey': '836086f05b344448a16dd41ee51c6320',
          'language': 'en',
          'sortBy': 'popularity',
        },
      );

      var jsonResponse =
          response.data as Map<String, dynamic>;

      var articlesJson =
          jsonResponse['articles'] as List;

      List<ArticleModel> articles = [];

      for (var article in articlesJson) {
        articles.add(
          ArticleModel.fromJson(article),
        );
      }

      return right(articles);

    } catch (e) {

      return left(
        apiHelper.handleException(e),
      );
    }
  }
}