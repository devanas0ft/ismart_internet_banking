import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/http/custom_exception.dart';
import 'package:ismart_web/common/http/response.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/model/movie_seat_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/model/movie_seat_select_model.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_api_provider.dart';

class MovieRepository {
  ApiProvider apiProvider;
  late UtilityPaymentAPIProvider utilityPaymentAPIProvider;
  UserRepository userRepository;
  CoOperative env;

  MovieRepository({
    required this.env,
    required this.userRepository,
    required this.apiProvider,
  }) {
    utilityPaymentAPIProvider = UtilityPaymentAPIProvider(
      baseUrl: env.baseUrl,
      apiProvider: apiProvider,
      userRepository: userRepository,
      coOperative: env,
    );
  }

  Future<DataResponse<MovieSeatModel>> fetchMovieSeats({
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

      final MovieSeatModel _responseData = MovieSeatModel.fromJson(
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

  Future<DataResponse<MovieSeatSelectModel>> selectSeats({
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

      final MovieSeatSelectModel _responseData = MovieSeatSelectModel.fromJson(
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

  Future<DataResponse<MovieSeatUnSelectModel>> unSelectSeats({
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

      final MovieSeatUnSelectModel _responseData =
          MovieSeatUnSelectModel.fromJson(_res['data'] ?? {});
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
}
