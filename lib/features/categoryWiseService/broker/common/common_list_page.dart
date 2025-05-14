import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_icon_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/search_widget.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/cubit/airlines_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_sector_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/resources/airlines_repository.dart';

class CommonListPage extends StatefulWidget {
  final ValueChanged<KeyValue> onChanged;
  final cubitData;

  final KeyValue? selectedValue;

  // final Function(RecentSearch) onRecentSearchClick;
  const CommonListPage({
    Key? key,
    required this.onChanged,
    required this.selectedValue,
    this.cubitData,
    // required this.onRecentSearchClick,
  }) : super(key: key);

  @override
  State<CommonListPage> createState() => _CommonListPageState();
}

class _CommonListPageState extends State<CommonListPage> {
  // List<RecentSearch> _recentSearchList = [];

  @override
  void initState() {
    super.initState();

    // fetchRecentSearch();
  }

  // fetchRecentSearch() async {
  //   _recentSearchList = await WalletSharedPref.recentSearches;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create:
          (context) => AirlinesCubit(
            airlinesRepository: RepositoryProvider.of<AirlinesRepository>(
              context,
            ),
          )..fetchAirlinesLocation(),
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
        title: "Select Sector",
        padding: EdgeInsets.zero,
        body: BlocBuilder<AirlinesCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading) {
              return const CommonLoadingWidget();
            } else if (state is CommonDataFetchSuccess<AirlinesSectorList>) {
              final _sectors = state.data;
              return SearchWidgets(
                onChanged: widget.onChanged,
                ignoreValue: null,
                hideValue: false,
                showSearchHistory: false,
                items: List.generate(_sectors.length, (index) {
                  return KeyValue(
                    title: _sectors[index].sectorName ?? "",
                    value: _sectors[index].sectorCode,
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
