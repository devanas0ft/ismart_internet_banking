part of 'startup_cubit.dart';

abstract class StartupState extends Equatable {
  const StartupState();

  @override
  List<Object> get props => [];
}

class StartupInitial extends StartupState {}

class StartupLoading extends StartupState {}

class StartupSuccess extends StartupState {
  final bool isFirstTime;
  final bool isLogged;

  const StartupSuccess({
    required this.isFirstTime,
    required this.isLogged,
  });
}
