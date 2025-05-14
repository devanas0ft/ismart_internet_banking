import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/model/movie_seat_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/widget/movie_transaction_success_screen.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class MovieBillPage extends StatelessWidget {
  final MovieDetails? movieDetails;
  final List<Seats?> selectedSeats;
  final String totalAmount;
  const MovieBillPage({
    super.key,
    this.movieDetails,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: MovieBillWidget(
        movieDetails: movieDetails,
        selectedSeats: selectedSeats,
        totalAmount: totalAmount,
      ),
    );
  }
}

// ignore: must_be_immutable
class MovieBillWidget extends StatelessWidget {
  final MovieDetails? movieDetails;
  final List<Seats?> selectedSeats;
  final String totalAmount;

  MovieBillWidget({
    Key? key,
    // required this.movieData,
    required this.selectedSeats,
    required this.movieDetails,
    required this.totalAmount,
  }) : super(key: key);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return PageWrapper(
      backgroundColor: CustomTheme.white,
      showBackButton: true,
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
          }
          if (state is! CommonLoading && _isLoading) {
            NavigationService.pop();
            _isLoading = false;
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
            final UtilityResponseData _response = state.data;
            if (_response.code == "M0000" ||
                _response.status.toLowerCase() == "Success" ||
                _response.message.toLowerCase().contains(
                  "success".toLowerCase(),
                )) {
              final List<String> selectedSeatNames =
                  selectedSeats.map((e) => e?.seatName ?? "").toList();

              NavigationService.pushReplacement(
                target: MovieTransactionSuccessPage(
                  transactionID: _response.findValueString(
                    "transactionIdentifier",
                  ),
                  // transactionID: "2674729494435403",
                  message: _response.message,
                  serviceName: "Movie",
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Movie",
                        value: movieDetails?.movieName ?? "",
                      ),
                      KeyValueTile(
                        title: "Duration",
                        value: movieDetails?.duration ?? "",
                      ),
                      KeyValueTile(
                        title: "Theater",
                        value: movieDetails?.theaterName ?? "",
                      ),
                      KeyValueTile(
                        title: "Theater Address",
                        value: movieDetails?.theaterAddress ?? "",
                      ),
                      KeyValueTile(
                        title: "Seats",
                        value: selectedSeatNames.toString(),
                      ),
                      KeyValueTile(title: "Total Amount", value: totalAmount),
                    ],
                  ),
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: _response.status,
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Booking Confirmation",
                  style: textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildTheaterInfo(textTheme),
              SizedBox(height: 20.hp),
              // _buildMovieInfo(textTheme),
              // SizedBox(height: 20.hp),
              _buildSeatInfo(textTheme),
              SizedBox(height: 20.hp),
              _buildTotalAmount(textTheme),
              SizedBox(height: 28.hp),
              CustomRoundedButtom(
                verificationAmount: totalAmount,
                title: "Proceed",
                onPressed: () {
                  final List<String> seatIds =
                      selectedSeats.map((seat) => seat?.seatId ?? "").toList();

                  NavigationService.push(
                    target: TransactionPinScreen(
                      onValueCallback: (p0) {
                        NavigationService.pop();

                        context.read<UtilityPaymentCubit>().makePayment(
                          mPin: p0,
                          serviceIdentifier: "",
                          apiEndpoint: "/api/movie/ticket/commit",
                          body: {
                            "showId": movieDetails?.showId ?? "",
                            "movieId": movieDetails?.movieId ?? "",
                            "processId": movieDetails?.processId ?? "",
                            "showDate": movieDetails?.showDate ?? "",
                            "showTime": movieDetails?.showTime ?? "",
                            "noOfSeat": selectedSeats.length.toString(),
                            "amount": totalAmount,
                            "seats": seatIds.toList(),
                          },
                          accountDetails: {
                            "account_number":
                                RepositoryProvider.of<CustomerDetailRepository>(
                                  context,
                                ).selectedAccount.value!.accountNumber,
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTheaterInfo(TextTheme textTheme) {
    return Card(
      color: CustomTheme.backgroundColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movieDetails?.theaterName ?? "",
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              movieDetails?.theaterAddress ?? "",
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(movieDetails?.movieName ?? "", style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '${movieDetails?.genre} | ${movieDetails?.duration}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: textTheme.bodySmall),
                    Text(
                      "${movieDetails?.showDate}",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time', style: textTheme.bodySmall),
                    Text(
                      movieDetails?.showTime ?? "",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Screen', style: textTheme.bodySmall),
                    Text(
                      movieDetails?.screenName ?? "",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(TextTheme textTheme) {
    return Card(
      color: CustomTheme.backgroundColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(movieDetails?.movieName ?? "", style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '${movieDetails?.genre} | ${movieDetails?.duration}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: textTheme.bodySmall),
                    Text(
                      "${movieDetails?.showDate}",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time', style: textTheme.bodySmall),
                    Text(
                      movieDetails?.showTime ?? "",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Screen', style: textTheme.bodySmall),
                    Text(
                      movieDetails?.screenName ?? "",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatInfo(TextTheme textTheme) {
    return Card(
      color: CustomTheme.backgroundColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seats', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  selectedSeats
                      .map(
                        (seat) => Chip(
                          label: Text(seat?.seatName ?? ""),
                          backgroundColor: Colors.grey[200],
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount(TextTheme textTheme) {
    return Card(
      color: CustomTheme.backgroundColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Amount', style: textTheme.titleLarge),
            Text(
              'Rs $totalAmount',
              style: textTheme.headlineSmall?.copyWith(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
