import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/constants/slugs.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/cubit/category_cubit.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/Topup/ui/screens/mobile_topup_page.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/screen/airline_page.dart';
import 'package:ismart_web/features/categoryWiseService/broker/screen/broker_payment_page.dart';
import 'package:ismart_web/features/categoryWiseService/movie/screen/movie_page.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  List<CategoryList> _categoryList = [];
  bool _isInitialized = false;

  CategoryList? categoryList;

  List<ServiceList> selectedService = [];
  List<ServiceList> getTopupType(String phoneNumber) {
    if (phoneNumber.startsWith("+977")) {
      phoneNumber = phoneNumber.substring(4);
    }

    final String firstThreeDigits = phoneNumber.substring(0, 3);

    final List<ServiceList> services = categoryList!.services;

    final List<ServiceList> filteredServices =
        services.where((service) {
          final List<String> prefixes = service.labelPrefix.split(',');
          return prefixes.any((prefix) => prefix == firstThreeDigits);
        }).toList();
    selectedService = filteredServices;
    return filteredServices;
  }

  Future<void> initialize(BuildContext context) async {
    if (!_isInitialized) {
      await context.read<CategoryCubit>().fetchCategory();
      _isInitialized = true;
    }
  }

  void updateCategoryList(List<CategoryList> categories) {
    _categoryList = categories;
    _isInitialized = true;
  }

  CategoryList? getCategoryByIdentifier(String identifier) {
    try {
      return _categoryList.firstWhere(
        (category) =>
            category.uniqueIdentifier.toLowerCase() == identifier.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // void navigateToMobileTopup(BuildContext context) {
  //   final category = getCategoryByIdentifier(Slugs.topup);
  //   if (category != null) {
  //     NavigationService.push(target: MobileTopupPage(categoryList: category));
  //   }
  // }

  void navigateToMobileTopup(BuildContext context) {
    try {
      final topupCategory = _categoryList.firstWhere(
        (category) =>
            category.uniqueIdentifier.toLowerCase() ==
            Slugs.topup.toLowerCase(),
      );
      NavigationService.push(
        target: MobileTopupPage(categoryList: topupCategory),
      );
    } catch (e) {
      print("No service availbale : $e");
    }
  }

  void topupWithAmount(
    BuildContext context,
    String amount,
    String mobileNumber,
  ) {
    try {
      final topupCategory = _categoryList.firstWhere(
        (category) =>
            category.uniqueIdentifier.toLowerCase() ==
            Slugs.topup.toLowerCase(),
      );
      categoryList = topupCategory;
      getTopupType(mobileNumber);
      NavigationService.push(
        target: CommonBillDetailPage(
          verificationAmount: amount,
          serviceName: selectedService.first.service,
          service: getTopupType(mobileNumber).first,
          apiBody: const {},
          serviceIdentifier: getTopupType(mobileNumber).first.uniqueIdentifier,
          accountDetails: {
            "account_number":
                RepositoryProvider.of<CustomerDetailRepository>(
                  context,
                ).selectedAccount.value!.accountNumber,
            "phone_number": mobileNumber,
            "amount": amount,
          },
          apiEndpoint: "/api/topup",
          body: Column(
            children: [
              KeyValueTile(title: "Target Number", value: mobileNumber),
              KeyValueTile(title: "Amount", value: amount),
            ],
          ),
        ),
      );
    } catch (e) {
      print("No service available: $e");
    }
  }

  void navigateToBrokerPayment(BuildContext context) {
    try {
      final category = _categoryList.firstWhere(
        (category) =>
            category.uniqueIdentifier.toLowerCase() ==
            Slugs.brokerPage.toLowerCase(),
      );
      NavigationService.push(
        target: BrokerPaymentPage(service: category.services.first),
      );
    } catch (e) {
      print("No service available: $e");
    }
  }

  void navigateToElectricityPayment(BuildContext context) {
    try {
      final category = _categoryList.firstWhere(
        (category) => category.uniqueIdentifier.toLowerCase() == "electricity",
      );

      // NavigationService.push(
      //   target: ElectricityPaymentPage(service: category.services[0]),
      // );
    } catch (e) {
      print("No service available: $e");
    }
  }

  void navigateToAirlines(BuildContext context) {
    try {
      final category = _categoryList.firstWhere(
        (category) => category.uniqueIdentifier.toLowerCase() == "airlines",
      );
      NavigationService.push(
        target: AirlinesIntroPage(service: category.services[0]),
      );
    } catch (e) {
      print("No service available: $e");
    }
  }

  void navigateToMovie(BuildContext context) {
    try {
      final category = _categoryList.firstWhere(
        (category) => category.uniqueIdentifier.toLowerCase() == "movies",
      );
      NavigationService.push(target: MoviePage(category: category));
    } catch (e) {
      print("No service available: $e");
    }
  }

  void navigateToLandline(BuildContext context) {
    try {
      final category = _categoryList.firstWhere(
        (category) =>
            category.uniqueIdentifier.toLowerCase() == "landline" ||
            category.uniqueIdentifier.toString().toLowerCase() ==
                "category".toLowerCase(),
      );

      // NavigationService.push(target: LandlinePaymentPage(category: category));
    } catch (e) {
      print("No service available: $e");
    }
  }

  void navigateToBusBooking(BuildContext context) {
    try {
      final category = _categoryList.firstWhere(
        (category) =>
            category.uniqueIdentifier.toLowerCase() == Slugs.busTicket,
      );

      // NavigationService.push(
      //   target: BusBookingPage(service: category.services.first),
      // );
    } catch (e) {
      print("No service available: $e");
    }
  }

  void navigateToBusBooking2(
    BuildContext context,
    UtilityResponseData response,
    String from,
    String to,
    String date,
  ) {
    try {
      final category = _categoryList.firstWhere(
        (category) =>
            category.uniqueIdentifier.toLowerCase() == Slugs.busTicket,
      );

      // NavigationService.push(
      //   target: AvailableBusPage(
      //     response: response,
      //     service: category.services.first,
      //     busModel: BusTopBarModel(
      //       sectorFrom: from,
      //       sectorTo: to,
      //       selectedDate: date,
      //     ),
      //   ),
      // );
    } catch (e) {
      print("No service available: $e");
    }
  }

  // void navigateToService(BuildContext context, String identifier) {
  //   final category = getCategoryByIdentifier(identifier);
  //   if (category != null) {
  //     NavigationService.push(
  //       target: CategoriesWiseServicePage(
  //         uniqueIdentifier: category.uniqueIdentifier,
  //         services: category.services,
  //         topBarName: category.name,
  //       ),
  //     );
  //   }
  // }
}
