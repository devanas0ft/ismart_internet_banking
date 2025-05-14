import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class CustomCheckbox extends StatelessWidget {
  final bool selected;
  final String title;
  final ValueChanged<bool> onChanged;
  final double rightMargin;
  final double leftMargin;
  const CustomCheckbox({
    Key? key,
    required this.selected,
    required this.title,
    required this.onChanged,
    this.rightMargin = 0,
    this.leftMargin = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return Container(
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
      padding: EdgeInsets.only(top: 12.wp, bottom: 12.wp, right: 20.wp),
      child: InkWell(
        onTap: () {
          onChanged(!selected);
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: EdgeInsets.only(right: 5.wp),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: selected,
                  activeColor: _theme.primaryColor,
                  onChanged: (val) {
                    if (val != null) {
                      onChanged(val);
                    }
                  },
                ),
              ),
              SizedBox(width: 8.wp),
              Text(title, style: _textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
