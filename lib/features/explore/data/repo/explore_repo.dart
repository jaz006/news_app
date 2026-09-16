import 'package:dartz/dartz.dart';
import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';
import 'package:news_app/features/explore/data/models/artical_model.dart';

class ExploreRepo {
  ApiHelper apiHelper = ApiHelper(EndPoints.newsBaseUrl);

  Future<Either<String, List<ArticleModel>>> getArticles({
  required String category,
}) async {
  try {
    var response = await apiHelper.getRequest(
      endPoint: EndPoints.topHeadlines,
      queryParams: {
        'apiKey': '836086f05b344448a16dd41ee51c6320',
        'category': category,
        'country': 'us',
      },
    );

    var jsonResponse = response.data as Map<String, dynamic>;

    var articlesJson = jsonResponse['articles'] as List;

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