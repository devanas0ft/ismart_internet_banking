import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/statement/fullStatement/model/full_statement_model.dart';
import 'package:ismart_web/features/statement/fullStatement/resources/full_statement_api_provider.dart';

class FullStatementRepository {
  final ApiProvider apiProvider;
  late FullStatementAPIProvider fullStatementAPIProvider;
  final CoOperative coOperative;
  final UserRepository userRepository;

  FullStatementRepository({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  }) {
    fullStatementAPIProvider = FullStatementAPIProvider(
      apiProvider: apiProvider,
      baseUrl: coOperative.baseUrl,
      coOperative: coOperative,
      userRepository: userRepository,
    );
  }

  FullStatementModel? fullStatement;
  final List<AccountStatementDtos> _statementsLists = [];

  List<AccountStatementDtos> getGraphData({required int days}) {
    _statementsLists.clear();
    if (fullStatement == null) return _statementsLists;
    // final _startDate = DateTime(2022, 9, 1);
    // final _endDate = _startDate.add(Duration(days: days));

    // fullStatement!.accountStatementDtos.forEach((element) {
    //   if (element.transactionDate.isBefore(_endDate) &&
    //       element.transactionDate.isAfter(_startDate)) {
    //     _statementsLists.add(element);
    //     print(element.balance);
    //   }
    // });
    return _statementsLists;
  }

  Future<DataResponse<FullStatementModel>> getFullStatement({
    required String accountNumber,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final _res = await fullStatementAPIProvider.fetchFullStatement(
        accountNumber: accountNumber,
        fromDate: fromDate,
        toDate: toDate,
      );
      print(_res.toString());

      if (_res['data']['details'] != null) {
        final Map<String, dynamic> _userMap = Map<String, dynamic>.from(
          _res['data']?['details'] ?? {},
        );

        if (_userMap.isEmpty) {
          return DataResponse.error("Error fetching data.");
        }
        fullStatement = FullStatementModel.fromJson(_userMap);

        return DataResponse.success(fullStatement);
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
}
