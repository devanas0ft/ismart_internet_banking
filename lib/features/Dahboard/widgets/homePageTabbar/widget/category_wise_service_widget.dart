import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/model/category_model.dart';

class CategoriesWiseServicesWidget extends StatefulWidget {
  final List<ServiceList> services;
  final String categoryIdentifier;
  final String topBarName;
  const CategoriesWiseServicesWidget({
    Key? key,
    required this.services,
    required this.topBarName,
    required this.categoryIdentifier,
  }) : super(key: key);

  @override
  State<CategoriesWiseServicesWidget> createState() =>
      _CategoriesWiseServicesWidgetState();
}

class _CategoriesWiseServicesWidgetState
    extends State<CategoriesWiseServicesWidget> {
  List<ServiceList> searchItems = [];
  Timer? _debounce;

  @override
  void initState() {
    searchItems = widget.services;
    super.initState();
  }

  _updateSearchList(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final _res =
          widget.services
              .where(
                (e) => e.service.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      if (mounted) {
        setState(() {
          searchItems = _res;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        showRoundBotton: false,
        title: "Choose Service Povider",
        body: Column(
          children: [
            const SizedBox(height: 10),
            CustomTextField(
              hintText: "Search",
              showSearchIcon: true,
              onChanged: (val) {
                _updateSearchList(val);
              },
            ),
            const SizedBox(height: 10),
            Container(
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onTapFunction(
                        index: index,
                        serviceIdentifier: searchItems[index].uniqueIdentifier,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(
                                "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${searchItems[index].icon}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: _height * 0.11,
                          width: _width * 0.25,
                        ),
                        SizedBox(height: _height * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            searchItems[index].service.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            style: const TextStyle(
                              color: CustomTheme.darkerBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        showDetail: false,
        topbarName: widget.topBarName,
      ),
    );
  }

  onTapFunction({required String serviceIdentifier, required int index}) {
    // final selectedService = widget.services
    // .where((e) =>
    // e.uniqueIdentifier.toString().toLowerCase() == uniqueIdentifier)
    // .toList();
    // final searchedService = searchItems[index];

    // if (widget.categoryIdentifier.toLowerCase() == Slugs.tv.toLowerCase()) {
    //   if (serviceIdentifier.toLowerCase() ==
    //       Slugs.netTvOnlineTopup.toLowerCase()) {
    //     NavigationService.push(
    //         target: NetTvPaymentPage(
    //       service: searchedService,
    //     ));
    //   } else {
    //     NavigationService.push(
    //         target: TvPaymentPage(
    //       service: searchedService,
    //     ));
    //   }
    // }
    // if (serviceIdentifier.toLowerCase() == "digital_dakshina_service") {
    //   NavigationService.push(
    //       target: QRScannerScreens(
    //     remarks: searchedService.instructions,
    //   ));
    // }
    // if (widget.categoryIdentifier.toLowerCase() == "internet".toLowerCase()) {
    //   if (serviceIdentifier.toLowerCase() ==
    //       Slugs.worldlinkPayment.toLowerCase()) {
    //     NavigationService.push(
    //         target: FindInternetUserScreen(
    //       service: searchedService,
    //     ));
    //   } else if (serviceIdentifier.toLowerCase() ==
    //       "subisu_online_topup".toLowerCase()) {
    //     NavigationService.push(
    //         target: SubisuPaymentPage(
    //       service: searchedService,
    //     ));
    //   } else if (serviceIdentifier.toLowerCase() ==
    //       Slugs.cgnetTopup.toLowerCase()) {
    //     NavigationService.push(
    //         target: CgPaymentPage(
    //       service: searchedService,
    //     ));
    //   } else if (serviceIdentifier.toLowerCase() ==
    //           Slugs.alishaTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() == Slugs.infonetTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.royalnetworkTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.eastlinkTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.ntFtthInternetTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.webnetworkTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.virtualnetworkTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.pokharainternetTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.adsluOnlineTopup.toLowerCase() ||
    //       serviceIdentifier.toLowerCase() ==
    //           Slugs.metrolinkTopup.toLowerCase()) {
    //     NavigationService.push(
    //         target: CommonInternetWithAmountPage(
    //       service: searchedService,
    //     ));
    //   } else {
    //     NavigationService.push(
    //         target: CommonInternetPage(
    //       service: searchedService,
    //     ));
    //   }
    // }

    // if (widget.categoryIdentifier.toLowerCase() ==
    //     Slugs.rideSharing.toLowerCase()) {
    //   if (serviceIdentifier == Slugs.tootleTopup) {
    //     NavigationService.push(
    //         target: TootlepaymentPage(
    //       service: searchedService,
    //     ));
    //   } else {
    //     NavigationService.push(
    //         target: RidePaymentPage(
    //       service: searchedService,
    //     ));
    //   }
    // }

    // if (serviceIdentifier.toLowerCase() ==
    //     "khanepani_online_topup".toLowerCase()) {
    //   NavigationService.push(
    //       target: KhanePaniPage(
    //     service: searchedService,
    //   ));
    // } else if (serviceIdentifier.toLowerCase() == Slugs.kukl.toLowerCase()) {
    //   NavigationService.push(
    //       target: KuklPaymentPage(
    //     service: searchedService,
    //   ));
    // }
    // if (widget.categoryIdentifier == "data_pack") {
    //   NavigationService.push(
    //       target: SelectDatapackScreen(
    //     service: searchedService,
    //   ));
    // }

    // if (widget.categoryIdentifier.toLowerCase() == "insurance".toLowerCase()) {
    //   // if (serviceIdentifier.toLowerCase() ==
    //   //         "nepal_life_insurance".toLowerCase() ||
    //   //     serviceIdentifier.toLowerCase() ==
    //   //         "reliance_life_insurance".toLowerCase() ||
    //   //     serviceIdentifier.toLowerCase() ==
    //   //         "Union_Life_Insurance".toLowerCase() ||
    //   //     serviceIdentifier.toLowerCase() ==
    //   //         "prabhu_life_insurance".toLowerCase() ||
    //   //     serviceIdentifier.toLowerCase() ==
    //   //         "sura_life_insurance".toLowerCase() ||
    //   //     serviceIdentifier.toLowerCase() ==
    //   //         Slugs.jyotiLifeInsurance.toLowerCase()) {
    //   //   NavigationService.push(
    //   //       target: LifeInsurancePage(
    //   //     service: servicess,
    //   //   ));
    //   if (searchedService.labelPrefix.toString().toLowerCase() ==
    //       "lifeinsurance") {
    //     NavigationService.push(
    //         target: LifeInsurancePage(
    //       service: searchedService,
    //     ));
    //   } else {
    //     NavigationService.push(
    //         target: NonLifeInsurancePage(
    //       service: searchedService,
    //     ));
    //   }
    // }
    // if (widget.categoryIdentifier == Slugs.governmentPayment) {
    //   if (serviceIdentifier.toLowerCase() ==
    //       "traffic_fine_payments".toLowerCase()) {
    //     NavigationService.push(
    //         target: TrafficFinePaymentPage(
    //       service: searchedService,
    //     ));
    //   } else if (serviceIdentifier.toLowerCase() ==
    //       Slugs.bluebookRenewal.toLowerCase()) {
    //     NavigationService.push(
    //         target: BlueBookRenewalPage(
    //       service: searchedService,
    //     ));
    //   } else {
    //     NavigationService.push(
    //         target: GovernmentPaymentPage(
    //       services: searchedService,
    //     ));
    //   }
    // }
  }
}
