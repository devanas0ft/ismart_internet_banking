import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_api_provider.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class InternalTransferRepository {
  final UserRepository userRepository;
  final CoOperative env;
  final ApiProvider apiProvider;
  late InternalTransferAPIProvider internalTransferAPIProvider;

  InternalTransferRepository({
    required this.userRepository,
    required this.env,
    required this.apiProvider,
  }) {
    internalTransferAPIProvider = InternalTransferAPIProvider(
      apiProvider: apiProvider,
      baseUrl: env.baseUrl,
      userRepository: userRepository,
    );
  }

  Future<DataResponse<List<InternalBranch>>> getBranchList() async {
    List<InternalBranch> _banksList = [];
    try {
      final _res = await internalTransferAPIProvider.getBranchList(
        cooperativeClientCode: env.clientCode,
      );
      final _result = Map<String, dynamic>.from(_res);
      if (_result['data']['details'] != null) {
        List.from(_result['data']['details']).forEach((element) {
          InternalBranch _bank = InternalBranch.fromJson(element);
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

  // Future<DataResponse<String>> getBankCharges({
  //   required String amount,
  //   required String bankId,
  // }) async {
  //   List<Bank> _banksList = [];
  //   try {
  //     final _res = await internalTransferAPIProvider.getBankCharges(
  //       bankId: bankId,
  //       amount: amount,
  //     );
  //     final _result = Map<String, dynamic>.from(_res);
  //     if (_result['data']['details'] != null) {
  //       return DataResponse.success(
  //           (_result['data']['details'] ?? "").toString());
  //     } else {
  //       return DataResponse.error("Error fetching balance data.");
  //     }
  //   } on CustomException catch (e) {
  //     if (e is SessionExpireErrorException) {
  //       rethrow;
  //     }
  //     return DataResponse.error(e.message!, e.statusCode);
  //   } catch (e) {
  //     return DataResponse.error(e.toString());
  //   }
  // }

  Future<DataResponse<UtilityResponseData>> fundTranfer({
    required String mpin,
    required String amount,
    required String remarks,
    required String receivingAccount,
    required String sendingAccount,
    required String receivingBranchId,
  }) async {
    Map<String, dynamic> sendToBankPayload = {
      "amount": amount,
      "from_account_number": sendingAccount,
      "to_account_number": receivingAccount,
      "bank_branch_id": receivingBranchId,
      "mPin": mpin,
      "remarks": remarks,
      // "account_number": sendingAccount,
    };

    try {
      final _res = await internalTransferAPIProvider.internalFundTransfer(
        payloadData: sendToBankPayload,
      );
      final _result = Map<String, dynamic>.from(_res['data'] ?? {});
      UtilityResponseData _response = UtilityResponseData.fromJson(_result);
      // if (_result['data']?['message'] != null &&
      //     _result['data']?['code'] == "M0000") {
      //   return DataResponse.success(
      //       _result['data']?['message'] ?? "Fund transfer success.");
      // } else {
      //   return DataResponse.error(_result['data']?['message'] ??
      //       "Error while sending money. Please try again.");
      // }
      NavigationService.context
          .read<CustomerDetailCubit>()
          .fetchCustomerDetail();
      return DataResponse.success(_response);
    } on CustomException catch (e) {
      if (e is SessionExpireErrorException) {
        rethrow;
      }
      // if (e.statusCode == 400) {
      //   return DataResponse.error(
      //       "User validation error. Please recheck details.", e.statusCode);
      // }
      if (e.statusCode == 409) {
        return DataResponse.error(
          "Invalid account. Please contact bank for more information. Please, Try again later",
          e.statusCode,
        );
      }
      return DataResponse.error(e.message!, e.statusCode);
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }
}
