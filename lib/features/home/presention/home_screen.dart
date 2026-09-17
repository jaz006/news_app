import 'package:flutter/material.dart';
import 'package:news_app/core/network/api_helper.dart';
import 'package:news_app/core/network/end_points.dart';
import 'package:news_app/features/home/data/models/home_model.dart';
import 'package:news_app/features/home/data/repo/home_repo.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeRepo _homeRepo;
  late Future<NewsResponse> _futureNews;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _homeRepo = HomeRepo(ApiHelper(EndPoints.newsBaseUrl));
    _futureNews = _homeRepo.getTopHeadlines(
      category: 'science',
      country: 'us',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FA),
      body: SafeArea(
        child: FutureBuilder<NewsResponse>(
          future: _futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final articles = snapshot.data?.articles ?? [];
            if (articles.isEmpty) {
              return const Center(child: Text('No articles available.'));
            }

            final featuredList =
                articles.length >= 3 ? articles.sublist(0, 3) : articles;
            final popular =
                articles.length > 3 ? articles.sublist(3) : <Article>[];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(featuredList[_currentPage].publishedAt),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Featured Carousel
                  SizedBox(
                    height: 320,
                    child: PageView.builder(
                      itemCount: featuredList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _FeaturedCard(article: featuredList[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(featuredList.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: index == _currentPage ? 10 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? Colors.blue
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Most Popular header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Most Popular',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See More'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),


               // Horizontal list of popular articles
 SizedBox(
    height: 260,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: popular.length,
      separatorBuilder: (context, index) => const SizedBox(width: 14),
      itemBuilder: (context, index) {
        return SizedBox(
          width: 170,
          child: _PopularCard(article: popular[index]),
        );
      },
    ),
  ),



                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final date = DateTime.tryParse(isoDate);
    if (date == null) return '';
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

class _FeaturedCard extends StatelessWidget {
  final Article article;
  const _FeaturedCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          article.urlToImage != null
              ? Image.network(article.urlToImage!, fit: BoxFit.cover)
              : Container(color: Colors.grey.shade300),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (article.author != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        article.author!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularCard extends StatelessWidget {
  final Article article;
  const _PopularCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 170,
              width: double.infinity,
              child: article.urlToImage != null
                  ? Image.network(article.urlToImage!, fit: BoxFit.cover)
                  : Container(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            article.source.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }
}