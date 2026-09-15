import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/screens/explore/data/models/artical_model.dart';

class ArticleScreen extends StatefulWidget {
  final ArticleModel article;

  const ArticleScreen({
    super.key,
    required this.article,
  });

  @override
  State<ArticleScreen> createState() =>
      _ArticleScreenState();
}

class _ArticleScreenState
    extends State<ArticleScreen> {

  bool isBookmarked = false;

  @override
  Widget build(BuildContext context) {

    final ArticleModel article =
        widget.article;

    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: Stack(
        children: [

          // ==========================================
          // Article Image
          // ==========================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,

            child: Image.network(
              article.urlToImage ?? '',

              height: 410,

              fit: BoxFit.cover,

              errorBuilder:
                  (context, error, stackTrace) {

                return Container(
                  height: 410,

                  color: Colors.grey.shade300,

                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          // ==========================================
          // Article
          // ==========================================

          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.58,
            maxChildSize: 0.92,

            builder: (
              context,
              scrollController,
            ) {

              return Container(
                decoration:
                    const BoxDecoration(
                  color:
                      AppColors.background,

                  borderRadius:
                      BorderRadius.only(
                    topLeft:
                        Radius.circular(32),
                    topRight:
                        Radius.circular(32),
                  ),
                ),

                child: ListView(
                  controller:
                      scrollController,

                  padding:
                      const EdgeInsets.only(
                    top: 18,
                    left: 24,
                    right: 24,
                    bottom: 40,
                  ),

                  children: [

                    // ==================================
                    // Top Icons
                    // ==================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [

                        // Back
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context);
                          },

                          child:
                              SvgPicture.asset(
                            AppSvgs.left_arrow,
                            width: 40,
                            height: 40,
                          ),
                        ),

                        Row(
                          children: [

                            // Bookmark
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBookmarked =
                                      !isBookmarked;
                                });
                              },

                              child:
                                  isBookmarked
                                      ? SvgPicture
                                          .asset(
                                          AppSvgs
                                              .bookmark,
                                          width: 25,
                                          height: 25,
                                        )
                                      : SvgPicture
                                          .asset(
                                          AppSvgs
                                              .bookmarknot,
                                          width: 25,
                                          height: 25,
                                        ),
                            ),

                            const SizedBox(
                              width: 20,
                            ),

                            // Share
                            GestureDetector(
                              onTap: () {},

                              child:
                                  SvgPicture.asset(
                                AppSvgs.share,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================
                    // Article Title
                    // ==================================

                    Text(
                      article.title,

                      style:
                          const TextStyle(
                        fontSize: 29,
                        height: 1.15,
                        fontWeight:
                            FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // ==================================
                    // Author
                    // ==================================

                    Row(
                      children: [

                        Container(
                          width: 27,
                          height: 27,

                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,
                            color: Colors
                                .grey.shade300,
                          ),

                          child:
                              const Icon(
                            Icons.person,
                            size: 17,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Expanded(
                          child: Text(
                            article.author ??
                                'Unknown author',

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              fontSize: 12,
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 7,
                        ),

                        const Text(
                          '•',

                          style:
                              TextStyle(
                            fontSize: 12,
                            color:
                                Colors.grey,
                          ),
                        ),

                        const SizedBox(
                          width: 7,
                        ),

                        Text(
                          _formatDate(
                            article.publishedAt,
                          ),

                          style:
                              const TextStyle(
                            fontSize: 12,
                            color:
                                Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================
                    // Article Content
                    // ==================================

                    Text(
                      article.content ??
                          article.description ??
                          'No content available.',

                      style:
                          const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color:
                            Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              );
            },
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