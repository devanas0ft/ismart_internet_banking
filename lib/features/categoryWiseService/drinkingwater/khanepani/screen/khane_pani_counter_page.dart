import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/khanepani/cubit/khanepani_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/khanepani/model/khanepani_model.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/khanepani/resources/khanepani_repository.dart';
import 'package:ismart_web/features/categoryWiseService/drinkingwater/khanepani/widget/select_counter_widget.dart';

class SelectKhanePaniCounterPage extends StatelessWidget {
  const SelectKhanePaniCounterPage({Key? key, required this.onBankSelected})
    : super(key: key);
  final Function(KhanePaniModel) onBankSelected;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => KhanePaniCubit(
                khanePaniRepository: RepositoryProvider.of<KhanePaniRepository>(
                  context,
                ),
              ),
        ),
      ],
      child: SelectCounterKhanePaniWidget(onBankSelected: onBankSelected),
    );
  }
}
