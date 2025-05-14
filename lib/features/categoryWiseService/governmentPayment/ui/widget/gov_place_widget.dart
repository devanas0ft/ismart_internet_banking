import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_list_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class GovnPlaceWidget extends StatefulWidget {
  final String serviceIdentifier;
  final String apiEndpoint;
  final bool isProvince;

  final accountDetail;
  const GovnPlaceWidget({
    Key? key,
    required this.onBankSelected,
    required this.serviceIdentifier,
    required this.apiEndpoint,
    required this.accountDetail,
    required this.isProvince,
  }) : super(key: key);
  final Function({required String value, required String name}) onBankSelected;
  @override
  State<GovnPlaceWidget> createState() => _GovnPlaceWidgetState();
}

class _GovnPlaceWidgetState extends State<GovnPlaceWidget> {
  bool _showTitleAndDesc = true;

  @override
  void initState() {
    super.initState();
    context.read<UtilityPaymentCubit>().fetchDetails(
      serviceIdentifier: widget.serviceIdentifier,
      accountDetails: widget.accountDetail,
      apiEndpoint: widget.apiEndpoint,
    );
  }

  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 15.hp)),
          if (_showTitleAndDesc)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomTheme.symmetricHozPadding,
                ),
                child: Text("Places", style: _textTheme.displayLarge),
              ),
            ),
          if (_showTitleAndDesc)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomTheme.symmetricHozPadding,
                ),
                child: Text("Select From List", style: _textTheme.titleLarge),
              ),
            ),
          if (_showTitleAndDesc)
            const SliverToBoxAdapter(child: SizedBox(height: 25)),
          BlocConsumer<UtilityPaymentCubit, CommonState>(
            listener: (context, state) {
              if (state is CommonError) {
                if ((state.statusCode ?? 400) >= 400 &&
                    (state.statusCode ?? 400) <= 600 &&
                    state.statusCode != 404) {
                  setState(() {
                    _showTitleAndDesc = false;
                  });
                }
              }
            },
            builder: (context, state) {
              if (state is CommonLoading && _isLoading == false) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: CommonLoadingWidget(),
                );
              }
              if (state is CommonStateSuccess<UtilityResponseData>) {
                final List _list = state.data.findValue(primaryKey: "data");
                print(_list);
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return CustomListTile(
                      title:
                          widget.isProvince
                              ? _list[index]["name"]
                              : _list[index]["display"],
                      description: "",
                      trailing: Container(),
                      onPressed: () {
                        widget.onBankSelected(
                          name:
                              state.data.findValue(
                                primaryKey: "data",
                              )[index][widget.isProvince ? "name" : "display"],
                          value:
                              state.data.findValue(
                                primaryKey: "data",
                              )[index][widget.isProvince ? "code" : "value"],
                        );
                        setState(() {});
                      },
                      horizontalPadding: CustomTheme.symmetricHozPadding,
                    );
                  }, childCount: _list.length),
                );
              } else if (state is CommonLoadingWidget) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: CommonLoadingWidget(),
                );
              } else if (state is CommonError) {
                if ((state.statusCode ?? 400) >= 400 &&
                    (state.statusCode ?? 400) <= 600 &&
                    state.statusCode != 404) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child:
                        CommonLoadingWidget(), // TODOReplace with maintenance
                  );
                }
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(child: Center(child: Text(state.message))),
                );
              } else {
                return SliverToBoxAdapter(child: Container());
              }
            },
          ),
        ],
      ),
    );
  }
}
