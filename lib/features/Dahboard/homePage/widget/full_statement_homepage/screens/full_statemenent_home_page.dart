import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/Dahboard/homePage/widget/full_statement_homepage/widgets/full_statement_home_widget.dart';
import 'package:ismart_web/features/statement/fullStatement/cubit/full_statement_cubit.dart';
import 'package:ismart_web/features/statement/fullStatement/resources/full_statement_repository.dart';

class FullStatemenentHomePage extends StatelessWidget {
  const FullStatemenentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FullStatementCubit(
            fullStatementRepository:
                RepositoryProvider.of<FullStatementRepository>(context),
          ),
      child: FullStatementHomeWidget(),
    );
  }
}
