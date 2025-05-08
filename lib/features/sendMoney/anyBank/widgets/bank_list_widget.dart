import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_list_tile.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/sendMoney/cubits/send_to_bank_cubit.dart';
import 'package:ismart_web/features/sendMoney/models/bank.dart';

class BanksListWidget extends StatefulWidget {
  const BanksListWidget({Key? key, required this.onBankSelected})
    : super(key: key);
  final Function(Bank) onBankSelected;
  @override
  State<BanksListWidget> createState() => _BanksListWidgetState();
}

class _BanksListWidgetState extends State<BanksListWidget> {
  bool _showTitleAndDesc = true;

  @override
  void initState() {
    super.initState();
    context.read<SendToBankCubit>().fetchBanksList();
  }

  final bool _isLoading = false;

  List<Bank> _localBanks = [];
  List<Bank> _totalBanks = [];
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      padding: EdgeInsets.zero,
      showBackButton: true,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 15.hp)),
          if (_showTitleAndDesc)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomTheme.symmetricHozPadding,
                ),
                child: Text("Banks", style: _textTheme.displayLarge),
              ),
            ),
          if (_showTitleAndDesc)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomTheme.symmetricHozPadding,
                ),
                child: Text("Select bank", style: _textTheme.titleLarge),
              ),
            ),
          if (_showTitleAndDesc)
            const SliverToBoxAdapter(child: SizedBox(height: 25)),
          BlocConsumer<SendToBankCubit, CommonState>(
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

              if (state is CommonDataFetchSuccess<Bank>) {
                // List<Bank> _list = state.data;
                _localBanks = state.data;
                _totalBanks = state.data;
                setState(() {});
              }
            },
            builder: (context, state) {
              if (state is CommonLoading && _isLoading == false) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: CommonLoadingWidget(),
                );
              }
              // if (state is CommonDataFetchSuccess<Bank>) {
              //   List<Bank> _list = state.data;
              //   return SliverList(
              //     delegate: SliverChildBuilderDelegate(
              //       (context, index) {
              //         return CustomListTile(
              //           title: _list[index].bankName,
              //           description: "",
              //           trailing: Container(),
              //           imageUrl: _list[index].iconUrl,
              //           onPressed: () {
              //             widget.onBankSelected(_list[index]);
              //           },
              //           horizontalPadding: CustomTheme.symmetricHozPadding,
              //         );
              //       },
              //       childCount: _list.length,
              //     ),
              //   );
              // } else
              if (state is CommonLoading) {
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
          SliverToBoxAdapter(
            child: CustomTextField(
              hintText: "Search Bank...",
              showSearchIcon: true,
              horizontalMargin: 15.hp,
              onChanged: (val) {
                if (val.isEmpty) {
                  _localBanks = _totalBanks;
                  setState(() {});
                } else {
                  _localBanks =
                      _totalBanks
                          .where(
                            (element) => element.bankName
                                .toLowerCase()
                                .contains(val.toLowerCase()),
                          )
                          .toList();
                }
                setState(() {});
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return CustomListTile(
                title: _localBanks[index].bankName,
                description: "",
                trailing: Container(),
                imageUrl: _localBanks[index].iconUrl,
                onPressed: () {
                  widget.onBankSelected(_localBanks[index]);
                },
                horizontalPadding: CustomTheme.symmetricHozPadding,
              );
            }, childCount: _localBanks.length),
          ),
        ],
      ),
    );
  }
}
