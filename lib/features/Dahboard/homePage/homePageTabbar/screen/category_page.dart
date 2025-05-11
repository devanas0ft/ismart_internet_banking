import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/cubit/category_cubit.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/resources/category_repository.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/widget/category_widget.dart';

class CategoryPage extends StatefulWidget {
  final bool showAllServices;

  const CategoryPage({super.key, required this.showAllServices});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> _bannerImages = [];
  List<String> _defaultBannerImages = [];

  @override
  void initState() {
    // _bannerImages = RepositoryProvider.of<StartUpRepository>(context).banners;
    // _defaultBannerImages =
    // RepositoryProvider.of<StartUpRepository>(context).defaultbanners;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return BlocProvider(
      create:
          (context) => CategoryCubit(
            servicesRepository: RepositoryProvider.of<CategoryRepository>(
              context,
            ),
          )..fetchCategory(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CategoryWidget(showAllService: widget.showAllServices),
            SizedBox(height: 10.hp),
            // if (_bannerImages.isNotEmpty)
            //   CustomCarousel(
            //     height: 140.hp,
            //     topMargin: 10,
            //     items: _bannerImages,
            //   ),
            // if (_bannerImages.isEmpty && _defaultBannerImages.isNotEmpty)
            //   CustomCarousel(
            //     height: 140.hp,
            //     topMargin: 10,
            //     items: _defaultBannerImages,
            //   ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // NavigationService.push(target: const NoticePage());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(7, 7),
                            blurRadius: 8,
                            spreadRadius: -5,
                          ),
                        ],
                        color: CustomTheme.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.eventIcon,
                            height: 20.hp,
                            color: _theme.primaryColor,
                          ),
                          SizedBox(width: 20.wp),
                          Text(
                            "Event",
                            style: _textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.wp),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // NavigationService.push(target: const EventPage());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(7, 7),
                            blurRadius: 8,
                            spreadRadius: -5,
                          ),
                        ],
                        color: CustomTheme.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.loanSchedule,
                            height: 20.hp,
                            color: _theme.primaryColor,
                          ),
                          SizedBox(width: 10.wp),
                          Text(
                            "Notice",
                            style: _textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.hp),
          ],
        ),
      ),
    );
  }
}
