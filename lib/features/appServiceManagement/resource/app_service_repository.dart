import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/hive_utils.dart';
import 'package:ismart_web/features/appServiceManagement/model/app_service_management_model.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_api_provider.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class AppServiceRepository {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final UserRepository userRepository;

  late AppServiceApiProvider appServiceApiProvider;

  AppServiceRepository({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  }) {
    appServiceApiProvider = AppServiceApiProvider(
      apiProvider: apiProvider,
      baseUrl: coOperative.baseUrl,
      coOperative: coOperative,
      userRepository: userRepository,
    );
  }
  List<AppServiceManagementModel> appService = [];
  Future<DataResponse<List<AppServiceManagementModel>>> getAppService() async {
    final List<AppServiceManagementModel> _appServiceList = [];
    try {
      final _res = await appServiceApiProvider.fetchAppService();

      if (_res['data']['details'] != null) {
        // Parse Data from API

        final List _userMap = List.from(_res["data"]['details'] ?? []);

        if (_userMap.isEmpty) {
          return DataResponse.error("Error fetching dat.");
        }

        _userMap.forEach((element) {
          final AppServiceManagementModel _txn =
              AppServiceManagementModel.fromJson(element);

          _appServiceList.add(_txn);
        });
        final _ = await ServiceHiveUtils.setAppService(
          item: _appServiceList,
          slug: "app_service",
        );
        appService = _appServiceList;
        return DataResponse.success(_appServiceList);
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
}
