import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
import 'package:ismart_web/features/sendMoney/models/bank.dart';
import 'package:ismart_web/features/sendMoney/resources/send_to_bank_api_provider.dart';

class SendToBankRepository {
  final UserRepository userRepository;
  final CoOperative env;
  final ApiProvider apiProvider;
  late SendToBankAPIProvider sendToBankAPIProvider;

  SendToBankRepository({
    required this.userRepository,
    required this.env,
    required this.apiProvider,
  }) {
    sendToBankAPIProvider = SendToBankAPIProvider(
      apiProvider: apiProvider,
      baseUrl: env.baseUrl,
      userRepository: userRepository,
    );
  }

  Future<DataResponse<List<Bank>>> getBanksList() async {
    final List<Bank> _banksList = [];
    try {
      final _res = await sendToBankAPIProvider.getBanksList();
      final _result = Map<String, dynamic>.from(_res);
      if (_result['data']['details'] != null) {
        List.from(_result['data']['details']).forEach((element) {
          final Bank _bank = Bank.fromJson(element);
          _banksList.add(_bank);
        });
        return DataResponse.success(_banksList);
      } else {
        return DataResponse.error("Error fetching balance data.");
      }
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      return DataResponse.error(e.message!, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<String>> getBankCharges({
    required String amount,
    required String bankId,
    required String destinationBankInstrumentCode,
    required String destinationBankAccountName,
    required String destinationBankAccountNumber,
  }) async {
    final Map<String, dynamic> accountValidationPayload = {
      "destinationBankId": destinationBankInstrumentCode,
      "destinationAccountName": destinationBankAccountName,
      "destinationAccountNumber": destinationBankAccountNumber,
    };
    try {
      final _res = await sendToBankAPIProvider.accountValidation(
        payloadData: accountValidationPayload,
      );

      if (_res['data']?['code'] == "M0000") {
        final _res = await sendToBankAPIProvider.getBankCharges(
          bankId: bankId,
          amount: amount,
        );
        final _result = Map<String, dynamic>.from(_res);
        if (_result['data']['details'] != null) {
          return DataResponse.success(
            (_result['data']['details'] ?? "").toString(),
          );
        } else {
          return DataResponse.error("Error fetching balance data.");
        }
      } else {
        return DataResponse.error("Bank account validation failed.");
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

  Future<DataResponse<String>> sendMoneyToBank({
    required String mpin,
    required String amount,
    required String remarks,
    required String destinationBankName,
    required String destinationBankInstrumentCode,
    required String destinationBankAccountName,
    required String destinationBankAccountNumber,
    required String serviceCharge,
    required String sendingAccount,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> sendToBankPayload = {
        // "account_number": "00100101000002886000001",
        // "account_number": "002001-001-102-0001010",
        "account_number": sendingAccount,

        "amount": amount,
        "charge": serviceCharge,
        "destination_bank_id": destinationBankInstrumentCode,
        "destination_bank_name": destinationBankName,
        "destination_branch_id": "1",
        "destination_branch_name": "",
        "destination_name": destinationBankAccountName,
        "destination_account_number": destinationBankAccountNumber,
        "scheme_id": "1",
        "remarks": remarks,
        "mPin": mpin,
        "skipValidation": true,
        "otp": otp,
      };

      try {
        final _res = await sendToBankAPIProvider.sendMoneyToBank(
          payloadData: sendToBankPayload,
        );
        NavigationService.context
            .read<CustomerDetailCubit>()
            .fetchCustomerDetail();
        final _result = Map<String, dynamic>.from(_res);
        if (_result['data']?['code'] != "M0000") {
          return DataResponse.error(
            _result['data']?['message'] ?? "Error sending money to bank.",
          );
        }
        if (_result['data']?['detail'] != null) {
          return DataResponse.success(
            _result['data']?['detail']["transactionIdentifier"],
          );
        } else {
          if (_result['data']?['code'] == "M0004") {
            return DataResponse.error(_result['data']?['message'] ?? "");
          }
          return DataResponse.error(
            "Error while sending money. Please try again.",
          );
        }
      } on CustomException catch (e) {
        if (e is SessionExpireErrorException) {
          rethrow;
        }

        return DataResponse.error(e.message!, e.statusCode);
      } catch (e) {
        return DataResponse.error(e.toString());
      }
    } on Exception {
      return DataResponse.error(
        "Bank validation failed. Please check your account details",
      );
    }
  }
}

//   Future<DataResponse<String>> sendMoneyToBank({
//     required String mpin,
//     required String amount,
//     required String remarks,
//     required String destinationBankName,
//     required String destinationBankInstrumentCode,
//     required String destinationBankAccountName,
//     required String destinationBankAccountNumber,
//     required String serviceCharge,
//     required String sendingAccount,
//   }) async {
//     try {
//       Map<String, dynamic> sendToBankPayload = {
//         // "account_number": "00100101000002886000001",
//         // "account_number": "002001-001-102-0001010",
//         "account_number": sendingAccount,

//         "amount": amount,
//         "charge": serviceCharge,
//         "destination_bank_id": destinationBankInstrumentCode,
//         "destination_bank_name": destinationBankName,
//         "destination_branch_id": "1",
//         "destination_branch_name": "",
//         "destination_name": destinationBankAccountName,
//         "destination_account_number": destinationBankAccountNumber,
//         "scheme_id": "1",
//         "remarks": remarks,
//         "mPin": mpin,
//         "skipValidation": true,
//       };

//       try {
//         final _res = await sendToBankAPIProvider.sendMoneyToBank(
//           payloadData: sendToBankPayload,
//         );
//         UtilityResponseData _responseData =
//             UtilityResponseData.fromJson(_res['data'] ?? {});
//         print(_responseData);
//         return DataResponse.success(_responseData);
//       } on CustomException catch (e) {
//         if (e is SessionExpireErrorException) {
//           rethrow;
//         }

//         return DataResponse.error(e.message!, e.statusCode);
//       } catch (e) {
//         return DataResponse.error(e.toString());
//       }
//     } on Exception {
//       return DataResponse.error(
//           "Bank validation failed. Please check your account details");
//     }
//   }
// }
// import 'package:dio/dio.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/http/api_provider.dart';
// import 'package:ismart/common/http/custom_exception.dart';
// import 'package:ismart/common/http/response.dart';
// import 'package:ismart/feature/authentication/resource/user_repository.dart';
// import 'package:ismart/feature/sendMoney/models/bank.dart';
// import 'package:ismart/feature/sendMoney/resources/send_to_bank_api_provider.dart';

// class SendToBankRepository {
//   final UserRepository userRepository;
//   final CoOperative env;
//   final ApiProvider apiProvider;
//   late SendToBankAPIProvider sendToBankAPIProvider;

//   SendToBankRepository({
//     required this.userRepository,
//     required this.env,
//     required this.apiProvider,
//   }) {
//     sendToBankAPIProvider = SendToBankAPIProvider(
//       apiProvider: apiProvider,
//       baseUrl: env.baseUrl,
//       userRepository: userRepository,
//     );
//   }

//   Future<DataResponse<List<Bank>>> getBanksList() async {
//     List<Bank> _banksList = [];
//     try {
//       final _res = await sendToBankAPIProvider.getBanksList();
//       final _result = Map<String, dynamic>.from(_res);
//       if (_result['data']['details'] != null) {
//         List.from(_result['data']['details']).forEach((element) {
//           Bank _bank = Bank.fromJson(element);
//           _banksList.add(_bank);
//         });
//         return DataResponse.success(_banksList);
//       } else {
//         return DataResponse.error("Error fetching balance data.");
//       }
//     } on CustomException catch (e) {
//       if (e is SessionExpireErrorException) {
//         rethrow;
//       }
//       return DataResponse.error(e.message!, e.statusCode);
//     } catch (e) {
//       return DataResponse.error(e.toString());
//     }
//   }

//   Future<DataResponse<String>> getBankCharges({
//     required String amount,
//     required String bankId,
//     required String destinationBankInstrumentCode,
//     required String destinationBankAccountName,
//     required String destinationBankAccountNumber,
//   }) async {
//     Map<String, dynamic> accountValidationPayload = {
//       "destinationBankId": destinationBankInstrumentCode,
//       "destinationAccountName": destinationBankAccountName,
//       "destinationAccountNumber": destinationBankAccountNumber,
//     };
//     try {
//       final _res = await sendToBankAPIProvider.accountValidation(
//           payloadData: accountValidationPayload);

//       if (_res['data']?['code'] == "M0000") {
//         final _res = await sendToBankAPIProvider.getBankCharges(
//           bankId: bankId,
//           amount: amount,
//         );
//         final _result = Map<String, dynamic>.from(_res);
//         if (_result['data']['details'] != null) {
//           return DataResponse.success(
//               (_result['data']['details'] ?? "").toString());
//         } else {
//           return DataResponse.error("Error fetching balance data.");
//         }
//       } else {
//         return DataResponse.error("Bank account validation failed.");
//       }
//     } on CustomException catch (e) {
//       print(e);
//       // if (e is SessionExpireErrorException) {
//       //   rethrow;
//       // }
//       return DataResponse.error(e.message!, e.statusCode);
//     } on DioError catch (dio) {
//       print(dio);
//       return DataResponse.error("message");
//     } catch (e) {
//       print(e);
//       return DataResponse.error(e.toString());
//     }
//   }

//   Future<DataResponse<String>> sendMoneyToBank({
//     required String mpin,
//     required String amount,
//     required String remarks,
//     required String destinationBankName,
//     required String destinationBankInstrumentCode,
//     required String destinationBankAccountName,
//     required String destinationBankAccountNumber,
//     required String serviceCharge,
//     required String sendingAccount,
//   }) async {
//     try {
//       Map<String, dynamic> sendToBankPayload = {
//         // "account_number": "00100101000002886000001",
//         // "account_number": "002001-001-102-0001010",
//         "account_number": sendingAccount,

//         "amount": amount,
//         "charge": serviceCharge,
//         "destination_bank_id": destinationBankInstrumentCode,
//         "destination_bank_name": destinationBankName,
//         "destination_branch_id": "1",
//         "destination_branch_name": "",
//         "destination_name": destinationBankAccountName,
//         "destination_account_number": destinationBankAccountNumber,
//         "scheme_id": "1",
//         "remarks": remarks,
//         "mPin": mpin,
//         "skipValidation": true,
//       };

//       try {
//         final _res = await sendToBankAPIProvider.sendMoneyToBank(
//           payloadData: sendToBankPayload,
//         );
//         final _result = Map<String, dynamic>.from(_res);
//         if (_result['data']?['details'] != null) {
//           return DataResponse.success(_result['data']?['details']);
//         } else {
//           return DataResponse.error(
//               "Error while sending money. Please try again.");
//         }
//       } on CustomException catch (e) {
//         if (e is SessionExpireErrorException) {
//           rethrow;
//         }

//         return DataResponse.error(e.message!, e.statusCode);
//       } catch (e) {
//         return DataResponse.error(e.toString());
//       }
//     } on Exception {
//       return DataResponse.error(
//           "Bank validation failed. Please check your account details");
//     }
//   }
// }
