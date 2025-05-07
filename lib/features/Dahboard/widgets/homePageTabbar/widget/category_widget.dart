import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/constants/env.dart';
import 'package:ismart_web/common/constants/slugs.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/cubit/category_cubit.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/screen/all_category_screen.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/screen/category_wise_services_page.dart';

import '../../../../../common/app/navigation_service.dart';

class CategoryWidget extends StatefulWidget {
  final bool showAllService;
  const CategoryWidget({Key? key, this.showAllService = true})
    : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchCategory();
  }

  bool _isLoading = false;

  List<CategoryList> _categoryList = [];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: CustomTheme.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: BlocConsumer<CategoryCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && !_isLoading) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }

          if (state is CommonError) {
            showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }

          if (state is CommonDataFetchSuccess<CategoryList>) {
            _categoryList = state.data;
          }
        },
        builder: (context, state) {
          int itemLength;
          bool showViewMore = false;

          if (widget.showAllService) {
            itemLength = _categoryList.length;
          } else {
            if (_categoryList.length > 11) {
              itemLength = 12; // 7 items + 1 "View More" option
              showViewMore = true;
            } else {
              itemLength = _categoryList.length;
            }
          }

          if (itemLength > 0)
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemLength,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                if (showViewMore && index == 11) {
                  return InkWell(
                    onTap: () {
                      NavigationService.push(target: AllCategoryScreen());
                    },
                    child: Column(
                      children: [
                        Container(
                          height: _height * 0.03,
                          child: CircleAvatar(
                            backgroundColor: _theme.primaryColor,
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Center(
                            child: Text(
                              "View More",
                              textAlign: TextAlign.center,
                              style: _textTheme.titleSmall!.copyWith(
                                fontSize: 11.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  final data = _categoryList[index];

                  final filteredItems =
                      data.services
                          .where((item) => item.cashBackView != null)
                          .toList();

                  final _imageUrl =
                      "${RepositoryProvider.of<CoOperative>(context).baseUrl}${data.imageUrl}";
                  return InkWell(
                    onTap: () {
                      if (data.uniqueIdentifier.toString().toLowerCase() ==
                          Slugs.topup) {
                        // NavigationService.push(
                        //   target: MobileTopupPage(categoryList: data),
                        // );
                        return;
                      }
                      if (data.uniqueIdentifier.toString().toLowerCase() ==
                          Slugs.brokerPage) {
                        // NavigationService.push(
                        //   target: BrokerPaymentPage(
                        //     service: data.services.first,
                        //   ),
                        // );
                      } else if (data.uniqueIdentifier
                              .toString()
                              .toLowerCase() ==
                          "electricity") {
                        // NavigationService.push(
                        //   target: ElectricityPaymentPage(
                        //     service: data.services[0],
                        //   ),
                        // );
                      } else if (data.uniqueIdentifier
                              .toString()
                              .toLowerCase() ==
                          "airlines") {
                        // NavigationService.push(
                        //   target: AirlinesIntroPage(service: data.services[0]),
                        // );
                      } else if (data.uniqueIdentifier
                              .toString()
                              .toLowerCase() ==
                          "credit_card") {
                        // NavigationService.push(
                        //   target: CreditCardPaymentPage(
                        //     service: data.services[0],
                        //   ),
                        // );
                      } else if (data.uniqueIdentifier
                                  .toString()
                                  .toLowerCase() ==
                              "landline".toLowerCase() ||
                          data.uniqueIdentifier.toString().toLowerCase() ==
                              "category".toLowerCase()) {
                        // NavigationService.push(
                        //   target: LandlinePaymentPage(category: data),
                        // );
                      } else if (data.uniqueIdentifier
                              .toString()
                              .toLowerCase() ==
                          "movies".toLowerCase()) {
                        // NavigationService.push(
                        //   target: MoviePage(category: data),
                        // );
                      } else if (data.uniqueIdentifier
                              .toString()
                              .toLowerCase() ==
                          Slugs.busTicket) {
                        // NavigationService.push(
                        //   target: BusBookingPage(service: data.services.first),
                        // );
                      } else {
                        NavigationService.push(
                          target: CategoriesWiseServicePage(
                            uniqueIdentifier: data.uniqueIdentifier,
                            services: data.services,
                            topBarName: data.name,
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        data.isNew == true
                            ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    'New',
                                    style: _textTheme.bodyLarge!.copyWith(
                                      color: CustomTheme.white,
                                      fontSize: 7,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : Container(),
                        Column(
                          children: [
                            Container(
                              height: _height * 0.03,
                              child:
                                  _imageUrl.toLowerCase().contains("svg")
                                      ? SvgPicture.network(
                                        _imageUrl,
                                        color: _theme.primaryColor,
                                        placeholderBuilder:
                                            (BuildContext context) => Center(
                                              child: Image.asset(
                                                Assets.logoImage,
                                              ),
                                            ),
                                      )
                                      : Image.network(
                                        _imageUrl,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Center(
                                            child: Image.asset(
                                              Assets.logoImage,
                                            ),
                                          );
                                        },
                                      ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Center(
                                child: Text(
                                  "${data.name}",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: _textTheme.titleSmall!.copyWith(
                                    fontSize: 11.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            filteredItems.isNotEmpty
                                ? Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CustomTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "${filteredItems[0].cashBackView} cashback",
                                    overflow: TextOverflow.ellipsis,
                                    style: _textTheme.bodyLarge!.copyWith(
                                      color: CustomTheme.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          return Container();
        },
      ),
    );
  }
}
