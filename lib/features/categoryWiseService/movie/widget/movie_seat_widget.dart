import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/snack_bar_utils.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/model/movie_seat_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/model/movie_seat_select_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/movie_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/movie/widget/count_down_movie_widget.dart';
import 'package:ismart_web/features/categoryWiseService/movie/widget/movie_bill_confirm_widget.dart';

class MovieSeatWidget extends StatefulWidget {
  const MovieSeatWidget({super.key});

  @override
  State<MovieSeatWidget> createState() => _MovieSeatWidgetState();
}

class _MovieSeatWidgetState extends State<MovieSeatWidget> {
  bool _isLoading = false;
  Seats? currentSeatId;
  List<Seats?> selectedSeatList = [];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return PageWrapper(
      showAppBar: false,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      body: SafeArea(
        child: BlocListener<MovieCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonError) {
              _isLoading = false;
              NavigationService.pop(); // Navigate back
              SnackBarUtils.showErrorBar(
                context: context,
                message: state.message.toString(),
              );
            }
            if (state is CommonLoading && !_isLoading) {
              _isLoading = true;
              showLoadingDialogBox(context);
            } else if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
            }
            if (state is CommonStateSuccess<MovieSeatSelectModel>) {
              final MovieSeatSelectModel res = state.data;

              if (res.code == "M0000") {
                setState(() {
                  if (selectedSeatList.contains(currentSeatId)) {
                    selectedSeatList.remove(currentSeatId);
                    subtractTotalAmount(
                      ticketPrice: double.parse(currentSeatId?.price ?? "0"),
                    );
                  } else {
                    selectedSeatList.add(currentSeatId);
                    addTotalAmount(
                      ticketPrice: double.parse(currentSeatId?.price ?? "0"),
                    );
                  }
                });
                // SnackBarUtils.showSuccessBar(
                //     context: context, message: res.message ?? "");
              } else {
                SnackBarUtils.showErrorBar(
                  context: context,
                  message: res.message ?? "",
                );
              }
            } else if (state is CommonError) {
              SnackBarUtils.showErrorBar(
                context: context,
                message: state.message.toString(),
              );
            }
          },
          child: BlocBuilder<MovieCubit, CommonState>(
            buildWhen: (previous, current) {
              return current is CommonStateSuccess<MovieSeatModel>;
            },
            builder: (context, state) {
              if (state is CommonStateSuccess<MovieSeatModel>) {
                final MovieSeatModel res = state.data;
                if (res.code == "M0000") {
                  final List<SeatRows> seatRowList =
                      res.details?.seatRows ?? [];

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1.5,
                          vertical: 16,
                        ),
                        // color: CustomTheme.testAppColor,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                return await showExitAlertDialogue();
                              },
                              icon: const Icon(
                                CupertinoIcons.back,
                                // color: CustomTheme.white,
                              ),
                            ),
                            SizedBox(width: 1.5.h),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    res.details?.movieName ?? "",
                                    style: _textTheme.titleLarge!
                                    // .copyWith(color: Colors.white),
                                    .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: .7.h),
                                  Text(
                                    "${res.details!.theaterName} || ${res.details!.theaterAddress}",
                                    style: _textTheme.titleSmall!
                                    // .copyWith(color: Colors.white),
                                    .copyWith(fontSize: 12),
                                  ),
                                  Text(
                                    "${res.details!.showDate} || ${res.details!.showTime} || ${res.details!.duration}",
                                    style: _textTheme.titleMedium!
                                    // .copyWith(color: Colors.white),
                                    .copyWith(
                                      fontSize: 12,
                                      color: CustomTheme.darkGray.withOpacity(
                                        0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      TimerScreen(
                        minutes: int.parse(res.details?.holdTime ?? "5"),
                      ),
                      // const Divider(),
                      SizedBox(height: 1.h),
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      seatRowList.map((seatRow) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                              (seatRow.seats ?? []).map((seat) {
                                                return buildSeat(
                                                  seat,
                                                  seatRow.category.toString(),
                                                  res,
                                                );
                                              }).toList(),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 5.h,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.lightBlue.shade200.withOpacity(0.7),
                              Colors.lightBlue.shade200,
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white54,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Transform.scale(
                              scaleY: 0.9,
                              child: Text(
                                "Screen This Side",
                                textAlign: TextAlign.center,
                                style: _textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          seatStatusValue.length,
                          (index) => Column(
                            children: [
                              Container(
                                height: 20.hp,
                                width: 20.wp,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: SvgPicture.asset(
                                  Assets.movieSeatIcon,
                                  colorFilter: ColorFilter.mode(
                                    checkSeatStatus(
                                      seatStatusValue[index]
                                          .toString()
                                          .toLowerCase(),
                                    ),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Text(seatStatusValue[index].toString()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      if (selectedSeatList.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: CustomTheme.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: CustomTheme.darkerBlack),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7.0,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Total"),
                                  Text(
                                    "Rs $totalPrice",
                                    style: _textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              title: Column(
                                children: [
                                  const Text("Selected Seats: "),
                                  Wrap(
                                    children: List.generate(
                                      selectedSeatList.length,
                                      (index) => Text(
                                        (selectedSeatList[index]?.seatName ??
                                                "") +
                                            " ",
                                        style: _textTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  NavigationService.push(
                                    target: MovieBillPage(
                                      totalAmount: totalPrice.toString(),
                                      movieDetails: res.details,
                                      selectedSeats: selectedSeatList,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 26,
                                  ),
                                  margin: const EdgeInsets.all(4),
                                  child: Text(
                                    "Book",
                                    style: _textTheme.displaySmall!.copyWith(
                                      color: CustomTheme.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: CustomTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return PageWrapper(
                    showBackButton: true,
                    body: NoDataScreen(
                      title: res.code ?? "",
                      details: res.message ?? "No Data Found",
                    ),
                  );
                }
              } else if (state is CommonError) {
                return NoDataScreen(title: "Error", details: state.message);
              } else if (state is CommonLoading) {
                return const CommonLoadingWidget();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildSeat(Seats seat, String category, MovieSeatModel res) {
    final seatId = seat.seatId;
    return InkWell(
      onTap: () {
        if (seatId != null &&
            seat.status != "sold" &&
            seat.status != "reserved") {
          currentSeatId = seat;
          final seatIdLists =
              selectedSeatList.map((seat) => seat?.seatId ?? "").toList();

          context.read<MovieCubit>().selectSeat(
            serviceIdentifier: "",
            accountDetails: {
              "processId": res.details?.processId ?? " ",
              "movieId": res.details?.movieId ?? "",
              "seatId": seatId,
              "seatCategory": category,
              "showId": res.details?.showId.toString(),
            },
            body: {},
            apiEndpoint:
                seatIdLists.contains(seatId)
                    ? "/api/movie/seat/unselect"
                    : "/api/movie/seat/select",
            mPin: "",
          );
        }
      },
      child:
          seatId != null
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 25.hp,
                    width: 25.wp,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: SvgPicture.asset(
                      Assets.movieSeatIcon,
                      colorFilter: ColorFilter.mode(
                        selectedSeatList.contains(seat)
                            ? checkSeatStatus("selected")
                            : checkSeatStatus(seat.status.toString()),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Text(
                    seat.seatName.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              )
              : SizedBox(height: 29.hp, width: 29.wp),
    );
  }

  final List<String> seatStatusValue = [
    "Available",
    "Selected",
    "Sold",
    "Reserved",
  ];
  double totalPrice = 0;
  addTotalAmount({required double ticketPrice}) {
    final double res = totalPrice + ticketPrice;
    totalPrice = res;
  }

  subtractTotalAmount({required double ticketPrice}) {
    final double res = totalPrice - ticketPrice;
    totalPrice = res;
  }

  Color checkSeatStatus(final String seatStatus) {
    switch (seatStatus) {
      case "available":
        return Colors.green;
      case "sold":
        return Colors.red;
      case "reserved":
        return Colors.grey;
      case "selected":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  showExitAlertDialogue() {
    showPopUpDialog(
      context: context,
      message: "Are you sure you want to exit?",
      title: "Exit",
      buttonCallback: () {
        NavigationService.pushUntil(target: DashboardWidget());
      },
      buttonText: "Exit",
      showCancelButton: true,
    );
  }
}
