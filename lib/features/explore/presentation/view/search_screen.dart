import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/core/utilies/app_assests.dart';
import 'package:news_app/core/utilies/app_colors.dart';
import 'package:news_app/features/explore/presentation/view/search_results_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController =
      TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  void openSearchResults() {
    final text = searchController.text.trim();

    if (text.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          searchText: text,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 35,
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // Search Box

              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    autofocus: false,
                    onTap: () {
                      searchFocusNode.requestFocus();
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      openSearchResults();
                    },

                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),

                    decoration: InputDecoration(

                      // =========================
                      // Search Icon

                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                          left: 14,
                          right: 8,
                        ),
                        child: SvgPicture.asset(
                          AppSvgs.SearchOutline,
                          width: 13,
                          height: 13,
                        ),
                      ),

                      prefixIconConstraints:
                          const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),

                      // =========================
                      // X Button

                      suffixIcon:searchController.text.isNotEmpty?IconButton(
                        onPressed: () {
                          searchController.clear();
                          searchFocusNode.requestFocus();
                        },

                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 22,
                        ),
                      )
                      : null,
                      filled: true,
                      fillColor: const Color(0xFFF0EFF0),
                      contentPadding:const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10),

                        borderSide:const BorderSide(
                          color: Color(0xFFB8C4D8),
                          width: 1.5,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10),
                        borderSide:const BorderSide(
                          color: Color(0xFF577CD9),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                height: 68,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5369B5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}