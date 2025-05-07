import 'package:ismart_web/common/constants/env.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/utils/hive_utils.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/Dahboard/widgets/homePageTabbar/resources/category_api_provider.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class CategoryRepository {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final UserRepository userRepository;

  late CategoryApiProvider categoryApiProvider;

  CategoryRepository({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  }) {
    categoryApiProvider = CategoryApiProvider(
      apiProvider: apiProvider,
      baseUrl: coOperative.baseUrl,
      coOperative: coOperative,
      userRepository: userRepository,
    );
  }
  Future<DataResponse<List<CategoryList>>> getCategoryList() async {
    List<CategoryList> _allServices = [];
    try {
      final _res = await categoryApiProvider.fetchServices();

      if (_res['data']['details'] != null) {
        final List _userMap = List.from(_res["data"]['details'] ?? []);

        if (_userMap.isEmpty) {
          return DataResponse.error("Error fetching data.");
        }

        _userMap.forEach((element) {
          CategoryList _serviceList = CategoryList.fromJson(element);
          final List<ServiceList> _dummyList = [];
          final Set<String> _uniqueID = {};
          _serviceList.services.forEach((element) {
            _uniqueID.add(element.uniqueIdentifier);
          });

          _uniqueID.forEach((uniqEelement) {
            final ServiceList _singleValue = _serviceList.services.firstWhere(
              (elementService) =>
                  uniqEelement == elementService.uniqueIdentifier,
            );
            _dummyList.add(_singleValue);
          });
          _serviceList = _serviceList.copyWith(_dummyList);
          _allServices.add(_serviceList);
        });

        final _ = await ServiceHiveUtils.setUtilitiesServices(
          item: _allServices,
          slug: "wallet_service",
        );

        return DataResponse.success(_allServices);
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
