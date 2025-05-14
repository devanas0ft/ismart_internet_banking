import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/model/datapack_model.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/resources/datapack_api_provider.dart';

class DatapackRepository {
  final ApiProvider apiProvider;
  final CoOperative coOperative;
  final UserRepository userRepository;

  late DatapackApiProvider datapackApiProvider;

  DatapackRepository({
    required this.apiProvider,
    required this.coOperative,
    required this.userRepository,
  }) {
    datapackApiProvider = DatapackApiProvider(
      apiProvider: apiProvider,
      baseUrl: coOperative.baseUrl,
      coOperative: coOperative,
      userRepository: userRepository,
    );
  }
  Future<DataResponse<List<DataPackPackage>>> getDatapackList(
    serviceIdentifier,
  ) async {
    try {
      final _res = await datapackApiProvider.fetchDatapack(serviceIdentifier);

      if (_res['data']['details']['packages'] != null) {
        // Parse Data from API

        // final List _userMap =
        //     List.from(_res["data"]['details']['packages'] ?? []);

        final _userMap =
            List.from(
              _res['data']['details']['packages'] ?? [],
            ).map((e) => DataPackPackage.fromJson(e)).toList();

        if (_userMap.isEmpty) {
          return DataResponse.error("Error fetching data.");
        }

        return DataResponse.success(_userMap);
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
