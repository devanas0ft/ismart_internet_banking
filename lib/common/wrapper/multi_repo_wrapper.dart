import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/http/api_provider.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/resources/category_repository.dart';
import 'package:ismart_web/features/appServiceManagement/resource/app_service_repository.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/auth/ui/actiateAccount/resources/reset_otp_register_repository.dart';
import 'package:ismart_web/features/auth/ui/resetPin/resources/reset_pin_repository.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/resources/airlines_repository.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/movie_repository.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_payment_repository.dart';
import 'package:ismart_web/features/chatBot/resources/audio_upload_repository.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/history/resources/recent_transaction_repository.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart_web/features/sendMoney/resources/send_to_bank_repository.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/resoures/wallet_load_repository.dart';
import 'package:ismart_web/features/splash/resource/startup_repository.dart';
import 'package:ismart_web/features/statement/fullStatement/resources/full_statement_repository.dart';
import 'package:ismart_web/features/statement/miniStatement/resources/mini_statement_repository.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class MultiRepositoryWrapper extends StatelessWidget {
  final Widget child;
  final CoOperative env;
  const MultiRepositoryWrapper({required this.child, required this.env});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CoOperative>(create: (context) => env, lazy: true),
        // RepositoryProvider<InternetCheck>(
        //   create: (context) => InternetCheck(),
        //   lazy: true,
        // ),
        RepositoryProvider<ApiProvider>(
          create: (context) => ApiProvider(baseUrl: env.baseUrl),
          lazy: true,
        ),
        RepositoryProvider<UserRepository>(
          create:
              (context) => UserRepository(
                env: RepositoryProvider.of<CoOperative>(context),
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
              )..initialState(),
          lazy: true,
        ),
        RepositoryProvider<StartUpRepository>(
          create:
              (context) => StartUpRepository(
                env: RepositoryProvider.of<CoOperative>(context),
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider(
          create:
              (context) => CustomerDetailRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),

        // RepositoryProvider(
        //   create:
        //       (context) => ImageUploadRepository(
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         coOperative: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
        RepositoryProvider(
          create:
              (context) => AudioUploadRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider<UtilityPaymentRepository>(
          create:
              (context) => UtilityPaymentRepository(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                env: RepositoryProvider.of<CoOperative>(context),
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                customerDetailRepository:
                    RepositoryProvider.of<CustomerDetailRepository>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider<SendToBankRepository>(
          create:
              (context) => SendToBankRepository(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                env: RepositoryProvider.of<CoOperative>(context),
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
              ),
          lazy: true,
        ),

        RepositoryProvider(
          create:
              (context) => MiniStatementRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider(
          create:
              (context) => MovieRepository(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                env: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider(
          create:
              (context) => FullStatementRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        // RepositoryProvider<ReceiveFromBankRepository>(
        //   create:
        //       (context) => ReceiveFromBankRepository(
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         env: RepositoryProvider.of<CoOperative>(context),
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //       ),
        //   lazy: true,
        // ),
        RepositoryProvider<RecentTransactionRepository>(
          create:
              (context) => RecentTransactionRepository(
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider(
          create:
              (context) => WalletLoadRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        // RepositoryProvider(
        //   create:
        //       (context) => ReceiveMoneyRepository(
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         coOperative: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
        RepositoryProvider(
          create:
              (context) => CategoryRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
        ),
        RepositoryProvider(
          create:
              (context) => InternalTransferRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                env: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider(
          create:
              (context) => AppServiceRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        // RepositoryProvider(
        //   create:
        //       (context) => KhanePaniRepository(
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         coOperative: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
        // RepositoryProvider(
        //   create:
        //       (context) => DatapackRepository(
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         coOperative: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
        // RepositoryProvider(
        //   create:
        //       (context) => QrRepository(
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         coOperative: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
        RepositoryProvider(
          create:
              (context) => AirlinesRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                coOperative: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        // RepositoryProvider(
        //   create:
        //       (context) => CreditCardRepository(
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         env: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
        RepositoryProvider(
          create:
              (context) => ResetPinRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                env: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider(
          create:
              (context) => ResetOtpRegisterRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                env: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        RepositoryProvider(
          create:
              (context) => TvPaymentRepository(
                apiProvider: RepositoryProvider.of<ApiProvider>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                env: RepositoryProvider.of<CoOperative>(context),
              ),
          lazy: true,
        ),
        // RepositoryProvider(
        //   create:
        //       (context) => AppContactRepository(
        //         customerDetailRepository:
        //             RepositoryProvider.of<CustomerDetailRepository>(context),
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         env: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
        // RepositoryProvider(
        //   create:
        //       (context) => BannerRepository(
        //         apiProvider: RepositoryProvider.of<ApiProvider>(context),
        //         userRepository: RepositoryProvider.of<UserRepository>(context),
        //         env: RepositoryProvider.of<CoOperative>(context),
        //       ),
        //   lazy: true,
        // ),
      ],
      child: child,
    );
  }
}
