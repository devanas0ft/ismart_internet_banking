import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/history/resources/recent_tranasction_api_provider.dart';
import 'package:ismart_web/common/models/coop_config.dart';

class RecentTransactionRepository {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final UserRepository userRepository;

  late RecentTransactionApiProvider recentTransactionApiProvider;

  RecentTransactionRepository({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  }) {
    recentTransactionApiProvider = RecentTransactionApiProvider(
      apiProvider: apiProvider,
      baseUrl: coOperative.baseUrl,
      coOperative: coOperative,
      userRepository: userRepository,
    );
  }
  Future<DataResponse<List<RecentTransactionModel>>> getRecentTransaction({
    required String serviceCategoryId,
    required String associatedId,
    required String serviceId,
    required String fromDate,
    required String toDate,
    required String service,
  }) async {
    final List<RecentTransactionModel> _recentTxnList = [];
    try {
      final _res = await recentTransactionApiProvider.fetchRecentTransaction(
        serviceId: serviceId,
        associatedId: associatedId,
        service: service,
        serviceCategoryId: serviceCategoryId,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (_res['data']['details'] != null) {
        // Parse Data from API

        final List _userMap = List.from(_res["data"]['details'] ?? []);

        if (_userMap.isEmpty) {
          return DataResponse.error("Error fetching data.");
        }

        _userMap.forEach((element) {
          final RecentTransactionModel _txn = RecentTransactionModel.fromJson(
            element,
          );

          _recentTxnList.add(_txn);
        });

        return DataResponse.success(_recentTxnList);
      } else {
        return DataResponse.error("No Transaction");
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

  Future<DataResponse<String>> generateDownloadUrl({
    required String transactionId,
  }) async {
    try {
      final _res = await recentTransactionApiProvider.generateDownloadUrl(
        transactionId: transactionId,
      );

      if (_res['data']?['detail'] != null) {
        // Parse Data from API

        final Map _userMap = Map.from(_res["data"]?['detail'] ?? []);

        if (_userMap['URL'] != null) {
          final String path = _userMap['URL'];

          final String downloadUrl =
              coOperative.baseUrl + path.replaceFirst("/", "");

          return DataResponse.success(downloadUrl);
        }

        return DataResponse.error("Error occurred.");
      } else {
        return DataResponse.error("Error while generating download.");
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
