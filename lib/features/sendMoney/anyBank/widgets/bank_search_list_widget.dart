import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/widget/custom_list_tile.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';

import '../../../../common/app/navigation_service.dart';

class BankSearchWidgets extends StatefulWidget {
  final List<KeyValue> items;
  final String image;
  final KeyValue? ignoreValue;
  final ValueChanged<KeyValue>? onChanged;
  final bool hideValue;

  final Widget? searchHistoryWidget;
  final bool showSearchHistory;

  const BankSearchWidgets({
    Key? key,
    required this.items,
    this.onChanged,
    this.ignoreValue,
    this.hideValue = false,
    this.showSearchHistory = false,
    this.searchHistoryWidget,
    required this.image,
  }) : super(key: key);

  @override
  State<BankSearchWidgets> createState() => _BankSearchWidgetsState();
}

class _BankSearchWidgetsState extends State<BankSearchWidgets> {
  List<KeyValue> searchItems = [];
  Timer? _debounce;

  @override
  void initState() {
    searchItems = widget.items;
    super.initState();
  }

  _updateSearchList(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final _res =
          widget.items
              .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
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
                      widget.ignoreValue!.value != searchItems[index].value) {
                    return CustomListTile(
                      imageUrl: RepositoryProvider.of(context) + widget.image,
                      horizontalPadding: CustomTheme.symmetricHozPadding,
                      title: searchItems[index].title,
                      titleFontWeight: FontWeight.w400,
                      description: searchItems[index].value,
                      trailing: Container(),
                      hideDescription: widget.hideValue,
                      onPressed: () {
                        if (widget.onChanged != null) {
                          widget.onChanged!(searchItems[index]);
                        }
                        NavigationService.pop();
                      },
                    );
                  } else {
                    return Container();
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
