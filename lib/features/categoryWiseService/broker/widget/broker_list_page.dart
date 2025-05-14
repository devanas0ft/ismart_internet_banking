import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_icon_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/search_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class BrokerSearchPage extends StatefulWidget {
  final ValueChanged<KeyValue> onChanged;

  // final Function(RecentSearch) onRecentSearchClick;
  const BrokerSearchPage({
    Key? key,
    required this.onChanged,
    // required this.onRecentSearchClick,
  }) : super(key: key);

  @override
  State<BrokerSearchPage> createState() => _BrokerSearchPageState();
}

class _BrokerSearchPageState extends State<BrokerSearchPage> {
  @override
  void initState() {
    super.initState();
  }

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
            apiEndpoint: "/api/broker/list",
          ),
      child: PageWrapper(
        showBackButton: true,
        leadingAppIcon: CustomIconButton(
          icon: Icons.close_rounded,
          shadow: false,
          backgroundColor: Colors.transparent,
          onPressed: () {
            NavigationService.pop();
          },
        ),
        title: "Select",
        padding: EdgeInsets.zero,
        body: BlocBuilder<UtilityPaymentCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading) {
              return const CommonLoadingWidget();
            } else if (state is CommonStateSuccess<UtilityResponseData>) {
              final _data = state.data.findValue(primaryKey: "data");

              return SearchWidgets(
                onChanged: widget.onChanged,
                ignoreValue: null,
                hideValue: false,
                showSearchHistory: false,
                items: List.generate(_data.length, (index) {
                  return KeyValue(
                    title: _data[index]["name"],
                    value: _data[index]["code"],
                  );
                }),
              );
            } else if (state is CommonError) {
              return Container();
              // return WalletCommonErrorWidget(
              //   message: state.message,
              //   isNoConnection: state.isNoConnection,
              // );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
