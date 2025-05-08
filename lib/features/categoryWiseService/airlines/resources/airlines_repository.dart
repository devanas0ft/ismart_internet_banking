// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/http/api_provider.dart';
// import 'package:ismart/common/http/custom_exception.dart';
// import 'package:ismart/common/http/response.dart';
// import 'package:ismart/feature/authentication/resource/user_repository.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_sector_model.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/resources/airlines_api_provider.dart';

// class AirlinesRepository {
//   final ApiProvider apiProvider;
//   late AirlinesAPIProvider airlinesAPIProvider;
//   final CoOperative coOperative;
//   final UserRepository userRepository;

//   AirlinesRepository({
//     required this.apiProvider,
//     required this.coOperative,
//     required this.userRepository,
//   }) {
//     airlinesAPIProvider = AirlinesAPIProvider(
//       apiProvider: apiProvider,
//       baseUrl: coOperative.baseUrl,
//       coOperative: coOperative,
//       userRepository: userRepository,
//     );
//   }
//   List<AirlinesSectorList> airlinesSector = [];

//   Future<DataResponse<List<AirlinesSectorList>>> getAirlinesLocation() async {
//     try {
//       final _res = await airlinesAPIProvider.fetchAFlightLoaction();

//       if (_res['data']['detail'] != null) {
//         // Parse Data from API

//         final List _userMap = List.from(_res["data"]['detail'] ?? []);

//         if (_userMap.isEmpty) {
//           return DataResponse.error("Error fetching data.");
//         }

//         airlinesSector.clear();

//         _userMap.forEach((element) {
//           AirlinesSectorList _txn = AirlinesSectorList.fromJson(element);

//           airlinesSector.add(_txn);
//         });

//         return DataResponse.success(airlinesSector);
//       } else {
//         return DataResponse.error("error message");
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

//   Future<DataResponse<SearchFlightResponse>> fetchFlights({
//     required Map<String, dynamic> accountDetails,
//     required Map<String, dynamic> body,
//   }) async {
//     try {
//       final _res = await airlinesAPIProvider.fetchFlightList(
//         accountDetails: accountDetails,
//         body: body,
//       );

//       print("ranjan dhakal ${_res['data']}");
//       SearchFlightResponse _responseData =
//           SearchFlightResponse.fromJson(_res['data'] ?? {});
//       print(_responseData.toJson());
//       return DataResponse.success(_responseData);
//     } on CustomException catch (e) {
//       print(e);
//       if (e is SessionExpireErrorException) {
//         rethrow;
//       }
//       return DataResponse.error(e.toString(), e.statusCode);
//     } catch (e) {
//       print(e);
//       return DataResponse.error(e.toString());
//     }
//   }
// }
