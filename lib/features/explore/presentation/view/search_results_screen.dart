import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/features/explore/data/models/artical_model.dart';
import 'package:news_app/features/explore/data/repo/search_repo.dart';
import 'package:news_app/features/explore/presentation/view/artical_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchText;

  const SearchResultsScreen({
    super.key,
    required this.searchText,
  });

  @override
  State<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState
    extends State<SearchResultsScreen> {
  int selectedTab = 0;

  late Future<List<ArticleModel>> articlesFuture;

  final SearchRepo searchRepo = SearchRepo();

  final List<String> categories = [
    'All',
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  Map<String, int> categoryCounts = {
    'All': 0,
    'Business': 0,
    'Entertainment': 0,
    'General': 0,
    'Health': 0,
    'Science': 0,
    'Sports': 0,
    'Technology': 0,
  };

  @override
  void initState() {
    super.initState();

    // Get articles when screen opens
    articlesFuture = getArticles();

    // Get number of articles for every category
    getCategoryCounts();
  }

  Future<List<ArticleModel>> getArticles() async {
    String? category;

    if (selectedTab != 0) {
      category = categories[selectedTab].toLowerCase();
    }

    final result = await searchRepo.searchArticles(
      searchText: widget.searchText,
      category: category,
      sortBy: 'publishedAt',
    );

    return result.fold(
      (error) {
        throw Exception(error);
      },
      (data) {
        return data['articles'] as List<ArticleModel>;
      },
    );
  }

  Future<void> getCategoryCounts() async {
    final List<Future<void>> requests = [];

    // All
    requests.add(
      searchRepo
          .searchArticles(
            searchText: widget.searchText,
            sortBy: 'publishedAt',
          )
          .then((result) {
        result.fold(
          (error) {},
          (data) {
            categoryCounts['All'] =
                data['totalResults'] ?? 0;
          },
        );
      }),
    );

    // Categories
    for (int i = 1; i < categories.length; i++) {
      final String category =
          categories[i].toLowerCase();

      requests.add(
        searchRepo
            .getCategoryCount(
              searchText: widget.searchText,
              category: category,
            )
            .then((result) {
          result.fold(
            (error) {},
            (count) {
              categoryCounts[categories[i]] = count;
            },
          );
        }),
      );
    }

    await Future.wait(requests);

    if (mounted) {
      setState(() {});
    }
  }

  void changeCategory(int index) {
    setState(() {
      selectedTab = index;

      // Get articles according to selected category
      articlesFuture = getArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================

            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AppSvgs.left_arrow,
                      width: 24,
                      height: 24,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Search results',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= CATEGORIES =================

            SizedBox(
              height: 42,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: Row(
                  children: [
                    for (int i = 0;
                        i < categories.length;
                        i++) ...[
                      _buildCategory(
                        title: categories[i],
                        count: categoryCounts[
                                    categories[i]]
                                .toString(),
                        index: i,
                      ),

                      if (i != categories.length - 1)
                        const SizedBox(width: 30),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= ARTICLES =================

            Expanded(
              child: FutureBuilder<List<ArticleModel>>(
                future: articlesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(24),
                        child: Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No articles found',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  final articles = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];

                      // =================================================
                      // HERE IS THE CONNECTION WITH ARTICLE SCREEN
                      // =================================================

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleScreen(
                                article: article,
                              ),
                            ),
                          );
                        },

                        // Article card
                        child: _buildArticle(
                          article: article,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CATEGORY =================

  Widget _buildCategory({
    required String title,
    required String count,
    required int index,
  }) {
    final bool isSelected =
        selectedTab == index;

    return GestureDetector(
      onTap: () {
        changeCategory(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF0F4FA)
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              TextSpan(
                text: ' ($count)',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ARTICLE CARD =================

  Widget _buildArticle({
    required ArticleModel article,
  }) {
    return SizedBox(
      height: 138,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 2,
                right: 12,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.15,
                      fontWeight:
                          FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration:
                            const BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Color(0xFFD9D9D9),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Flexible(
                        child: Text(
                          '${article.author ?? 'Unknown author'}  ·  ${_formatDate(article.publishedAt)}',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ================= ARTICLE IMAGE =================

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: Image.network(
              article.urlToImage ?? '',
              width: 145,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error,
                      stackTrace) {
                return Container(
                  width: 145,
                  height: 90,
                  color:
                      Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= DATE =================

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    try {
      final DateTime parsedDate =
          DateTime.parse(date);

      return '${_getMonthName(parsedDate.month)} ${parsedDate.day}, ${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }
}