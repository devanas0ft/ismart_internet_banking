import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/widget/custom_list_tile.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';

class CategorySearchWidgets extends StatefulWidget {
  final List<ServiceList> items;
  final KeyValue? ignoreValue;
  final Function()? onPressed;
  // final bool hideValue;
  // final String imageUrl;

  final Widget? searchHistoryWidget;
  final bool showSearchHistory;

  const CategorySearchWidgets({
    Key? key,
    required this.items,
    required this.onPressed,
    this.ignoreValue,
    // this.hideValue = false,
    this.showSearchHistory = false,
    this.searchHistoryWidget,
    // required this.imageUrl,
  }) : super(key: key);

  @override
  State<CategorySearchWidgets> createState() => _SearchWidgetsState();
}

class _SearchWidgetsState extends State<CategorySearchWidgets> {
  List<ServiceList> searchItems = [];
  Timer? _debounce;

  @override
  void initState() {
    // searchItems = widget.items;
    super.initState();
  }

  _updateSearchList(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final _res =
          widget.items
              .where(
                (e) => e.service.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      if (mounted) {
        setState(() {
          searchItems = _res;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          CustomTextField(
            margin: const EdgeInsets.only(
              left: CustomTheme.symmetricHozPadding,
              right: CustomTheme.symmetricHozPadding,
            ),
            hintText: "Search",
            type: TextFieldType.Filled,
            showSearchIcon: true,
            onChanged: (val) {
              _updateSearchList(val);
            },
          ),
          const SizedBox(height: 10),
          if (widget.showSearchHistory && widget.searchHistoryWidget != null)
            Row(
              children: [
                const SizedBox(width: 15),
                widget.searchHistoryWidget!,
              ],
            ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: searchItems.length,
                itemBuilder: (context, index) {
                  if (widget.ignoreValue == null ||
                      widget.ignoreValue!.value != searchItems[index].service) {
                    return CustomListTile(
                      horizontalPadding: CustomTheme.symmetricHozPadding,
                      imageUrl:
                          RepositoryProvider.of<CoOperative>(context).baseUrl +
                          "/ismart/serviceIcon/" +
                          searchItems[index].icon.toString(),
                      title: searchItems[index].service,
                      titleFontWeight: FontWeight.w400,
                      description: "",
                      trailing: Container(),
                      onPressed: widget.onPressed,
                    );
                  } else {
                    return CustomListTile(
                      horizontalPadding: CustomTheme.symmetricHozPadding,
                      imageUrl:
                          RepositoryProvider.of<CoOperative>(context).baseUrl +
                          "/ismart/serviceIcon/" +
                          widget.items[index].icon.toString(),
                      title: widget.items[index].service,
                      titleFontWeight: FontWeight.w400,
                      description: "",
                      trailing: Container(),
                      onPressed: widget.onPressed,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/enum/text_field_type.dart';
// import 'package:ismart/common/models/key_value.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/widget/common_text_field.dart';
// import 'package:ismart/common/widget/custom_list_tile.dart';

// class CategorySearchWidgets extends StatefulWidget {
//   final List<KeyValue> items;
//   final KeyValue? ignoreValue;
//   final Function()? onPressed;
//   final bool hideValue;
//   final String imageUrl;

//   final Widget? searchHistoryWidget;
//   final bool showSearchHistory;

//   const CategorySearchWidgets({
//     Key? key,
//     required this.items,
//     required this.onPressed,
//     this.ignoreValue,
//     this.hideValue = false,
//     this.showSearchHistory = false,
//     this.searchHistoryWidget,
//     required this.imageUrl,
//   }) : super(key: key);

//   @override
//   State<CategorySearchWidgets> createState() => _SearchWidgetsState();
// }

// class _SearchWidgetsState extends State<CategorySearchWidgets> {
//   List<KeyValue> searchItems = [];
//   Timer? _debounce;

//   @override
//   void initState() {
//     searchItems = widget.items;
//     super.initState();
//   }

//   _updateSearchList(String query) {
//     if (_debounce?.isActive ?? false) {
//       _debounce?.cancel();
//     }
//     _debounce = Timer(const Duration(milliseconds: 200), () {
//       final _res = widget.items
//           .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//       if (mounted) {
//         setState(() {
//           searchItems = _res;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 10),
//           CustomTextField(
//             margin: const EdgeInsets.only(
//               left: CustomTheme.symmetricHozPadding,
//               right: CustomTheme.symmetricHozPadding,
//             ),
//             hintText: "Search",
//             type: TextFieldType.Filled,
//             showSearchIcon: true,
//             onChanged: (val) {
//               _updateSearchList(val);
//             },
//           ),
//           const SizedBox(height: 10),
//           if (widget.showSearchHistory && widget.searchHistoryWidget != null)
//             Row(
//               children: [
//                 const SizedBox(width: 15),
//                 widget.searchHistoryWidget!,
//               ],
//             ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: Scrollbar(
//               child: ListView.builder(
//                 itemCount: searchItems.length,
//                 itemBuilder: (context, index) {
//                   if (widget.ignoreValue == null ||
//                       widget.ignoreValue!.value != searchItems[index].value) {
//                     return CustomListTile(
//                       horizontalPadding: CustomTheme.symmetricHozPadding,
//                       imageUrl:
//                           RepositoryProvider.of<CoOperative>(context).baseUrl +
//                               "/ismart/serviceIcon/" +
//                               widget.imageUrl,
//                       title: searchItems[index].title,
//                       titleFontWeight: FontWeight.w400,
//                       description: searchItems[index].value,
//                       trailing: Container(),
//                       onPressed: widget.onPressed,
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
