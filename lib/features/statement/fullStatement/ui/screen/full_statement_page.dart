import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/statement/fullStatement/cubit/full_statement_cubit.dart';
import 'package:ismart_web/features/statement/fullStatement/resources/full_statement_repository.dart';
import 'package:ismart_web/features/statement/fullStatement/ui/widget/full_statement_widget.dart';

class FullStatementPage extends StatefulWidget {
  @override
  State<FullStatementPage> createState() => _FullStatementPageState();
}

class _FullStatementPageState extends State<FullStatementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => FullStatementCubit(
            fullStatementRepository:
                RepositoryProvider.of<FullStatementRepository>(context),
          ),
      child: FullStatementWidget(),
    );
  }
}
