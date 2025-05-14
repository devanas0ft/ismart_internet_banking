import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class MovieDetailBox extends StatelessWidget {
  final String title;
  final String containerImage;
  final Function()? onContainerPress;
  final EdgeInsets? margin;
  final double? height;
  final double? width;

  const MovieDetailBox({
    super.key,
    this.margin = const EdgeInsets.all(8),
    required this.title,
    this.onContainerPress,
    this.height,
    this.width,
    required this.containerImage,
  });
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Container(
      width: 175.wp,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: onContainerPress,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                containerImage,
                width: double.infinity,
                height: height,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Image.asset(
                      RepositoryProvider.of<CoOperative>(
                        context,
                      ).coOperativeLogo,
                    ),
              ),
            ),
            SizedBox(height: 5.hp),
            Text(
              capitalizeEachWord(title),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: _theme.textTheme.displaySmall!.copyWith(
                fontSize: 11.5,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10.hp),
          ],
        ),
      ),
    );
  }

  String capitalizeEachWord(String title) {
    return title
        .split(' ')
        .map((word) {
          return word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '';
        })
        .join(' ');
  }
}
