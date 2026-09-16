import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/features/explore/presentation/view/artical_screen.dart';
import 'package:news_app/features/explore/data/models/artical_model.dart';
import 'package:news_app/features/explore/data/repo/explore_repo.dart';
import 'package:news_app/features/explore/presentation/view/search_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedCategory = 'Business';

  final List<String> categories = [
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  late Future<List<ArticleModel>> articlesFuture;

  @override
  void initState() {
    super.initState();

    articlesFuture = getArticles('Business');
  }

  Future<List<ArticleModel>> getArticles(String category) async {
    final result = await ExploreRepo().getArticles(
      category: category.toLowerCase(),
    );

    return result.fold(
      (error) {
        throw Exception(error);
      },
      (articles) {
        return articles;
      },
    );
  }

  void changeCategory(String category) {
    setState(() {
      selectedCategory = category;
      articlesFuture = getArticles(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==========================================
      // Body
      // ==========================================

      body: FutureBuilder<List<ArticleModel>>(
        future: articlesFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No articles found',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          final List<ArticleModel> articles = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // ==========================================
                // Header
                // ==========================================

                Container(
                  width: double.infinity,
                  color: AppColors.primary,

                  child: SafeArea(
                    bottom: false,

                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 20,
                        bottom: 20,
                      ),

                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,

                        children: [

                          const Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchScreen(),
                                ),
                              );
                            },

                            child: SvgPicture.asset(
                              AppSvgs.search,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ==========================================
                // Rest of Content
                // ==========================================

                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 25,
                    bottom: 30,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // ==========================================
                      // Categories
                      // ==========================================

                      SizedBox(
                        height: 48,

                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal,

                          physics:
                              const BouncingScrollPhysics(),

                          itemCount:
                              categories.length,

                          itemBuilder:
                              (context, index) {

                            final String category =
                                categories[index];

                            return GestureDetector(
                              onTap: () {
                                changeCategory(
                                  category,
                                );
                              },

                              child: _category(
                                text: category,

                                selected:category ==selectedCategory,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ==========================================
                      // Main Article
                      // ==========================================

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ArticleScreen(
                                article: articles[0],
                              ),
                            ),
                          );
                        },

                        child: _mainArticle(
                          articles[0],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==========================================
                      // Small Articles
                      // ==========================================

                      if (articles.length > 1)
                        _smallArticle(
                          context,
                          articles[1],
                        ),

                      if (articles.length > 1)
                        const SizedBox(height: 25),

                      if (articles.length > 2)
                        _smallArticle(
                          context,
                          articles[2],
                        ),

                      if (articles.length > 2)
                        const SizedBox(height: 25),

                      if (articles.length > 3)
                        _smallArticle(
                          context,
                          articles[3],
                        ),

                      if (articles.length > 3)
                        const SizedBox(height: 25),

                      if (articles.length > 4)
                        _smallArticle(
                          context,
                          articles[4],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // Category
  // ==========================================

  Widget _category({
    required String text,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        right: 12,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary
            : Colors.transparent,

        borderRadius:
            BorderRadius.circular(25),

        border: Border.all(
          color: selected
              ? const Color(0xFFE9EDEC)
              : const Color(0xFFE1E4E3),
        ),
      ),

      child: Text(
        text,

        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  // ==========================================
  // Main Article
  // ==========================================

  Widget _mainArticle(
    ArticleModel article,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        ClipRRect(
          borderRadius:
              BorderRadius.circular(10),

          child: Image.network(
            article.urlToImage ?? '',

            width: double.infinity,
            height: 206,

            fit: BoxFit.cover,

            errorBuilder:
                (context, error, stackTrace) {

              return Container(
                width: double.infinity,
                height: 206,

                color: Colors.grey.shade300,

                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        Text(
          article.title,

          style: const TextStyle(
            fontSize: 27,
            height: 1.15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [

            Container(
              width: 26,
              height: 26,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey
              ),

              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                article.author ??
                    'Unknown author',

                overflow:
                    TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(width: 6),

            const Text(
              '•',

              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 6),

            Text(
              _formatDate(
                article.publishedAt,
              ),

              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // Small Article
  // ==========================================

  Widget _smallArticle(
    BuildContext context,
    ArticleModel article,
  ) {
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

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,

        children: [

          Expanded(
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
                    fontSize: 18,
                    height: 1.2,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    Container(
                      width: 24,
                      height: 24,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,
                        color:
                            Colors.grey.shade300,
                      ),

                      child: const Icon(
                        Icons.person,
                        size: 15,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Text(
                        '${article.author ?? 'Unknown author'}  •  ${_formatDate(article.publishedAt)}',

                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),

            child: Image.network(
              article.urlToImage ?? '',

              width: 158,
              height: 108,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {

                return Container(
                  width: 158,
                  height: 108,

                  color: Colors.grey.shade300,

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

  // ==========================================
  // Date
  // ==========================================

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }

    try {
      final DateTime parsedDate =
          DateTime.parse(date);

      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
}