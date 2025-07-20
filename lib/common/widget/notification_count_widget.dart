import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/notification/screen/notification_page.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class NotificationCountIcon extends StatefulWidget {
  const NotificationCountIcon({super.key});

  @override
  State<NotificationCountIcon> createState() => _NotificationCountIconState();
}

class _NotificationCountIconState extends State<NotificationCountIcon> {
  ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    customerDetail =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).customerDetailModel;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonStateSuccess) {
            NavigationService.push(target: const NotificationPage());
          }
        },
        child: ValueListenableBuilder<CustomerDetailModel?>(
          valueListenable: customerDetail,
          builder: (context, val, _) {
            if (val != null) {
              return InkWell(
                onTap: () {
                  context.read<UtilityPaymentCubit>().makePayment(
                    body: {},
                    mPin: "",
                    serviceIdentifier: "",
                    accountDetails: {},
                    apiEndpoint: "/api/notifications/seen",
                  );
                },
                child: Container(
                  width: _width * 0.09,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: _height * 0.006,
                        child:
                            val.unseenNotificationCount != 0
                                ? CircleAvatar(
                                  backgroundColor: CustomTheme.googleColor,
                                  radius: _height * 0.01,
                                  child: Center(
                                    child: Text(
                                      val.unseenNotificationCount.toString(),
                                      style: _textTheme.titleSmall!.copyWith(
                                        color: CustomTheme.white,
                                      ),
                                    ),
                                  ),
                                )
                                : Container(),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          Assets.notificationIcon,
                          height: _height * 0.025,
                          color: _theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
