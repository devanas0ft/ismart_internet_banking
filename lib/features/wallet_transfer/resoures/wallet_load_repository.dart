import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/utils/hive_utils.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/wallet_transfer/model/wallet_model.dart';
import 'package:ismart_web/features/wallet_transfer/model/wallet_transfer_model.dart';
import 'package:ismart_web/features/wallet_transfer/model/wallet_validation_model.dart';
import 'package:ismart_web/features/wallet_transfer/resoures/wallet_load_api_provider.dart';

class WalletLoadRepository {
  final ApiProvider apiProvider;
  late WalletLoadAPIProvider walletLoadAPIProvider;
  final CoOperative coOperative;
  final UserRepository userRepository;

  WalletLoadRepository({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  }) {
    walletLoadAPIProvider = WalletLoadAPIProvider(
      apiProvider: apiProvider,
      baseUrl: coOperative.baseUrl,
      coOperative: coOperative,
      userRepository: userRepository,
    );
  }

  Future<DataResponse<List<WalletModel>>> fetchWalletList() async {
    final List<WalletModel> _allWalletList = [];

    try {
      final _res = await walletLoadAPIProvider.fetchWalletList();

      if (_res['data']['details'] != null) {
        // final List<WalletModel> _walletList = [];
        final List _rawList = List.from(_res['data']?['details'] ?? []);

        _rawList.forEach((element) {
          final WalletModel _wallet = WalletModel.fromJson(element);
          _allWalletList.add(_wallet);
        });
        final _ = await ServiceHiveUtils.setWalletList(
          item: _allWalletList,
          slug: "wallet_list",
        );

        return DataResponse.success(_allWalletList);
      } else {
        return DataResponse.error("error message");
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

  Future<DataResponse<WalletValidationModel>> validateWalletAccount({
    required String walletId,
    required String accountNumber,
    required String amount,
  }) async {
    try {
      final _res = await walletLoadAPIProvider.validateWallet(
        walletId: walletId,
        accountNumber: accountNumber,
        amount: amount,
      );

      if (_res['data']?['detail'] != null) {
        final Map<String, dynamic> _rawResponse = Map<String, dynamic>.from(
          _res['data']?['detail'] ?? {},
        );
        if (_rawResponse.isEmpty) {
          return DataResponse.error("Error while validating wallet");
        }
        final WalletValidationModel _validatedData =
            WalletValidationModel.fromJson(_rawResponse);

        return DataResponse.success(_validatedData);
      } else {
        return DataResponse.error("Error during validation.");
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

  Future<DataResponse<WalletTransferModel>> sendToWallet({
    required String walletId,
    required String amount,
    required String customerName,
    required String walletAccountNumber,
    required String validationIdentifier,
    required String remarks,
    required String mPin,
  }) async {
    try {
      final _res = await walletLoadAPIProvider.sendToWallet(
        mPin: mPin,
        walletId: walletId,
        accountNumber:
            RepositoryProvider.of<CustomerDetailRepository>(
              NavigationService.context,
            ).selectedAccount.value!.accountNumber,
        amount: amount,
        validationIdentifier: validationIdentifier,
        customerName: customerName,
        walletAccountNumber: walletAccountNumber,
        remarks: remarks,
      );
      NavigationService.context
          .read<CustomerDetailCubit>()
          .fetchCustomerDetail();
      if (_res['data'] != null) {
        final Map<String, dynamic> _rawResponse = Map<String, dynamic>.from(
          _res['data'] ?? {},
        );
        if (_rawResponse.isEmpty) {
          return DataResponse.error("Error while loading wallet.");
        }
        final WalletTransferModel _validatedData = WalletTransferModel.fromJson(
          _rawResponse,
        );

        return DataResponse.success(_validatedData);
      } else {
        return DataResponse.error("Error while loading wallet.");
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
}
