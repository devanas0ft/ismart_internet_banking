import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/url_launcher.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/notification/resources/notification_model.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  void initState() {
    context.read<UtilityPaymentCubit>().fetchNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return PageWrapper(
      showBackButton: true,
      body: BlocConsumer<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<UtilityPaymentCubit, CommonState>(
            builder: (context, state) {
              if (state is CommonStateSuccess<NotificationModel>) {
                if (state.data.detail.isNotEmpty) {
                  return ListView.builder(
                    // padding: const EdgeInsets.all(16),
                    itemCount: state.data.detail.length,
                    itemBuilder: (context, index) {
                      final data = state.data.detail[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            if (data.redirectUrl.isNotEmpty) {
                              UrlLauncher.launchUrlLink(
                                context: context,
                                url: data.redirectUrl,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with icon and title
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.notificationIcon,
                                      height: 24.hp,
                                      width: 24.wp,
                                    ),
                                    SizedBox(width: 12.wp),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.title,
                                            style: textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            data.body,
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: Colors.black87,
                                                  height: 1.5,
                                                  fontSize: 12,
                                                ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Image section
                                if (data.imageUrl.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        RepositoryProvider.of<CoOperative>(
                                              context,
                                            ).baseUrl +
                                            data.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: Icon(
                                                Icons.error_outline,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],

                                // Timestamp
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      data.date,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const NoDataScreen(
                  title: "No Notifications",
                  details: "You don't have any notifications at the moment.",
                );
              }
              if (state is CommonLoading) {
                return const CommonLoadingWidget();
              }
              return const NoDataScreen(
                title: "No Notifications",
                details: "You don't have any notifications at the moment.",
              );
            },
          );
        },
      ),
    );
  }
}
