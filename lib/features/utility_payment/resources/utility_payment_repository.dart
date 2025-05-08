import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_api_provider.dart';

class UtilityPaymentRepository {
  ApiProvider apiProvider;
  late UtilityPaymentAPIProvider utilityPaymentAPIProvider;
  UserRepository userRepository;
  CustomerDetailRepository customerDetailRepository;
  CoOperative env;

  UtilityPaymentRepository({
    required this.env,
    required this.userRepository,
    required this.apiProvider,
    required this.customerDetailRepository,
  }) {
    utilityPaymentAPIProvider = UtilityPaymentAPIProvider(
      baseUrl: env.baseUrl,
      apiProvider: apiProvider,
      userRepository: userRepository,
      coOperative: env,
    );
  }

  final String _myQrCode = "";

  String get myQrCode => _myQrCode;

  Future<DataResponse<UtilityResponseData>> getTopup({
    required String serviceIdentifier,
    required String phoneNumber,
    required String amount,
    required String mpin,
  }) async {
    try {
      final _res = await utilityPaymentAPIProvider.getTopup(
        serviceIdentifier: serviceIdentifier,
        accountNumber:
            customerDetailRepository.selectedAccount.value?.accountNumber ?? "",
        phoneNumber: phoneNumber,
        amount: amount,
        mpin: mpin,
      );
      Map<String, dynamic> _utilityResponseRaw = Map.from(_res['data'] ?? {});
      if (_utilityResponseRaw.isEmpty) {
        return DataResponse.error(
          "Error while performing transaction. Please try again later",
        );
      }

      UtilityResponseData _utilityResponse = UtilityResponseData.fromJson(
        _utilityResponseRaw,
      );
      return DataResponse.success(_utilityResponse);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<UtilityResponseData>> fetchDetails({
    Map<String, dynamic>? extraHeaders,
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required String apiEndpoint,
  }) async {
    try {
      final _res = await utilityPaymentAPIProvider.fetchDetails(
        serviceIdentifier: serviceIdentifier,
        accountDetails: accountDetails,
        apiEndpoint: apiEndpoint,
        extraHeaders: extraHeaders,
      );

      UtilityResponseData _responseData = UtilityResponseData.fromJson(
        _res['data'] ?? {},
      );
      print(_responseData);
      return DataResponse.success(_responseData);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  /* For details fetch using post method */
  Future<DataResponse<UtilityResponseData>> fetchDetailsPost({
    Map<String, dynamic>? extraHeaders,
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required String apiEndpoint,
  }) async {
    try {
      final _res = await utilityPaymentAPIProvider.fetchDetailsPost(
        serviceIdentifier: serviceIdentifier,
        accountDetails: accountDetails,
        apiEndpoint: apiEndpoint,
        extraHeaders: extraHeaders,
      );

      UtilityResponseData _responseData = UtilityResponseData.fromJson(
        _res['data'] ?? {},
      );
      print(_responseData);
      return DataResponse.success(_responseData);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  // Future<DataResponse<BusDetailModel>> fetchBusDetails({
  //   required String serviceIdentifier,
  //   required Map<String, dynamic> accountDetails,
  //   required String apiEndpoint,
  // }) async {
  //   try {
  //     final _res = await utilityPaymentAPIProvider.fetchDetails(
  //       serviceIdentifier: serviceIdentifier,
  //       accountDetails: accountDetails,
  //       apiEndpoint: apiEndpoint,
  //     );

  //     BusDetailModel _responseData = BusDetailModel.fromJson(
  //       _res['details'] ?? {},
  //     );
  //     print(_responseData);
  //     return DataResponse.success(_responseData);
  //   } on CustomException catch (e) {
  //     if (e is SessionExpireErrorException) {
  //       rethrow;
  //     }
  //     return DataResponse.error(e.message, e.statusCode);
  //   } catch (e) {
  //     return DataResponse.error(e.toString());
  //   }
  // }

  // Future<DataResponse<NotificationModel>> fetchNotification() async {
  //   try {
  //     final _res = await utilityPaymentAPIProvider.fetchDetails(
  //       serviceIdentifier: "",
  //       accountDetails: {},
  //       apiEndpoint: "/api/notifications",
  //     );

  //     NotificationModel _responseData = NotificationModel.fromJson(
  //       _res['data'] ?? {},
  //     );
  //     print(_responseData);
  //     return DataResponse.success(_responseData);
  //   } on CustomException catch (e) {
  //     if (e is SessionExpireErrorException) {
  //       rethrow;
  //     }
  //     return DataResponse.error(e.message, e.statusCode);
  //   } catch (e) {
  //     return DataResponse.error(e.toString());
  //   }
  // }

  Future<DataResponse<UtilityResponseData>> makePayment({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required Map<String, dynamic> body,
    required String apiEndpoint,
    required mPin,
  }) async {
    try {
      final _res = await utilityPaymentAPIProvider.makePayment(
        mPin: mPin,
        serviceIdentifier: serviceIdentifier,
        accountDetails: accountDetails,
        apiEndpoint: apiEndpoint,
        body: body,
      );

      UtilityResponseData _responseData = UtilityResponseData.fromJson(
        _res['data'] ?? {},
      );
      print(_responseData);
      NavigationService.context
          .read<CustomerDetailCubit>()
          .fetchCustomerDetail();
      return DataResponse.success(_responseData);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<UtilityResponseData>> deleteReq({
    required String serviceIdentifier,
    required Map<String, dynamic> accountDetails,
    required String apiEndpoint,
    required mPin,
  }) async {
    try {
      final _res = await utilityPaymentAPIProvider.deleteReq(
        mPin: mPin,
        serviceIdentifier: serviceIdentifier,
        accountDetails: accountDetails,
        apiEndpoint: apiEndpoint,
      );
      UtilityResponseData _responseData = UtilityResponseData.fromJson(
        _res['data'] ?? {},
      );
      print(_responseData);
      NavigationService.context
          .read<CustomerDetailCubit>()
          .fetchCustomerDetail();
      return DataResponse.success(_responseData);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<String>> getCharges({
    required Map<String, dynamic> accountDetails,
    required String apiEndpoint,
  }) async {
    try {
      final _res = await utilityPaymentAPIProvider.getCharges(
        accountDetails: accountDetails,
        apiEndpoint: apiEndpoint,
      );

      if (_res['data']?['code'] == "M0000") {
        final _result = Map<String, dynamic>.from(_res);
        if (_result['data']['details'] != null) {
          return DataResponse.success(
            (_result['data']['details'] ?? "").toString(),
          );
        } else {
          return DataResponse.error("Error fetching balance data.");
        }
      } else {
        return DataResponse.error("message");
      }
    } on CustomException catch (e) {
      print(e);
      // if (e is SessionExpireErrorException) {
      //   rethrow;
      // }
      return DataResponse.error(e.message!, e.statusCode);
    } on DioError catch (dio) {
      print(dio);
      return DataResponse.error("message");
    } catch (e) {
      print(e);
      return DataResponse.error(e.toString());
    }
  }
}
