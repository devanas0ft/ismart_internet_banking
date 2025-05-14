import 'dart:math' as math;
import 'package:flutter/material.dart';

class DateSelectorItem {
  final String date;
  final String displayText;

  DateSelectorItem({required this.date, required this.displayText});
}

class AnimatedDateSelector extends StatefulWidget {
  final List<DateSelectorItem> dates;
  final Function(int) onDateSelected;
  final int initialSelectedIndex;
  final Color indicatorColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final double itemWidth;
  final TextStyle? textStyle;

  const AnimatedDateSelector({
    Key? key,
    required this.dates,
    required this.onDateSelected,
    this.initialSelectedIndex = 0,
    this.indicatorColor = Colors.blue,
    this.selectedTextColor = Colors.blue,
    this.unselectedTextColor = Colors.grey,
    this.itemWidth = 115.0,
    this.textStyle,
  }) : super(key: key);

  @override
  State<AnimatedDateSelector> createState() => _AnimatedDateSelectorState();
}

class _AnimatedDateSelectorState extends State<AnimatedDateSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _indicatorAnimation;
  final ScrollController _scrollController = ScrollController();
  double _currentIndicatorOffset = 0.0;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _indicatorAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scrollController.addListener(_updateIndicatorOnScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateIndicator(selectedIndex, false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_updateIndicatorOnScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateIndicatorOnScroll() {
    setState(() {
      _indicatorAnimation = Tween<double>(
        begin: _currentIndicatorOffset,
        end: _currentIndicatorOffset,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    });
  }

  void _animateIndicator(int index, [bool animate = true]) {
    final targetScroll = index * widget.itemWidth;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (animate) {
      if (targetScroll >
          _scrollController.offset + screenWidth - widget.itemWidth) {
        _scrollController.animateTo(
          math.min(targetScroll - screenWidth + widget.itemWidth, maxScroll),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (targetScroll < _scrollController.offset) {
        _scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _scrollController.jumpTo(
        math.min(targetScroll, maxScroll),
      );
    }

    setState(() {
      selectedIndex = index;
      _indicatorAnimation = Tween<double>(
        begin: _currentIndicatorOffset,
        end: targetScroll,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _controller.forward(from: 0).whenComplete(() {
        setState(() {
          _currentIndicatorOffset = targetScroll;
        });
      });
    });

    widget.onDateSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black38)),
      ),
      height: 60,
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: widget.dates.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => SizedBox(
              width: widget.itemWidth,
              child: InkWell(
                onTap: () => _animateIndicator(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    widget.dates[index].displayText,
                    textAlign: TextAlign.center,
                    style: (widget.textStyle ?? const TextStyle()).copyWith(
                      color: selectedIndex == index
                          ? widget.selectedTextColor
                          : widget.unselectedTextColor,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedBuilder(
              animation: _indicatorAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(
                  _indicatorAnimation.value - _scrollController.offset,
                  0,
                ),
                child: Container(
                  height: 2,
                  width: widget.itemWidth,
                  decoration: BoxDecoration(
                    color: widget.indicatorColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
