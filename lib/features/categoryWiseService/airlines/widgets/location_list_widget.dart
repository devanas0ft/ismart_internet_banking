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

class FlightsSearchPage extends StatefulWidget {
  final ValueChanged<KeyValue> onChanged;

  final KeyValue? selectedValue;

  // final Function(RecentSearch) onRecentSearchClick;
  const FlightsSearchPage({
    Key? key,
    required this.onChanged,
    required this.selectedValue,
    // required this.onRecentSearchClick,
  }) : super(key: key);

  @override
  State<FlightsSearchPage> createState() => _FlightsSearchPageState();
}

class _FlightsSearchPageState extends State<FlightsSearchPage> {
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

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/custom_list_tile.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/common/widget/search_widget.dart';
// import 'package:ismart/common/widget/show_loading_dialog.dart';
// import 'package:ismart/common/widget/show_pop_up_dialog.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/cubit/airlines_cubit.dart';
// import 'package:ismart/feature/categoryWiseService/airlines/model/airlines_sector_model.dart';

// class LocationListAirlinesWidget extends StatefulWidget {
//   final Function(AirlinesSectorList) selectedLocation;

//   const LocationListAirlinesWidget({Key? key, required this.selectedLocation})
//       : super(key: key);

//   @override
//   State<LocationListAirlinesWidget> createState() =>
//       _LocationListAirlinesWidgetState();
// }

// class _LocationListAirlinesWidgetState
//     extends State<LocationListAirlinesWidget> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<AirlinesCubit>().fetchAirlinesLocation();
//   }

//   bool _isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     final _height = SizeUtils.height;
//     return PageWrapper(
//       showAppBar: false,
//       body: BlocConsumer<AirlinesCubit, CommonState>(
//         listener: (context, state) {
//           if (state is CommonLoading && !_isLoading) {
//             _isLoading = true;
//             showLoadingDialogBox(context);
//           } else if (state is! CommonLoading && _isLoading) {
//             _isLoading = false;
//             NavigationService.pop();
//           }

//           if (state is CommonError) {
//             showPopUpDialog(
//               context: context,
//               message: state.message,
//               title: "Error",
//               showCancelButton: false,
//               buttonCallback: () {
//                 NavigationService.pop();
//               },
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is CommonDataFetchSuccess<AirlinesSectorList>) {
//              return SearchWidgets(
//                 onChanged: (val){
//                   widget.selectedLocation();
//                 },
//                 ignoreValue: widget.selectedValue,
//                 hideValue: false,
//                 showSearchHistory: _recentSearchList.isNotEmpty,
//                 searchHistoryWidget: Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(
//                         _recentSearchList.length,
//                         (index) {
//                           return InkWell(
//                             onTap: () {
//                               widget.onRecentSearchClick(
//                                   _recentSearchList[index]);

//                               NavigationService.pop();
//                             },
//                             child: Container(
//                               padding: EdgeInsets.all(15.hp),
//                               margin: EdgeInsets.symmetric(horizontal: 10.hp),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(22.5.hp),
//                                   border: Border.all(
//                                     color: _theme.primaryColor,
//                                   )),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     _recentSearchList[index].from.title,
//                                     style: _textTheme.titleSmall!.copyWith(
//                                       color: _theme.primaryColor,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10.hp,
//                                   ),
//                                   Icon(
//                                     Icons.arrow_right_alt_rounded,
//                                     color: _theme.primaryColor,
//                                     size: 24.hp,
//                                   ),
//                                   SizedBox(
//                                     width: 10.hp,
//                                   ),
//                                   Text(
//                                     _recentSearchList[index].to.title,
//                                     style: _textTheme.titleSmall!.copyWith(
//                                       color: _theme.primaryColor,
//                                       fontWeight: FontWeight.normal,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 items: List.generate(
//                   _sectors?.length ?? 0,
//                   (index) {
//                     return KeyValue(
//                       title: _sectors?[index]["name"],
//                       value: _sectors?[index]["code"],
//                     );
//                   },
//                 ),
//               );

//             // print("data ist" + state.data[0].sectorCode.toString());
//             // return ListView.builder(
//             //   itemCount: state.data.length,
//             //   itemBuilder: (context, index) {
//             //     return CustomListTile(
//             //         onPressed: () {
//             //           widget.selectedLocation(state.data[index]);
//             //           setState(() {});
//             //         },
//             //         title: state.data[index].sectorName.toString(),
//             //         description: state.data[index].sectorCode.toString());
//             //   },
//             // );
//           } else {
//             return Container(
//               child: Text(state.toString()),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
