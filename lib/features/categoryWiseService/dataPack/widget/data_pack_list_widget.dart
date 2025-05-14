import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/model/datapack_model.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/screen/buy_datapack_screen.dart';

class DataPackList extends StatefulWidget {
  final List<DataPackPackage> dataList;
  final ServiceList service;
  const DataPackList({Key? key, required this.dataList, required this.service})
    : super(key: key);

  @override
  State<DataPackList> createState() => _DataPackListState();
}

class _DataPackListState extends State<DataPackList> {
  int? selectedIdex;
  bool viewMore = false;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    if (widget.dataList.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.dataList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final data = widget.dataList[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: CustomTheme.backgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(data.imagePath),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        data.name,
                        style: _textTheme.displaySmall!.copyWith(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        Text('NPR', style: _textTheme.headlineSmall),
                        Text(
                          data.amount.toString(),
                          style: _textTheme.displaySmall!.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: selectedIdex == index ? 10 : 1,
                            data.description,
                            style: _textTheme.titleSmall!.copyWith(
                              color: CustomTheme.darkGray,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            child: CustomRoundedButtom(
                              verticalPadding: 5,
                              color: Colors.transparent,
                              textColor: CustomTheme.primaryColor,
                              borderColor: Colors.transparent,
                              fontSize: 12,
                              title:
                                  selectedIdex == index
                                      ? 'View Less'
                                      : 'View More',
                              onPressed: () {
                                if (viewMore == false) {
                                  setState(() {
                                    selectedIdex = index;
                                    viewMore = !viewMore;
                                  });
                                } else {
                                  setState(() {
                                    selectedIdex = null;
                                    viewMore = !viewMore;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    CustomRoundedButtom(
                      verticalPadding: 10,
                      verificationAmount: data.amount.toString(),
                      fontSize: 10,
                      title: 'Buy Now',
                      onPressed: () {
                        NavigationService.push(
                          target: BuyDatapackScreen(
                            service: widget.service,
                            package: data,
                          ),
                        );
                      },
                      color: CustomTheme.backgroundColor,
                      textColor: CustomTheme.primaryColor,
                      borderColor: CustomTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      return const NoDataScreen(
        details: "",
        title: "No Data Found.",
        showImage: true,
      );
    }
  }
}
