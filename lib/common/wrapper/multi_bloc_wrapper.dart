import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/appServiceManagement/cubit/app_service_cubit.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';
import 'package:ismart_web/features/auth/cubit/login_cubit.dart';
import 'package:ismart_web/features/auth/cubit/validate_co_op_cubit.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/chatBot/resources/audio_upload_repository.dart';
import 'package:ismart_web/features/chatBot/resources/cubits/audio_upload_cubit.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/splash/cubit/startup_cubit.dart';
import 'package:ismart_web/features/splash/resource/startup_repository.dart';

class MultiBlocWrapper extends StatelessWidget {
  final Widget child;
  final CoOperative env;
  const MultiBlocWrapper({required this.child, required this.env});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create:
        //       (context) => StartupCubit(
        //         appServiceRepository:
        //             RepositoryProvider.of<AppServiceRepository>(context),
        //         startUpRepository: RepositoryProvider.of<StartUpRepository>(
        //           context,
        //         ),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //       ),
        // ),
        BlocProvider(
          create:
              (context) => LoginCubit(
                userRepository: RepositoryProvider.of<UserRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => ValidateCoOpCubit(
                userRepository: RepositoryProvider.of<UserRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => CustomerDetailCubit(
                customerDetailRepository:
                    RepositoryProvider.of<CustomerDetailRepository>(context),
              ),
        ),

        // BlocProvider(create: (context) => UpdateCubit(), lazy: false),

        // BlocProvider(
        //   create:
        //       (context) => ImageUploadCubit(
        //         imageUploadRepository:
        //             RepositoryProvider.of<ImageUploadRepository>(context),
        //       ),
        //   lazy: false,
        // ),
        BlocProvider(
          create:
              (context) => AudioUploadCubit(
                audioUploadRepository:
                    RepositoryProvider.of<AudioUploadRepository>(context),
              ),
          lazy: false,
        ),
        BlocProvider(
          create:
              (context) => AppServiceCubit(
                appServiceRepository:
                    RepositoryProvider.of<AppServiceRepository>(context),
              ),
        ),
      ],
      child: child,
    );
  }
}
