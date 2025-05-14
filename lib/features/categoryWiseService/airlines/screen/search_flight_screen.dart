import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/cubit/airlines_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/resources/airlines_repository.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/search_flight_widget.dart';

class SearchFlightScreen extends StatelessWidget {
  final ServiceList service;

  const SearchFlightScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AirlinesCubit(
            airlinesRepository: RepositoryProvider.of<AirlinesRepository>(
              context,
            ),
          ),
      child: SearchFlightWidget(service: service),
    );
  }
}
