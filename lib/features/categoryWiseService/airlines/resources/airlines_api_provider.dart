// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/http/api_provider.dart';
// import 'package:ismart/common/util/url_utils.dart';
// import 'package:ismart/feature/authentication/resource/user_repository.dart';

// class AirlinesAPIProvider {
//   final ApiProvider apiProvider;
//   final CoOperative coOperative;
//   final String baseUrl;

//   final UserRepository userRepository;

//   const AirlinesAPIProvider({
//     required this.apiProvider,
//     required this.baseUrl,
//     required this.coOperative,
//     required this.userRepository,
//   });
//   Future<dynamic> fetchAFlightLoaction() async {
//     final _uri = UrlUtils.getUri(
//       url: coOperative.baseUrl + "/api/arssectorcode",
//     );

//     return await apiProvider.post(
//       _uri.toString(),
//       {},
//       token: userRepository.token,
//     );
//   }

//   Future<dynamic> fetchFlightList({
//     required Map<String, dynamic> accountDetails,
//     required Map<String, dynamic> body,
//   }) async {
//     final _uri = UrlUtils.getUri(
//         url: coOperative.baseUrl + "/api/arsflightavailability",
//         params: {
//           "service_identifier": "ARS",
//         });

//     return await apiProvider.post(
//       _uri.toString(),
//       body,
//       token: userRepository.token,
//     );
//   }
// }
