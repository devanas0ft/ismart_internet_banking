import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/service/config_service.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/splash/resource/startup_repository.dart';

part 'startup_state.dart';

class StartupCubit extends Cubit<StartupState> {
  StartupCubit({
    required this.startUpRepository,
    required this.userRepository,
    required this.appServiceRepository,
  }) : super(StartupInitial());

  final AppServiceRepository appServiceRepository;
  final StartUpRepository startUpRepository;
  final UserRepository userRepository;

  Future<void> fetchStartupData() async {
    emit(StartupLoading());

    try {
      // Check if config is initialized
      if (!ConfigService().hasConfig()) {
        emit(StartupError(
          message: "Configuration not loaded. Please restart the app.",
        ));
        return;
      }

      final isFirstTime = await SharedPref.getFirstTimeAppOpen();
      
      // Initialize user state
      await userRepository.initialState();

      // Fetch all startup data in parallel for better performance
      await Future.wait([
        startUpRepository.fetchBannerImages(),
        startUpRepository.fetchAppConfig(),
        startUpRepository.fetchdefaultBannerImages(),
        startUpRepository.getAppService(),
      ]);

      // Set first time flag
      if (isFirstTime) {
        await SharedPref.setFirstTimeAppOpen(false);
      }

      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        StartupSuccess(
          isFirstTime: isFirstTime,
          isLogged: userRepository.isLoggedIn.value,
        ),
      );
    } catch (e) {
      print('Error in fetchStartupData: $e');
      emit(StartupError(
        message: "Failed to load startup data: ${e.toString()}",
      ));
    }
  }

  Future<void> retry() async {
    await fetchStartupData();
  }
}

// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart_web/common/shared_pref.dart';
// import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';
// import 'package:ismart_web/features/auth/resources/user_repository.dart';
// import 'package:ismart_web/features/splash/resource/startup_repository.dart';

// part 'startup_state.dart';

// class StartupCubit extends Cubit<StartupState> {
//   StartupCubit({
//     required this.startUpRepository,
//     required this.userRepository,
//     required this.appServiceRepository,
//     // required bannerRepository,
//     // required this.bannerRepository,
//   }) : super(StartupInitial());
//   final AppServiceRepository appServiceRepository;
//   final StartUpRepository startUpRepository;
//   final UserRepository userRepository;
//   // final BannerRepository bannerRepository;
//   fetchStartupData() async {
//     emit(StartupLoading());
//     final isFirstTime = await SharedPref.getFirstTimeAppOpen();
//     await userRepository.initialState();
//     await startUpRepository.fetchBannerImages();
//     await startUpRepository.fetchAppConfig();
//     await startUpRepository.fetchdefaultBannerImages();
//     await startUpRepository.dynamicCoopConfig();

//     // await bannerRepository.fetchBannerImages(bannerImageType: "OfferBanner");
//     await startUpRepository.getAppService();

//     if (isFirstTime) {
//       await SharedPref.setFirstTimeAppOpen(false);
//     }
//     Future.delayed(const Duration(milliseconds: 800));
//     emit(
//       StartupSuccess(
//         isFirstTime: isFirstTime,
//         isLogged: userRepository.isLoggedIn.value,
//         // isLogged: true,
//       ),
//     );
//   }
// }
