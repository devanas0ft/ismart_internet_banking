import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/cubit/category_cubit.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/resources/category_repository.dart';
import 'package:ismart_web/features/chatBot/smart_chat_page.dart';
import 'package:ismart_web/features/chatBot/utility/smartchat_busticket_cubit.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class IntermediateChatPage extends StatelessWidget {
  final int id;
  const IntermediateChatPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => UtilityPaymentCubit(
                utilityPaymentRepository:
                    RepositoryProvider.of<UtilityPaymentRepository>(context),
              ),
        ),
        BlocProvider(
          create:
              (context) => CategoryCubit(
                servicesRepository: RepositoryProvider.of<CategoryRepository>(
                  context,
                ),
              )..fetchCategory(),
        ),
        BlocProvider(create: (context) => SmartChatBusTicketCubit()),
      ],
      child: SmartChatPage(id: id),
    );
  }
}
