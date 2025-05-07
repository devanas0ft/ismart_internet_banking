import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/features/auth/cubit/login_cubit.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';

class MultiBlocWrapper extends StatelessWidget {
  final Widget child;
  final String env;
  const MultiBlocWrapper({super.key, required this.child, required this.env});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => LoginCubit(
                userRepository: RepositoryProvider.of<UserRepository>(context),
              ),
        ),
      ],
      child: child,
    );
  }
}
