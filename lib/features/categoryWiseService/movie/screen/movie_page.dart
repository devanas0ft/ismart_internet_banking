import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/constants/slugs.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/movie/widget/movie_widget.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/resources/utility_payment_repository.dart';

class MoviePage extends StatelessWidget {
  final CategoryList category;

  const MoviePage({super.key, required this.category});

  ServiceList getMovieService() {
    final movieService = category.services.firstWhere(
      (element) => element.uniqueIdentifier == Slugs.movieBooking,
    );
    return movieService;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          )..fetchDetails(
            serviceIdentifier: getMovieService().uniqueIdentifier,
            accountDetails: {},
            apiEndpoint: "/api/movie",
          ),
      child: MovieWidget(service: getMovieService()),
    );
  }
}
