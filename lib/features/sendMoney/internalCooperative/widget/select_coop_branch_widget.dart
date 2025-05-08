import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_list_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/cubits/coop_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/models/internal_branch.dart';

class CoOpBranchListWidget extends StatefulWidget {
  const CoOpBranchListWidget({Key? key, required this.onBankSelected})
    : super(key: key);
  final Function(InternalBranch) onBankSelected;
  @override
  State<CoOpBranchListWidget> createState() => _CoOpBranchListWidgetState();
}

class _CoOpBranchListWidgetState extends State<CoOpBranchListWidget> {
  bool _showTitleAndDesc = true;

  @override
  void initState() {
    super.initState();
    context.read<CoopListCubit>().fetchBanksList();
  }

  final bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      showBackButton: true,
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
                child: Text("Branches", style: _textTheme.displayLarge),
              ),
            ),
          if (_showTitleAndDesc)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomTheme.symmetricHozPadding,
                ),
                child: Text("Select branch", style: _textTheme.titleLarge),
              ),
            ),
          if (_showTitleAndDesc)
            const SliverToBoxAdapter(child: SizedBox(height: 25)),
          BlocConsumer<CoopListCubit, CommonState>(
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
              if (state is CommonDataFetchSuccess<InternalBranch>) {
                List<InternalBranch> _list = state.data;
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return CustomListTile(
                      title: _list[index].name,
                      description: "",
                      trailing: Container(),
                      imageUrl: "",
                      onPressed: () {
                        widget.onBankSelected(_list[index]);
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
                        CommonLoadingWidget(), // TODO Replace with maintenance
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
