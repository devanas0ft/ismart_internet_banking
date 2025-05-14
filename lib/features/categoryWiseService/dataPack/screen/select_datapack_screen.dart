import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/cubit/datapack_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/resources/datapack_repository.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/widget/select_datapack_widget.dart';

class SelectDatapackScreen extends StatelessWidget {
  final ServiceList service;
  const SelectDatapackScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => DatapackCubit(
            datapackRepository: RepositoryProvider.of<DatapackRepository>(
              context,
            ),
          ),
      child: SelectDatapackWidget(service: service),
    );
  }
}
