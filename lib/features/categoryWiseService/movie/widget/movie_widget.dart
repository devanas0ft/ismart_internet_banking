import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/screen/movie_time_detail_page.dart';
import 'package:ismart_web/features/categoryWiseService/movie/widget/movie_detail_box.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class MovieWidget extends StatefulWidget {
  final ServiceList service;

  const MovieWidget({Key? key, required this.service}) : super(key: key);

  @override
  State<MovieWidget> createState() => _MovieWidgetState();
}

class _MovieWidgetState extends State<MovieWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: CommonContainer(
        showDetail: true,
        verticalPadding: 0,
        horizontalPadding: 0,
        topbarName: widget.service.serviceCategoryName,
        showRoundBotton: false,
        body: BlocConsumer<UtilityPaymentCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonLoading && _isLoading == false) {
              _isLoading = true;
              showLoadingDialogBox(context);
            } else if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
            }
            if (state is CommonError) {
              showPopUpDialog(
                context: context,
                message: state.message,
                title: "Error",
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }

            if (state is CommonStateSuccess<UtilityResponseData>) {
              final _response = state.data;
              if (_response.status.toLowerCase() == "Success".toLowerCase()) {
              } else {
                showPopUpDialog(
                  context: context,
                  message: _response.message,
                  title: "Message",
                  buttonCallback: () {
                    NavigationService.pop();
                  },
                  showCancelButton: false,
                );
              }
            }
          },
          builder: (context, state) {
            if (state is CommonStateSuccess<UtilityResponseData>) {
              final List response = state.data.findValue(primaryKey: "movies");

              return Center(
                child: Wrap(
                  children: List.generate(
                    response.length,
                    (index) => MovieDetailBox(
                      onContainerPress: () {
                        NavigationService.push(
                          target: MovieTimeDetailPage(
                            selectedMovie: response[index],
                            processId:
                                state.data
                                    .findValue(primaryKey: "processId")
                                    .toString(),
                            showId: response[index]["movieId"].toString(),
                          ),
                        );
                      },
                      containerImage: response[index]["poster"],
                      height: 185.hp,
                      title: response[index]["movieName"],
                    ),
                  ),
                ),
              );
            } else if (state is CommonError) {
              return NoDataScreen(title: "Error", details: state.message);
            } else if (state is CommonLoading) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [CommonLoadingWidget()],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
