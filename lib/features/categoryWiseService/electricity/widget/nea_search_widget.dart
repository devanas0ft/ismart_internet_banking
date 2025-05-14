import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/enum/counters_fetch_enum.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/widget/custom_icon_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/search_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class CountersSearchWidget extends StatelessWidget {
  final ValueChanged<KeyValue> onChanged;
  final CountersEnums countersEnums;
  const CountersSearchWidget({
    Key? key,
    required this.onChanged,
    required this.countersEnums,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          )..fetchDetails(
            serviceIdentifier: "",
            accountDetails: {},
            apiEndpoint:
                countersEnums == CountersEnums.NEA
                    ? "get/neaofficecode"
                    : "get/khanepanicounters",
          ),
      child: PageWrapper(
        showBackButton: true,
        leadingAppIcon: CustomIconButton(
          icon: Icons.close_rounded,
          shadow: false,
          backgroundColor: Colors.red,
          onPressed: () {
            NavigationService.pop();
          },
        ),
        title: "Counters",
        padding: EdgeInsets.zero,
        body: BlocBuilder<UtilityPaymentCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonStateSuccess<UtilityResponseData>) {
              final _counters = state.data.findValue(primaryKey: "data");
              return SearchWidgets(
                onChanged: onChanged,
                hideValue: true,
                items: List.generate(
                  _counters?.length ?? 0,
                  (index) => KeyValue(
                    title:
                        _counters?[index]["office"] ??
                        _counters?[index]["name"],
                    value:
                        _counters?[index]["officeCode"] ??
                        _counters?[index]["value"],
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
