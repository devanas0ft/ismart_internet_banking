import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/statement/miniStatement/cubit/mini_statement_cubit.dart';
import 'package:ismart_web/features/statement/miniStatement/resources/mini_statement_repository.dart';
import 'package:ismart_web/features/statement/miniStatement/ui/widget/mini_statement_widget.dart';

class MiniStatementPage extends StatefulWidget {
  const MiniStatementPage({Key? key}) : super(key: key);

  @override
  State<MiniStatementPage> createState() => _MiniStatementPageState();
}

class _MiniStatementPageState extends State<MiniStatementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => MiniStatementCubit(
            miniStatementRepository:
                RepositoryProvider.of<MiniStatementRepository>(context),
          ),
      child: const MiniStatementWidget(),
    );
  }
}
