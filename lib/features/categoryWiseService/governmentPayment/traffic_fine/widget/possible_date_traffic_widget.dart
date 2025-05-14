import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_icon_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/search_widget.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class PossibleDatetrafficPage extends StatefulWidget {
  final ServiceList service;
  final ValueChanged<KeyValue> onChanged;

  // final Function(RecentSearch) onRecentSearchClick;
  const PossibleDatetrafficPage({
    Key? key,
    required this.onChanged,
    required this.service,
    // required this.onRecentSearchClick,
  }) : super(key: key);

  @override
  State<PossibleDatetrafficPage> createState() =>
      _PossibleDatetrafficPageState();
}

class _PossibleDatetrafficPageState extends State<PossibleDatetrafficPage> {
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
            serviceIdentifier: widget.service.uniqueIdentifier,
            accountDetails: {},
            apiEndpoint: "/api/governmentpayment/possibleFiscalYears",
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
            }
            if (state is CommonStateSuccess<UtilityResponseData>) {
              final _sectors = state.data.findValue(primaryKey: "data");
              return SearchWidgets(
                onChanged: widget.onChanged,
                ignoreValue: null,
                hideValue: false,
                showSearchHistory: false,
                items: List.generate(_sectors.length, (index) {
                  return KeyValue(
                    title: _sectors[index]["display"].toString(),
                    value: _sectors[index]["value"].toString(),
                  );
                }),
              );
            } else if (state is CommonError) {
              return Container();
            } else {
              return Container(child: Text(state.toString()));
            }
          },
        ),
      ),
    );
  }
}
