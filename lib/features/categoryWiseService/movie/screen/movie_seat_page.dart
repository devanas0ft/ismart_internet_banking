import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/movie_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/movie/resource/movie_repository.dart';
import 'package:ismart_web/features/categoryWiseService/movie/widget/movie_seat_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class MovieSeatPage extends StatelessWidget {
  final String processId;
  final String showId;
  final String movieId;

  const MovieSeatPage({
    super.key,
    required this.processId,
    required this.showId,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => MovieCubit(
                movieRepository: RepositoryProvider.of<MovieRepository>(
                  context,
                ),
              )..fetchMovieSeat(
                serviceIdentifier: "",
                accountDetails: {
                  "showId": showId,
                  "processId": processId,
                  "movieId": movieId,
                },
                apiEndpoint: "/api/movie/seat/info",
              ),
        ),
        BlocProvider(
          create:
              (context) => UtilityPaymentCubit(
                utilityPaymentRepository:
                    RepositoryProvider.of<UtilityPaymentRepository>(context),
              ),
        ),
      ],
      child: const MovieSeatWidget(),
    );
  }
}
